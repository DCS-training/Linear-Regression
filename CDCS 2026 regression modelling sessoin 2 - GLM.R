
install.packages("dplyr")
install.packages("rlang")
install.packages("lme4")
install.packages("ggeffects")
install.packages("effects")

library(lme4)
library(nadiv)
library(tidyverse)
library(broom)
library(ggplot2) 
library(effects)
library(readr)


##################################################################################
##################################################################################
##################################################################################
############## IGtime data #######################################################
##################################################################################
##################################################################################

# load the dataset into R

data_IGtime <- read.csv("IGtime data.csv")

# check variables 
summary(data_IGtime)
str(data_IGtime)
is.na(data_IGtime$Occupation)

# set categorical variable as factor
data_IGtime$Participant<-as.factor(data_IGtime$Participant)


data_IGtime$Occupation<-as.factor(data_IGtime$Occupation)
summary(data_IGtime)
str(data_IGtime)

data_IGtime$TikTok.user<-as.factor(data_IGtime$TikTok.user)

summary(data_IGtime)

##############################################################################################
########################################## RQ1: ##############################################
############################### daily IGtime ~ occupation ####################################
##############################################################################################

# do student, FT_employee and retired people differ in the amount of time they spent on IG ? 


# visualise data 
with(data_IGtime, plot(time_on_Instagram_daily ~ Occupation))


# plot data
ggplot(data_IGtime, aes(x=Occupation, y=time_on_Instagram_daily)) +
  geom_point(data = data_IGtime, aes(Occupation, time_on_Instagram_daily), colour = 'darkgreen', size = 3)+ 
  ggtitle(label = "Average time spent on Instagram daily by different groups")+
  labs(y = "Time", 
       x= "Occupation" )+ 
  theme(plot.title = element_text(hjust = 0.5, size=18,face = "bold"),
        axis.text.x = element_text(size=14,face = "bold"),
        axis.title.x = element_text(size=16,face = "bold"),
        axis.title.y = element_text(size=16,face = "bold"),
        legend.title = element_text(size=16,face = "bold"),
        legend.text = element_text(size=12,face = "bold")
  )

### plot data with mean

##calculate mean and sd
ds <- do.call(rbind, lapply(split(data_IGtime, data_IGtime$Occupation), function(d) {
  data.frame(mean = mean(d$time_on_Instagram_daily), sd = sd(d$time_on_Instagram_daily), Occupation = d$Occupation)
}))

## plot data with mean
ggplot(data_IGtime, aes(x=Occupation, y=time_on_Instagram_daily)) +
  geom_point(data = data_IGtime, aes(Occupation, time_on_Instagram_daily), colour = 'darkgreen', size = 3)+ 
  geom_point(data = ds, aes(x=Occupation, y=mean), col="orange", size=5) +
    ggtitle(label = "Average time spent on Instagram daily by different groups")+
  labs(y = "Time", 
       x= "Occupation" )+ 
  theme(plot.title = element_text(hjust = 0.5, size=18,face = "bold"),
        axis.text.x = element_text(size=14,face = "bold"),
        axis.title.x = element_text(size=16,face = "bold"),
        axis.title.y = element_text(size=16,face = "bold"),
        legend.title = element_text(size=16,face = "bold"),
        legend.text = element_text(size=12,face = "bold")
  )



## plot data with error bars as well
ggplot(data_IGtime, aes(x=Occupation, y=time_on_Instagram_daily)) +
  geom_point(data = data_IGtime, aes(Occupation, time_on_Instagram_daily), colour = 'darkgreen', size = 3)+ 
  geom_point(data = ds, aes(x=Occupation, y=mean), col="orange", size=5) +
  geom_errorbar(
    data = ds,
    aes(Occupation, mean, ymin = mean - sd, ymax = mean + sd),
    colour = 'orange', size=0.73, width = 0.2
    )+
  ggtitle(label = "Average time spent on Instagram daily by different groups")+
  labs(y = "Time", 
       x= "Occupation" )+ 
  theme(plot.title = element_text(hjust = 0.5, size=18,face = "bold"),
        axis.text.x = element_text(size=14,face = "bold"),
        axis.title.x = element_text(size=16,face = "bold"),
        axis.title.y = element_text(size=16,face = "bold"),
        legend.title = element_text(size=16,face = "bold"),
        legend.text = element_text(size=12,face = "bold")
  )


### looks like there is a clear different between the mean time of the three groups. 
### occupation (operationalised as undergraduate/FT_employee/retired) as a fixed effect seems to 
### have an effect on how much time spent on IG  (Note having an effect does not mean causal 
### relation)
### systematic difference 

