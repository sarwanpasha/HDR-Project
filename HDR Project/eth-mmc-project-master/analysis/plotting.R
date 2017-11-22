library(plyr)
library(dplyr)
library(ggplot2)
library(reshape2)
library(stringr)

results <- read.csv("results.csv")

TMO_name <- function(letter) {
  return(revalue(letter,
                 c("O"="Original", "D"="Drago", "K"="Kuang", "M"="Mertens",
                 "W"="WardHistAdj")))
}
Scene_name <- function(letter) {
  letter <- as.factor(letter)
  return(revalue(letter,
                 c("K"="Kalamaja2", "N"="Niguliste", "P"="Ptln1", "T"="Toompea4")))
}

common_theme <- theme_bw() +
  theme(panel.grid.minor=element_blank())

ratings <- results %>%
  select(-Timestamp) %>%
  melt() %>%
  mutate(Scene=Scene_name(str_sub(variable, 1, 1)),
         TMO=TMO_name(str_sub(variable, 2, 2))) %>%
  rename(Rating=value) %>%
  select(-variable)

# ---- Tables ----
ratings %>%
  summarise(mean=mean(Rating))

ratings %>%
  group_by(TMO) %>%
  summarise(MeanRating=mean(Rating)) %>%
  arrange(desc(MeanRating))

ratings %>%
  group_by(Scene) %>%
  summarise(MeanRating=mean(Rating)) %>%
  arrange(desc(MeanRating))

table4 <- ratings %>%
  group_by(Scene, TMO) %>%
  summarise(MeanRating=mean(Rating)) %>%
  arrange(desc(MeanRating))

# ---- Line charts ----

ggplot(table4) +
  geom_line(aes(x=Scene, y=MeanRating, colour=TMO, group=TMO)) +
  geom_point(aes(x=Scene, y=MeanRating, colour=TMO), size=3, shape=15) +
  ylab("Mean rating") +
  common_theme
ggsave("../doc/figures/line_meanrating_vs_scene.pdf", width=8, height=3)

# ---- Bar charts ----

ggplot(ratings) +
  geom_bar(aes(x=Rating))

ggplot(ratings) +
  geom_bar(aes(x=Rating, fill=TMO)) +
  facet_wrap(~ TMO, nrow=1) +
  common_theme
ggsave("../doc/figures/bar_histogram_tmo.pdf", width=8, height=2)

ggplot(ratings) +
  geom_bar(aes(x=Rating)) +
  facet_wrap(~ Scene)

ggplot(ratings) +
  geom_bar(aes(x=Rating, fill=TMO)) +
  facet_wrap(~ Scene + TMO, nrow=4, ncol=5) +
  common_theme +
  theme(legend.position="none")
ggsave("../doc/figures/bar_histogram_tmo_scene.pdf", width=8, height=8)

# ---- Summary charts ----
summarised <- ratings %>%
  group_by(Scene, TMO) %>%
  summarise(MeanRating=mean(Rating),
            `1SD`=sd(Rating))

ggplot(summarised) +
  geom_bar(aes(x=TMO, y=MeanRating, fill=TMO), stat="identity") +
  facet_wrap(~ Scene, ncol=2)

ggplot(ratings) +
  geom_boxplot(aes(x=TMO, y=Rating))
ggplot(ratings) +
  geom_violin(aes(x=TMO, y=Rating))