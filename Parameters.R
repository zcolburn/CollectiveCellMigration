# Save analysis parameters

parameters <- tibble::lst(
  interval = 10,# Interval in minutes
  microns_per_pixel = 1281.71/1392,# The number of microns per pixel
  x_pixel_maximum = 1392,# X-dimension in pixels
  y_pixel_maximum = 1040,# Y-dimension in pixels
  safety_boundary = 10# In pixels
)
save(parameters, file = file.path("Memory","parameters.r"))