### but are these differences just numeric differences? or they are qualitatively different from ### each other - in stats words, are they significant statistically ?

# linear model
# formula : time spent on Instagram ~ occupation

### to fit a linear model in R
m_time= lm (time_on_Instagram_daily ~ Occupation, data_IGtime)

summary(m_time)


contr.sum(3)

contrasts(data_IGtime$Occupation) <- contr.sum(3)
summary(data_IGtime$Occupation)

contrasts(data_IGtime$Occupation)

m_time= lm (time_on_Instagram_daily ~ Occupation, data_IGtime)
summary(m_time)
# results
# Multiple R-squared:  0.796,	Adjusted R-squared:  0.7869 
### interpretation:  Multiple R-squared:  0.796 --- that the variance accounted for. 
### 79% of teh stuff that is heppending in teh dataset is explained by the model
### because in the model there is only one factor, it means that 79% of the stuff that is happening ### in the dataset (i.e. time difference) is explained by group differeces among FT_employee, 
### retired and undergraduates
### the adjusterd r-squared value not only looks are how much variance is "explained", but also at how many fixed effects you used to do teh explaining. the R squared value can be much lower if we have a lot of fixed efffects. 

# F-statistic: 87.79 on 2 and 45 DF,  p-value: 2.929e-16
### interpretation: the o-value for the overall model, considers all effects together
### it is signifiant at  alpha=0 level. meaning that it significantly differ from null 
### chance to get this kind of data if the the null model is ture is almost 0, rejecting teh null ### model, so supporting our hypothesis that the predictor variable does show an effect
### the p-value is a conditional probability, that is a probability under the condition that teh ### null hypothesis is true. in other words, assuming the model is doing nothing, the probability ### of observing this kind of data 


#visualise model
ef<-as.data.frame(effect("Occupation", m_time))
ggplot(ef, aes(Occupation, fit)) + 
  geom_pointrange(aes(ymax=upper, ymin=lower),col = "skyblue", size=1.5, position = position_dodge(width = 0.2))+
  ggtitle(label = "Predicted average time spent on Instagram daily by different groups")+
  labs(y="Model_estimated mean and variability", x="Occupation")+
  theme(plot.title = element_text(hjust = 0.5, size=16,face = "bold"),
        axis.text.x = element_text(size=12,face = "bold"),
        axis.title.x = element_text(size=14),
        axis.title.y = element_text(size=14),
        legend.title = element_text(size=14,face = "bold"),
        legend.text = element_text(size=10,face = "bold"))






#################################################
#################################################
# Generalised linear model
# hypothsis: Ticktop.user ~ time_on_Instagram_daily


table(data_IGtime$TikTok.user, data_IGtime$time_on_Instagram_daily, useNA="ifany")


# plot data Tiktok User ~ time spent on Instagram
ggplot(data_IGtime, aes(y=TikTok.user, x=time_on_Instagram_daily)) +
  geom_point(data = data_IGtime, aes(time_on_Instagram_daily, TikTok.user), colour = 'darkgreen', size = 3)+ 
  ggtitle(label = "TikTok user and time spent on Instagram")+
  labs(y = "TikTok user or not", 
       x= "time spent on Instagram" )+
  theme(plot.title = element_text(hjust = 0.5, size=18,face = "bold"),
        axis.text.x = element_text(size=14,face = "bold"),
        axis.title.x = element_text(size=16,face = "bold"),
        axis.title.y = element_text(size=16,face = "bold"),
        legend.title = element_text(size=16,face = "bold"),
        legend.text = element_text(size=12,face = "bold"))


# It looks like people spend more time on Instagram also tend to have an account on TikTok.
# build a GLM model to check this statistically


m_TikTok = glm(TikTok.user ~ time_on_Instagram_daily,
               data = data_IGtime,
               family='binomial',
               na.action=na.exclude)


summary(m_TikTok)


# evaluating the model (by comparing it to null model using Chisq test)
anova(m_TikTok, test = "Chisq")


###                           Df Deviance Resid. Df   Resid. Dev  Pr(>Chi)    
###  NULL                                        47     65.203              
### time_on_Instagram_daily    1   32.335        46     32.868 1.298e-08 ***

### this means knowing about the time someone spent on Instagram improve our ability to estimate
### the probability of the person being a TikTok user.


#### interpret model coefficients


## Coefficients:
##                            Estimate Std. Error z value Pr(>|z|)    
## (Intercept)               -6.06312    1.78521  -3.396 0.000683 ***
##  time_on_Instagram_daily   0.20027    0.05522   3.627 0.000287 ***

