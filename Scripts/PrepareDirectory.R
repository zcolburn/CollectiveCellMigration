# Prepare the analysis directory
# 
# Create Memory and Results folders

rm(list=ls())

directories <- c("Memory","Results")

for(directory_name in directories){
  if(dir.exists(directory_name)){
    unlink(directory_name, recursive = TRUE)
  }
  dir.create(directory_name)
}
