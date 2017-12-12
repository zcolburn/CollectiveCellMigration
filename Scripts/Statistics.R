# Perform statistics

rm(list=ls())

# Load %>% from dplyr
library(dplyr)

# Load parameters
load(file.path("Memory","parameters.r"))

# Load cell sheet position data - an object labeled "output"
load(file.path("Memory","output.r"))

# Compute change in x position relative to time 0
td <- output %>%
  dplyr::group_by(Image_group) %>%
  dplyr::mutate(
    x_position = x_position - x_position[Time == 0]
  )
# Created td tibble (time data tibble)

# Convert pixels to microns
td <- td %>% dplyr::mutate(x_position = x_position * parameters$microns_per_pixel)






# Graph data --------------------------------------------------------------

max_time <- 720# Upper x-limit on graph in minutes
max_closed <- 100# Upper y-limit on graph in microns
legend_x <- 0.2# Legend x-position as proportion of x dimension
legend_y <- 0.9# Legend y-position as proportion of y dimension

library(ggplot2)
td %>%
  ggplot(
    .,
    aes(Time, x_position, colour = Condition_name)
  )+
  geom_point()+
  geom_line()+
  theme_bw()+
  ylab(bquote("Wound closure ("*mu*"m)"))+
  xlab("Time (min)")+
  labs(colour = "")+
  scale_y_continuous(expand=c(0,0))+
  scale_x_continuous(expand=c(0,0))+
  coord_cartesian(
    xlim=c(0,max_time),
    ylim=c(0,max_closed)
  )+
  theme(
    axis.text = element_text(
      colour = "black",
      size = 14
    ),
    axis.title = element_text(
      size = 14
    ),
    legend.position = c(legend_x,legend_y),
    legend.background = element_rect(fill=scales::alpha("blue",alpha=0))
  )
ggsave(
  filename = file.path("Results","Line graph.tiff"),
  unit = "in",
  width = 4,
  height = 3,
)





td %>%
  dplyr::filter(
    .,
    Time == max(Time)
  ) %>%
  ggplot(
    .,
    aes(x_position)
  )+
  geom_histogram(aes(y=..density..))+
  facet_wrap(~Condition_name)+
  theme_bw()+
  xlab(bquote("Wound closure ("*mu*"m)"))+
  ylab("Probability density")+
  labs(colour = "")+
  scale_y_continuous(expand=c(0,0))+
  scale_x_continuous(expand=c(0,0))+
  theme(axis.text = element_text(colour = "black"))
ggsave(
  filename = file.path("Results","Histogram panel.tiff"),
  unit = "in",
  width = 4,
  height = 3,
)





# Statistics on wound closure at time t -----------------------------------

anova_result <- anova(aov(
  x_position ~ Condition_name,
  data = td %>%
    dplyr::filter(
      .,
      Time == max(Time)
    )
))

capture.output(anova_result, file = file.path("Results","ANOVA.txt"))


kruskal_result <- kruskal.test(
  formula = x_position ~ Condition_name,
  data = td %>%
    dplyr::filter(
      .,
      Time == max(Time)
    )
)

capture.output(kruskal_result, file = file.path("Results","Kruskal_Wallis.txt"))
