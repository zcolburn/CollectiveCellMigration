# Get the average position of cells at the leading edge

rm(list=ls())

# Load %>% from dplyr
library(dplyr)

# Load file metadata - object named "files"
load(file.path("Memory","files.r"))

# Iterate through files
output <- parallel::parLapply(
  parallel::makeCluster(parallel::detectCores()),
  split(files, 1:nrow(files)),
  function(file_row){
    # Load %>% from dplyr
    library(dplyr)
    
    # Load parameters
    load(file.path("Memory","parameters.r"))
    
    # Read region outline
    dat <- readr::read_delim(
      file_row$Filename[1],
      delim = "\t",
      col_names = FALSE
    ) %>% # Rename columns
      dplyr::rename(x = "X1", y = "X2") %>% 
      dplyr::filter(
        x > parameters$safety_boundary &
          y > parameters$safety_boundary &
          y < parameters$y_pixel_maximum - parameters$safety_boundary
      )
    
    # # Check that the wound edge is selected correctly
    # plot(
    #   dat, 
    #   xlim = c(0,parameters$x_pixel_maximum), 
    #   ylim=c(0,parameters$y_pixel_maximum), 
    #   pch=19
    # )
    
    # Get the mean x postion and handle the no rows case
    if(nrow(dat) == 0){
      mean_x_position = NA
    } else{
      mean_x_position = dat %>%
        dplyr::group_by(y) %>%
        dplyr::summarise(x = mean(x)) %>%
        dplyr::ungroup() %>%
        {item <- .; mean(item$x)}
    }
    
    # Append the mean x position to file_row and return that
    dplyr::mutate(
      file_row,
      x_position = mean_x_position
    )
  }
) %>%
  dplyr::bind_rows()

save(output, file = file.path("Memory","output.r"))
