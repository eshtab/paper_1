#### Preamble ####
# Purpose: Downloads required data for traffic delay dataset
# Author: Eshta Bhardwaj
# Data: January 29 2023
# Contact: eshta.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to know info for downloading dataset from open data toronto


#### Workspace setup ####
# install.packages("tidyverse") 

library(tidyverse) # A collection of data-related packages
library(opendatatoronto) # to download data from open data toronto


# get package
package <- show_package("e271cdae-8788-4980-96ce-6a5c95bc6618")
package

# get all resources for this package
resources <- list_package_resources("e271cdae-8788-4980-96ce-6a5c95bc6618")

# filter the datasets of interest by filename
datastore_resources <-  resources %>% filter(grepl('2022', name))

# load the datastore resource
bus_delay_2022 <- filter(datastore_resources, row_number()==1) %>% get_resource()
bus_delay_2022

# save the raw data into csv format
write_csv(
  x = bus_delay_2022,
  file = "inputs/data/raw_data.csv",
  
)
