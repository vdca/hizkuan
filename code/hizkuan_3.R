
#--------------------------------------------------------------
# global
#--------------------------------------------------------------

# remove previous objects from workspace
rm(list=ls())

# load libraries
library("tidyverse")
library("readxl")

#--------------------------------------------------------------
# today
#--------------------------------------------------------------

# data:
# 1. word frequencies (EHME corpus)
# 2. sociolinguistic data (Alexi esker)
# 3. semantics, reaction times (Martari esker)

# topics:
# 1. stats: run and understand regressions
# 2. tidy data: group_by, mutate
# 3. how to join dataframes
# 4. plots: facets, colours

#--------------------------------------------------------------
# read and write data
#--------------------------------------------------------------

# set your working directory by using the setwd() function, or e.g. by clicking:
# Session > Set Working Directory > To Source File Location

# when writing the path to a file, two dots (..) take you to a parent folder (= previous folder, one level up).
ehme <- read_csv("../data/ehme.csv")

# if you haven't installed or loaded the package tidyverse, you can read the file using:
# d <- read.csv("../data/ehme.csv")

# Q: how do we save a dataframe from R into the computer?
# --> save all the pronouns into a separate file. extra: ordered by frequency.





#--------------------------------------------------------------
# word length and frequency: plot and regression
#--------------------------------------------------------------

pronouns <- filter(ehme, pos == "izr")

# plot from previous session
ggplot(pronouns) +
  geom_label(aes(x = lemmalength, y = ehme_log, label = lemma), alpha = 0.5) +
  xlab("Luzera") +
  ylab("Maiztasuna (log)") +
  ggtitle("Long pronouns are less frequent")

# quick stats preview: lm() for simple linear regression:
# the equation y ~ x means: response ~ predictor(s) means: does predictor x explain response y?
# are longer words less frequent? does word length explain word frequency?
freq_model <- lm(ehme_log ~ lemmalength, pronouns)
summary(freq_model)

# let's visualise the model:
ggplot(pronouns) +
  geom_label(aes(x = lemmalength, y = ehme_log, label = lemma), alpha = 0.5) +
  xlab("Luzera") +
  ylab("Maiztasuna (log)") +
  ggtitle("Long pronouns are less frequent") +
  geom_smooth(aes(x = lemmalength, y = ehme_log), method = "lm")

#--------------------------------------------------------------
# sociophonetics in Garazi
#--------------------------------------------------------------

# data kindly provided by: Alex Artzelus
garazi <- read_csv('../data/garazi_alldata.csv')

#--------------------------------------------------------------
# pipes, group_by, mutate
#--------------------------------------------------------------

# overview of the data
count(garazi, feature, sort = T)
count(garazi, Herria)

# %>% ceci n'est pas une pipe:
# welcome the pipe (%>%), write readable code on the fly.
# a pipe (%>%) passes the object on left hand side as first argument of function on righthand side.
# x %>% f(y) is the same as f(x, y)
# shortcut = ctrl + shift + m



# what is the distribution of a given feature within a given group of speakers?
# filter one feature (e.g. word-initial aspiration: h hasieran)
# group by location and/or age and/or gender
# check response count for each group
# add proportion within each group (use mutate() to add extra columns)
# arrange by proportion





garazi_h <- garazi %>% 
  filter(feature == "h hasieran") %>% 
  group_by(Herria, Adina, Generoa) %>% 
  count(Erantzuna) %>% 
  mutate(p = n/sum(n)) %>% 
  ungroup() %>% 
  filter(Erantzuna == 'h') %>%
  arrange(p)

garazi_h %>% 
  ggplot() +
  geom_col(aes(x = Adina, y = p, fill = Adina), position = position_dodge()) +
  facet_grid(Generoa ~ Herria)

#--------------------------------------------------------------
# generics and RT (reaction times)
#--------------------------------------------------------------

# data kindly provided by: Marta Ponciano
generics <- read_tsv("../data/generics_adults_response.txt")

# data as exported from E-Prime.
# too many columns; select a handful.
# also: filter out training trials
generics %>%
  select(Subject, Trial, Determiner, Bis.ACC, Bis.CRESP, Bis.RESP, Bis.RT) %>% 
  filter()

# does experimental condition (Determiner) affect RT?
# analyse visually:
test.trials %>% 
  ggplot() +
  geom_density(aes(x = Bis.RT, fill = Determiner), alpha = 0.5)

test.trials %>% 
  ggplot() +
  geom_boxplot(aes(x = Determiner, y = Bis.RT))

# does experimental condition (Determiner) affect RT?
# analyse statistically:
model_rt <- lm(Bis.RT ~ Determiner, data = test.trials)
summary(model_rt)

# does experimental condition (Determiner) affect accuracy?
# analyse visually:
test.trials %>% 
  ggplot() +
  aes(x = Determiner, y = Bis.ACC) +
  geom_jitter(alpha = 0.3) +
  stat_summary(fun.data = "mean_se", colour = "red", size = 1)

# does experimental condition (Determiner) affect accuracy?
# analyse statistically:
model_acc <- glm(Bis.ACC ~ Determiner, test.trials, family = "binomial")
summary(model_acc)

#--------------------------------------------------------------
# explore participants' background variables
#--------------------------------------------------------------

# load participant data
participants <- read_xlsx("../data/generics_adults_participants.xlsx") 

# how to join dataframes (ensure there's at leas 1 column in common)
trials <- test.trials %>% 
  mutate(Participant_ID = paste(Subject, "_1", sep = "")) %>% 
  left_join(participants) %>% 
  rename(age = Edad.años)

# does participant age affect RT?
# visualise relation between age and RT
trials %>% 
  ggplot() +
  aes(x = age, y = Bis.RT) +
  geom_jitter(alpha = 0.2) +
  geom_smooth(method = "lm")

lm(Bis.RT ~ age, trials) %>% summary()

#--------------------------------------------------------------
# next?
#--------------------------------------------------------------

# why the regressions we did today are wrong
# stats: more on regressions (+ random effects)


