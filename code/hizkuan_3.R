
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
pronouns <- filter(ehme, pos == "izr")
# write_csv(pronouns, "../data/besteizenbat.csv")

#--------------------------------------------------------------
# word length and frequency: plot and regression
#--------------------------------------------------------------

pronouns <- filter(ehme, pos == "izr")

# plot from previous session
ggplot(pronouns) +
  # geom_label(aes(x = lemmalength, y = ehme_log, label = lemma), alpha = .5) +
  geom_point(aes(x = lemmalength, y = ehme_log, colour = nwords), size = 1) +
  xlab("Luzera") +
  ylab("Maiztasuna (log)") +
  ggtitle("Long pronouns are less frequent") +
  coord_flip()

# quick stats preview: lm() for simple linear regression:
# the equation y ~ x means: response ~ predictor(s) means: does predictor x explain response y?
# are longer words less frequent? does word length explain word frequency?
freq_model <- lm(ehme_log ~ lemmalength, pronouns)
freq_model
summary(freq_model)

pronouns$fitted <- fitted(freq_model)
pronouns$residuals <- residuals(freq_model)
freq_model$assign
fitted(freq_model)
predict(freq_model, tibble(lemmalength = c(1, 3, 20),
                           lemma = c('i', 'zeu', 'askozluzeagoa')))

# let's visualise the model:
ggplot(pronouns) +
  geom_label(aes(x = lemmalength, y = ehme_log, label = lemma), alpha = 0.5) +
  xlab("Luzera") +
  ylab("Maiztasuna (log)") +
  ggtitle("Long pronouns are less frequent") +
  geom_smooth(aes(x = lemmalength, y = ehme_log), method = "lm")

ggplot(pronouns) +
  geom_label(aes(x = lemmalength, y = ehme_log, label = lemma), alpha = 0.5) +
  xlab("Luzera") +
  ylab("Maiztasuna (log)") +
  ggtitle("Long pronouns are less frequent") +
  geom_smooth(aes(x = lemmalength, y = ehme_log), method = "lm", se = F)

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
mean(c(3,4,5))
c(3,4,5) %>% mean()



# what is the distribution of a given feature within a given group of speakers?
# filter one feature (e.g. word-initial aspiration: h hasieran)
# group by location and/or age and/or gender
# check response count for each group
# add proportion within each group (use mutate() to add extra columns)
# arrange by proportion

filter(garazi, feature == "h hasieran")

emaitzafinalak <- garazi %>% 
  filter(feature == "h hasieran") %>% 
  group_by(Herria, Generoa, Adina) %>%
  count(Erantzuna) %>% 
  mutate(proportion = n/sum(n)*100,
         borobilduta = round(proportion, digits = 2))

write_csv(emaitzafinalak, "../emaitzak/alskdjflk.csv")

print("hello")
"hello" %>% print()



garazi_h <- garazi %>% 
  filter(feature == "h hasieran") %>% 
  group_by(Herria, Adina, Generoa) %>% 
  count(Erantzuna) %>% 
  mutate(p = n/sum(n)) %>% 
  ungroup() %>% 
  filter(Erantzuna == 'h') %>%
  arrange(p)

garazi_h %>% 
  mutate(gender = recode(Generoa, '1' = 'neskak', '2' =  'mutilak'),
         gender2 = recode(gender, 'mutilak' = 'male', 'neskak' = 'female')) %>% 
  ggplot() +
  geom_col(aes(x = Adina, y = p, fill = Adina), position = position_dodge()) + 
  facet_grid(gender ~ Herria) +
  labs(x = 'age', y = 'proportion of aspiration')

#--------------------------------------------------------------
# how to join tables
#--------------------------------------------------------------

# table no. 1
garazi <- read_csv('../data/garazi_alldata.csv')

# table no. 2
herriak <- read_csv('../data/garazi_herriak.csv')

# join, merge tables
garazi <- left_join(garazi, herriak) %>% 
  select(-Herria)

#--------------------------------------------------------------
# generics and RT (reaction times)
#--------------------------------------------------------------

# data kindly provided by: Marta Ponciano
generics <- read_tsv("../data/generics_adults_response.txt")

# data as exported from E-Prime.
# too many columns; select a handful.
# also: filter out training trials

select(generics, Subject)

generics %>%
  select(Subject, Trial, Determiner, accuracy = Bis.ACC, Bis.CRESP, Bis.RESP, Bis.RT)

test.trials <- generics %>%
  select(Subject, Trial, Determiner, Bis.ACC, Bis.CRESP, Bis.RESP, Bis.RT) %>% 
  mutate(Determiner = recode(Determiner, '?' = 'training'),
         logRT = log(Bis.RT)) %>% 
  filter(Determiner != 'training')

test.trials <- generics %>% 
  select(Subject, Determiner, accuracy = Bis.ACC, RT = Bis.RT)



