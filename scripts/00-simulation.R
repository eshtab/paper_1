#### Preamble ####
# Purpose: Simulates bus delay dataset
# Author: Eshta Bhardwaj
# Data: January 29 2023
# Contact: eshta.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
# install.packages("tidyverse") 

library(tidyverse) # A collection of data-related packages

# the simulated data has to have the date of the delay,
# why the delay happened and how long the delay was
#### Simulate ####
set.seed(520)

simulated_data <-
  tibble(
    #  simulate bus delay data for all of 2020 
    date = rep(x = as.Date("2022-01-01") + c(0:364)),
    # Based on Eddelbuettel: https://stackoverflow.com/a/21502386
    "Reason" = sample(
      x = c(
        "Security Issue",
        "Weather",
  
      "Operational Issue",
        "Mechanical Issue",
        "Collision"
      ),
      size = 365,
      replace = TRUE
    ),
    delay_time = runif(
      n = 365,
      min = 5,
      max = 500
      ) # Delay time can be between 5-500 mins
  )

simulated_data