# odds of being a TikTok user for time_spent_on_Insta=0, is e(-6.06312)
# for each additional minute of time spent on Instagram daily, odds are 
# multiplied by e(0.20027), which is the equivalent of e(-6.06312 + 0.20027)

# for 20mins additional time spent on Instagram daily, odds are multiplied
# by e(-6.06312) * e^(-6.06312+0.20027)^(20), which is the equivalent of 
# e^(-6.06312+20*0.20027)
# calculate the probability of someone being a tiktop user if they spent 
# x min spent on IG

summary(m_TikTok)

coef(m_TikTok)[2]

exp(coef(m_TikTok)[1] + x * coef(m_TikTok)[2])

exp(coef(m_TikTok)[1] + 20 * coef(m_TikTok)[2]) / (1 + exp(coef(m_TikTok)[1] + 20 * coef(m_TikTok)[2]) )

# transfer logit odds to probability
# prob(x) = odds(x) / (1 + odds(x))
# so the probability of being a TikTok user for someone who spents 20mins on Instagram daily is  

exp(-6.06312+20*0.20027) / (1 + exp(-6.06312 + 20*0.20027))

exp(-6.06312+30*0.20027) / (1 + exp(-6.06312 + 30*0.20027))



# handy function
logit.to.prob <- function (logits) {
  exp(logits) / (exp(logits) + 1)
}


# now use this function to check the intercept
logit.to.prob(-6.06312)
# 0.002, i.e. 0.2%  # when someone spent 0 minute on Instagram daily, the probability for the person to be a TikTok user is very low, only 0.2%


# for each additional minute spent on Instagram, the probability for the person to be a TikTok user increases by 
logit.to.prob(-6.06312  + 0.20027) # # 0.0028, i.e. 0.3%

logit.to.prob(-6.06312  + 20*0.20027)  # 0.11
# someone spent 20mins on Instagram, probabliy for them to be a TikTok user is 11% 

logit.to.prob(-6.06312  + 50*0.20027) # 0.98
# someone spent 50mins on Instagram, probabliy for them to be a TikTok user is 98% 

#### plot the glm() model
#### method 1
x <- seq (min(data_IGtime$time_on_Instagram_daily), max(data_IGtime$time_on_Instagram_daily), 
 length.out = 58)
y <- logit.to.prob(-6.06312 + x * 0.20027)
par(mfrow=c(1,1))
plot(y ~ x,      
     ylim= c(0, 2),
     #xlim=range(c(1, 58)),
     col= "orange", type="l", lty=2, lwd=2, 
     main = "Probability of being a TikTok user as relevant to daily time spent on Instagram",
     xlab = "Time spent on Instagram daily", 
     ylab = "Model_predicted probability of being a TikTok user")
points(data_IGtime$TikTok.user ~ data_IGtime$time_on_Instagram_daily , pch=19,col=c("darkgreen"))


# plot the glm()  model
# method 2
y2 <- fitted(m_TikTok)
plot(y2[order(data_IGtime$time_on_Instagram_daily)] ~ data_IGtime $time_on_Instagram_daily [order(data_IGtime$time_on_Instagram_daily)],
     ylim=range( c(0, 2) ),
     xlim=range(c(1, 58)),
     main = "Probability of being a TikTok user as relevant to daily time spent on Instagram",
     xlab= "Time spent on Instagram daily", 
     ylab = "Predicted probability of being a TikTok user",
     col = "orange",type="l", lty=2,lwd=2)
points(data_IGtime$TikTok.user ~ data_IGtime$time_on_Instagram_daily , pch=19,col=c("darkgreen"))
 
############################################################################
##################### explain model assumptions ############################
############################################################################

########################
##### check lm() model - time_on_Instagram_daily ~ occupation####

plot(fitted(m_time), residuals(m_time))

## check linearity
plot(m_time, which=1, main = "Linearity")

## check nomarlity of residuals
hist(residuals(m_time), main = "Normality of Residuals - histgram", breaks = 20)

plot(density(residuals(m_time)), main="Normality of Residuals - Density")   # bell-curve

# a useful way to check any distribution is a QQ plot
plot(m_time, which = 2, main = "Normality of Residuals - Q-Q plot")


# homogeneity of variance
plot(m_time, which=3, main = "Homogeneity of Variance")

## put all four together
par(mfrow=c(2,2))
plot(m_time, which=c(1:4))


#######################
##### check glm() model - TikTok.user ~ time_spent_on_Instagram_daily ####

plot(fitted(m_TikTok), residuals(m_TikTok))

## check linearity
plot(m_TikTok, which=1, main = "Linearity")


par(mfrow=c(1,2))
plot(m_TikTok, which=c(1, 4))

library(performance)
performance::check_model(m_TikTok)
