# Linear Regression with R

This course will introduce you to linear regression. It will help to develop your theoretical understanding and practical skills for running simple and multiple regression models in R.

Linear regression models are statistical tools that help us understand linear relationships between different factors. This is particularly useful when your aim is to investigate the influence of one or more predictor factors (e.g., sugar consumption) on a particular variable that we are interested in (AKA. an outcome variable; e.g., diagnosis of diabetes).

This course includes two 2-hour sessions. Each session includes both concuptual discussions about the rationale of regression modelling and R programming practical. Using real data collected by the Scottish Government, we will explore how different aspects of everyday living are related. 

By the end of the course, you will understand the following concepts of LMMs and know how to construct linear regressions in R.  

- Basic Concepts 
- Model Structure 
- Model Results Interpretation  
- Model Comparison and Selection
- Model Assumption Chekcs

This course is an intermediate-level training course. It requires a basic understanding of R and inferential statistics. Relevant R packages including "tidyverse",  "effects" and "sjPlot" should be downloaded and installed prior to participating in this workshop.

# Getting Set-up

# Installing R and Packages needed 
## Installing R and R Studio
### For R On Noteable

1. Go to https://noteable.edina.ac.uk/login
2. Login with your EASE credentials
3. Select RStudio as a personal notebook server and press start
4. Go to File > New Project> Version Control > Git
5. Copy and Paste this repository URL [https://github.com/DCS-training/RegressionAndMixedEffectsModelling](https://github.com/DCS-training/Linear-Regression)](https://github.com/DCS-training/Linear-Regression) as the Repository URL (The Project directory name will filled in automatically but you can change it if you want your folder in Notable to have a different name).
6. Decide where to locate the folder. By default, it will locate it in your home directory
7. Press Create Project
Congratulations you have now pulled the content of the repository on your Notable server space.

### Install it locally
1. Go to (https://www.r-project.org/)[https://www.r-project.org/]
2. Go to the download link
3. Choose your CRAN mirror nearer to your location (either Bristol or Imperial College London)
4. Download the correspondent version depending if you are using Windows Mac or Linux
- For Windows click on install R for the first time. Then download R for Windows and follow the installation widget. If you get stuck follow this (video tutorial)[https://www.youtube.com/watch?v=GAGUDL-4aVw]
- For Mac Download the most recent pkg file and follow the installation widget. If you get stuck follow this (video tutorial)[https://www.youtube.com/watch?v=EmZqlcKkJMM]
5. Once R is installed you can install R studio (R interface)
6. Go to (www.rstudio.com)[www.rstudio.com]
7. Go in download
8. Download the correspondent version depending on your Operating system and install it. If you get stuck check the videos linked above. 

## Install the libraries 
```
install.packages("tidyverse")
install.packages("effects") 
install.packages("sjPlot") 


library("tidyverse") #for cleaning and sorting out data
library("effects") #for creating tables and graphics that illustrate effects in linear models
library("sjPlot") #for plotting models

``` 

# What you are going to find in this repo
Once ready, you are going to find 

-  .ppt presentations used during the course
-  example code 


# Author
 Fang Jackson-Yang

# Copyright

This repository has a [![License: CC BY-NC 4.0](https://licensebuttons.net/l/by-nc/4.0/80x15.png)](https://creativecommons.org/licenses/by-nc/4.0/) license
