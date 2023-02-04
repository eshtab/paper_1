# install.packages("tidyverse")
library(tidyverse)
library(janitor)
library(modelsummary)
library(lubridate)

# read in data from inputs folder of R project
raw_ttcdelay_data <-
  read_csv(
    file = "inputs/data/raw_data.csv",
    show_col_types = FALSE,
  )

# Make the names easier to type
ttcdelay_data <-
  clean_names(raw_ttcdelay_data)

# look at unique values for each column
unique(ttcdelay_data$route)
unique(ttcdelay_data$time)
unique(ttcdelay_data$day)
unique(ttcdelay_data$location)
unique(ttcdelay_data$incident)
unique(ttcdelay_data$min_delay)
unique(ttcdelay_data$min_gap)
unique(ttcdelay_data$direction)
unique(ttcdelay_data$vehicle)

# remove unneeded rows
filtered_ttcdelay_data <- ttcdelay_data |>
  select(date, time, day, incident, min_delay)

cleaned_ttcdelay_data <-
  filtered_ttcdelay_data |>
  mutate(
    day = factor(day),
    day = fct_relevel(
      day,
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    )
  )

# remove rows with min_delay > 120
cleaned_ttcdelay_data <-
  cleaned_ttcdelay_data |>
  filter(min_delay < 121)


### summaries ###
# totals
total_delay_mins <- print(sum(cleaned_ttcdelay_data$min_delay))
total_num_accidents <- print(nrow(cleaned_ttcdelay_data))

# what type of delay occurs most
cleaned_ttcdelay_data |>
  ggplot(mapping = aes(x = incident)) +
  geom_bar() +
  labs(
    title = "Most Common TTC Delay Reason",
    x = "Incident",
    y = "Number of Delays"
  ) +
  theme_classic() +
  # https://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
scale_fill_brewer(palette = "Set1")

#### delay frequency and temporality ###

# separate data into day, month, year
cleaned_ttcdelay_data <- 
  cleaned_ttcdelay_data |> 
  separate(
    col = date, 
    into = c("year", "month", "day_num"),
    sep = "-",
    remove = FALSE
  ) |>
  # remove year b/c all incidents occurred in 2022
  select(-year)

# what month do delays occur most
cleaned_ttcdelay_data |>
  ggplot(mapping = aes(x = month)) +
  geom_bar() +
  labs(
    title = "Number of Delays by Month",
    x = "Month",
    y = "Number of Delays"
  ) +
  theme_classic() +
  scale_fill_brewer(palette = "Set1")

# what day do delays occur most
cleaned_ttcdelay_data |>
  ggplot(mapping = aes(x = day)) +
  geom_bar() +
  labs(
    title = "Number of Delays by Day",
    x = "Day of Week",
    y = "Number of Delays"
  ) +
  theme_classic() +
  scale_fill_brewer(palette = "Set1")

# what time do delays occur most
cleaned_ttcdelay_data |>
  ggplot(mapping = aes(x = time)) +
  geom_bar() +
  labs(
    title = "Number of Delays by Time",
    x = "Time of Day",
    y = "Number of Delays"
  ) +
  theme_classic() +
  scale_fill_brewer(palette = "Set1")

#### severity of delays  ####

# what month has the longest delays
cleaned_ttcdelay_data |>
  ggplot(mapping = aes(x = month, y = min_delay)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Month with Longest Delays",
    x = "Month",
    y = "Total Delay Time (minutes)"
  ) +
  theme_classic() +
  scale_fill_brewer(palette = "Set1")

# Reason causing longest delays 
options(scipen = 999) 
cleaned_ttcdelay_data |>
  ggplot(mapping = aes(x = incident, y = min_delay)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Incident Type with Total Delay Caused",
    x = "Reason",
    y = "Total Delay Time (minutes)"
  ) +
  theme_classic() +
  # https://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
scale_fill_brewer(palette = "Set1")

# Breakdown of 3 incident type that causes the most delays by day of week?
incident_filter_ttcdelay_data <-
  cleaned_ttcdelay_data |>
  filter(incident == 'Diversion' | incident == 'Mechanical' | incident == 'Operations - Operator')


incident_filter_ttcdelay_data |>
  ggplot(mapping = aes(x = day)) +
  geom_bar() +
  labs(
    title = "Number of Delays by Delay Reason and Day of Week",
    x = "Day of Week",
    y = "Number of Delays"
  ) +
  theme_classic() +
  # https://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
  scale_fill_brewer(palette = "Set1") +
  facet_wrap(
    ~incident,
    scales = "free_x"
  )

# Which incident type causes the most severity of delays according to day of week?
incident_filter_ttcdelay_data |>
  ggplot(mapping = aes(x = day, y = min_delay)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Cumulative Delay Time by Delay Reason and Day of Week",
    x = "Day of Week",
    y = "Delay Time (in minutes)"
  ) +
  theme_classic() +
  # https://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
  scale_fill_brewer(palette = "Set1") +
  facet_wrap(
    ~incident,
    scales = "free_x"
  )

