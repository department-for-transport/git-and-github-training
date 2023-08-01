
##Format dates nicely
date_formatter <- function(dates, abbr_day = TRUE, abbr_month = TRUE, include_year = FALSE){
  dayy <- lubridate::day(dates)
  suff <- dplyr::case_when(dayy %in% c(11,12,13) ~ "th",
                           dayy %% 10 == 1 ~ 'st',
                           dayy %% 10 == 2 ~ 'nd',
                           dayy %% 10 == 3 ~'rd',
                          TRUE ~ "th")
  
  if(include_year == FALSE){
    paste0(lubridate::wday(dates, label = TRUE, abbr = abbr_day), " ", dayy, suff, " ", lubridate::month(dates, label = TRUE, abbr = abbr_month))
  }

}

##Function to find a value that is neither the max nor the min
mid <- function(data){
  #Keep only unique values
  data <- unique(data)
  
  #Find min and max
  mx <- max(data)
  mn <- min(data)
  
  data[!data %in% c(mn, mx)]
}

##Function to interrogate QHR data to find difference between two dates by hour
hourly_diff <- function(data, hour_1, hour_2){
  #Get individual maximum and comparator dates
  mx <- max(data$date)
  md <- min(data$date)
  
  ##Filter data to just those dates and the hours given
  compare <- data[date %in% c(md, mx) & hour >= hour_1 & hour < hour_2, 
  ##Summarise by date to add all volumes together                
                  .(count = sum(count, na.rm = TRUE)),
                    by = list(date)]
  
  ##Find change from last week to this week
  change <- round(
    (
      (compare[date == mx, count]/compare[date == md, count]) - 1) 
    * 100)
  
  #~Format as percentage with positive or negative sign
  if(hour_1 == 00 & hour_2 == 24){
    paste0("(", sprintf("%+2g%%", change),")")
  }
  else if(hour_2 == 24){
    paste0("from ", hour_format(hour_1), " onwards "," (", sprintf("%+2g%%", change),")")
  }else{
  paste0("between ", hour_format(hour_1), " - ", hour_format(hour_2), " (", sprintf("%+2g%%", change),")")
  }
}

##Format the hours into times
hour_format <- function(x){
  
  #Split out hour and minute
  hour <- gsub("[.].*", "", x)
  mins <- gsub("[[:digit:]]*[.]", "", format(x, nsmall = 2))
  #Turn minutes into actual minutes
  mins <- if(mins == "00") mins else(as.numeric(mins) * 0.6)
  
  #Return pasted time
  paste(hour, mins, sep = ":")
}


#Find most recent percentage value
comparison_percent <- function(transport_mode, days_diff = 7){
  
  data <- all_data %>%
    dplyr::filter(transport_type == transport_mode) %>%
    dplyr::filter(date == (max(date, na.rm = TRUE) - days_diff))
  
  scales::percent(data$dash_value)
  
}

##Function to pull most recent data and day
extract_current_data <- function(transport_mode){
  
  data <- all_data %>%
    dplyr::filter(transport_type == transport_mode) %>%
    dplyr::filter(date == max(date, na.rm = TRUE))
  
  ##Format day
  if(transport_mode == "national_rail"){
    day <- paste("w/e", date_formatter(data$date))
  } else{
    day <- date_formatter(data$date)
  }
  
  paste0(scales::percent(data$dash_value), "<br> (", day, ")")
  
}

##Function to pull year ago comparison to most current data and day
extract_last_year_data <- function(transport_mode, date_minus = 364){
  
  data <- all_data %>%
    dplyr::filter(transport_type == transport_mode) %>%
    dplyr::filter(date == max(date, na.rm = TRUE) - date_minus)
  
  ##Format day
  if(transport_mode == "national_rail"){
    day <- paste("w/e", date_formatter(data$date, include_year = TRUE))
  } else{
    day <- date_formatter(data$date, include_year = TRUE)
  }
  
  paste0(scales::percent(data$dash_value), "<br> (", day, ")")
  
}