# does experimental condition (Determiner) affect RT?
# analyse visually:

ggplot(test.trials) +
  geom_density(aes(x = logRT, fill = Determiner), alpha = 0.6) +
  theme_bw() +
  facet_grid(~ Bis.ACC)

test.trials %>% 
  ggplot() +
  geom_boxplot(aes(x = Determiner, y = Bis.RT))

#--------------------------------------------------------------
# side note: how to tweak plots. check out:
# https://ggplot2.tidyverse.org/reference/ggtheme.html
# and
# https://ggplot2.tidyverse.org/reference/theme.html
# and
# https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html
library(cowplot)
theme_set(theme_cowplot())
theme_set(theme_bw() + theme(strip.background = element_blank()))
#--------------------------------------------------------------

# does experimental condition (Determiner) affect RT?
# analyse statistically:
model_rt <- lm(logRT ~ Determiner, data = test.trials)
summary(model_rt)

lm(logRT ~ Bis.ACC * Determiner, test.trials) %>% summary()

test.trials %>% 
  group_by(Bis.ACC, Determiner) %>% 
  summarise(meanRT = mean(Bis.RT))


# lm = linear model
# glm = generalized linear model



# confidence intervals for binomial (proportion) data
library(epitools)
acc.ci <- test.trials %>% 
  group_by(Determiner) %>% 
  count(Bis.ACC) %>% 
  mutate(total = sum(n)) %>% 
  ungroup() %>%
  filter(Bis.ACC == 1) %>% 
  mutate(mean.acc = n/total,
         lower.ci = binom.exact(n, total, .95)$lower,
         upper.ci = binom.exact(n, total, .95)$upper)

# does experimental condition (Determiner) affect accuracy?
# analyse visually:
test.trials %>% 
  ggplot() +
  aes(x = Determiner, y = Bis.ACC) +
  geom_jitter(alpha = 0.1) +
  geom_errorbar(aes(ymin=lower.ci, ymax=upper.ci),
                size = 1, width=.1, colour = 'red', data = acc.ci)

acc.ci %>% 
  ggplot() +
  aes(x = Determiner) +
  geom_errorbar(aes(ymin=lower.ci, ymax=upper.ci),
                size = 1, width=.1, colour = 'red') +
  geom_point(aes(y = mean.acc), colour = 'red', size = 2) +
  geom_text(aes(y = mean.acc, label = round(mean.acc, 2)), position = position_nudge(x = -.2)) +
  geom_hline(yintercept = 1)

# does experimental condition (Determiner) affect accuracy?
# analyse statistically:
model_acc <- glm(Bis.ACC ~ Determiner * Adina, test.trials, family = "binomial")
summary(model_acc)

# 1. Mixed models (fixed + random)
# 2. Interactions

model_acc <- glm(Bis.ACC ~ Determiner, test.trials, family = "binomial")
summary(model_acc)

dardar <- garazi %>% filter(feature == 'Dardarkarixak')
garazi_glm <- glmer(as.factor(erantzuna2) ~ Adina + Herri_izena, dardar, family = "binomial")
summary(garazi_glm)

c(NA, 1, 2, 3)
filter(Adina == 3)

garazi <- garazi %>% 
  mutate(subject = paste(Herri_izena, Generoa, Adina, sep = "_"))
dardar <- garazi %>% filter(feature == 'Dardarkarixak')
garazi_glm <- glmer(as.factor(erantzuna2) ~ Adina + Herri_izena + (1|subject), dardar, family = "binomial")

library(lmerTest)

summary(garazi_glm)

(fixed)
lm
glm

(fixed + random)
lmer
glmer

#--------------------------------------------------------------
# explore participants' background variables
#--------------------------------------------------------------

# load participant data
participants <- read_xlsx("../data/generics_adults_participants.xlsx") 

# how to join dataframes (ensure there's at leas 1 column in common)

test.trials <- test.trials %>% 
  mutate(Participant_ID = paste(Subject, "_1", sep = "")) %>% 
  select(-Subject)

left_join(test.trials, participants)

trials <- test.trials %>% 
  # mutate(Participant_ID = paste(Subject, "_1", sep = "")) %>% 
  left_join(participants) %>% 
  rename(age = Edad.años)

# does participant age affect RT?
# visualise relation between age and RT
trials %>% 
  ggplot() +
  aes(x = age, y = RT) +
  geom_jitter(alpha = 0.2) +
  geom_smooth(method = "lm")

# is it robust?
lm(Bis.RT ~ age, trials) %>% summary()

#--------------------------------------------------------------
# next?
#--------------------------------------------------------------

# why the regressions we did today are wrong
# stats: more on regressions (+ random effects)

model_acc <- glm(Bis.ACC ~ Determiner * age, trials, family = "binomial")
summary(model_acc)
