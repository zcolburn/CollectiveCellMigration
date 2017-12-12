# Map file locations and relationships

rm(list=ls())

# Load %>% from dplyr
library(dplyr)

# Retrive file names
files <- list.files(file.path("Data","wound_outlines"), recursive = TRUE)
files <- file.path("Data","wound_outlines",files)

# Retain only files with valid suffixes
files <- files[grepl("_[[:digit:]]+m.txt$", files)]

# Iterate through file names and retrieve file metadata
files <- lapply(
  files,
  function(filename){
    split_filename <- gsub("\\\\", "/", filename) %>%# Handle backslashes if on Mac
      strsplit(., "/") %>%
      unlist()
    
    experiment <- split_filename[3]
    condition <- split_filename[4]
    well <- split_filename[5]
    position <- split_filename[6]
    
    set_name <- paste(experiment, condition, well, position, sep = "_")
    
    image_time <- sub("m.txt", "", split_filename[7]) %>%
      sub("^.+_", "", .) %>%
      as.numeric()
    
    
    tibble::data_frame(
      Filename = filename,
      Experiment_name = experiment,
      Condition_name = condition,
      Well_number = well,
      Position_number = position,
      Time = image_time,
      Image_group = set_name
    )
  }
) %>%
  dplyr::bind_rows()


save(files, file = file.path("Memory","files.r"))