##Function to pull lowest weekday value and date
extract_min_data <- function(transport_mode){
  
  data <- all_data %>%
    dplyr::mutate(weekday = lubridate::wday(date)) %>%
    dplyr::filter(transport_type == transport_mode &
                    weekday %in% c(2, 3, 4, 5, 6) & 
                    ##Remove bank holidays
                    !date %in% as.Date(c("2020-01-01", "2020-04-10", "2020-04-13", 
                                         "2020-05-04", "2020-05-08", "2020-05-25",
                                         "2020-08-31", "2020-12-25", "2020-12-28", 
                                         "2021-01-01", "2021-04-02", "2021-04-05",
                                         "2021-05-03", "2021-05-31", "2021-08-30",
                                         "2021-12-27", "2021-12-28"))) %>%
    dplyr::filter(dash_value == min(dash_value, na.rm = TRUE))
  
  scales::percent(unique(data$dash_value))
  
}

##Function to pull most recent date from data
current_date <- function(transport_mode){
  
  ##Filter data to max date and 1 week ago
  data <- all_data %>%
    dplyr::filter(transport_type == transport_mode) 
  
  date_formatter(max(data$date, na.rm = TRUE), abbr_day = FALSE, abbr_month = FALSE)
}

##Function to pull most recent date from data
comparison_date <- function(transport_mode, days_diff = 7){
  
  ##Filter data to max date and 1 week ago
  data <- all_data %>%
    dplyr::filter(transport_type == transport_mode) 
  
  date_formatter((max(data$date, na.rm = TRUE) - days_diff), abbr_day = FALSE, abbr_month = FALSE)
}

##Function to pull out current cycling data
current_cycling <- function(){
  
  ##Filter data to max date and 1 week ago
  data <- all_data %>%
    dplyr::filter(transport_type == "cycling") %>%
    dplyr::filter(date > (max(date, na.rm = TRUE) - 5))
  
  paste0(scales::percent(min(data$dash_value, na.rm = TRUE)), "-", scales::percent(max(data$dash_value, na.rm = TRUE)))
}

##Function to pull out current cycling dates
date_cycling <- function(format = "full_month"){
  
  ##Filter data to max date and 1 week ago
  data <- all_data %>%
    dplyr::filter(transport_type == "cycling") %>%
    dplyr::filter(date > (max(date, na.rm = TRUE) - 5))
  
  
  if(format == "full_month"){
    
    paste0(date_formatter(min(data$date, na.rm = TRUE), abbr_day = FALSE, abbr_month = FALSE), " and ", date_formatter(max(data$date, na.rm = TRUE), abbr_day = FALSE, abbr_month = FALSE))
  } else{
    paste0(date_formatter(min(data$date, na.rm = TRUE)), " - ", date_formatter(max(data$date, na.rm = TRUE)))
    
  }
}

##Function to pull out previous cycling data
previous_cycling <- function(){
  
  ##Filter data to max date and 1 week ago
  data <- all_data %>%
    dplyr::filter(transport_type == "cycling") %>%
    dplyr::filter(date > (max(date, na.rm = TRUE) - 12) & date < (max(date, na.rm = TRUE) - 6))
  
  paste0(scales::percent(min(data$dash_value, na.rm = TRUE)), "-", scales::percent(max(data$dash_value, na.rm = TRUE)))
}

##Function to pull out current cycling dates
previous_date_cycling <- function(){
  
  ##Filter data to max date and 1 week ago
  data <- all_data %>%
    dplyr::filter(transport_type == "cycling") %>%
    dplyr::filter(date > (max(date, na.rm = TRUE) - 12) & date < (max(date, na.rm = TRUE) - 6))
  
  paste0(date_formatter(min(data$date, na.rm = TRUE), abbr_day = FALSE, abbr_month = FALSE), " and ", date_formatter(max(data$date, na.rm = TRUE), abbr_day = FALSE, abbr_month = FALSE, include_year = TRUE))
  
}

##Function to extract commentary for a specific mode from the table
extract_commentary <- function(data, mode){
  data %>% 
    dplyr::filter(Mode == mode) %>% 
    dplyr::pull(Commentary)
}
