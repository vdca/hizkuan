
#--------------------------------------------------------------
# global
#--------------------------------------------------------------

library("tidyverse")

#--------------------------------------------------------------
# today
#--------------------------------------------------------------

# 1. vectorised operations
# 2. useful verbs: arrange, filter, count
# 3. some plots
# 4. how to read xlsx (=excel) files
# 5. other useful verbs: group_by, mutate

#--------------------------------------------------------------
# data structures
#--------------------------------------------------------------

# in R we use vectors everywhere
a <- 1:100

# do you know other ways of creating a vector with all the integers from 1 to 100?

# a convenient feature of R is that you can vectorise operations
sqrt(a)

# Q: what will the output of a+1 be?
a+1

# Q: what is the mean of a?
mean(a)

#--------------------------------------------------------------
# read and write data
#--------------------------------------------------------------

# set your working directory by using the setwd() function, or e.g. by clicking:
# Session > Set Working Directory > To Source File Location

# when writing the path to a file, two dots (..) take you to a parent folder.
d <- read_csv("../data/ehme.csv")

# if you haven't installed or loaded the package tidyverse, you can read the file using:
d <- read.csv("../data/ehme.csv")

#--------------------------------------------------------------
# explore data
#--------------------------------------------------------------

# shape of dataframe
nrow(d)
ncol(d)
d

# the tidyverse provides useful and intuitive verbs (= functions):
# arrange, filter, count

# Q: what is the shortest word?
arrange(d, lemmalength)

# Q: and the longest word?
arrange(d, desc(lemmalength))
arrange(d, desc(ehme_freq))

# head, tail
tail(arrange(d, lemmalength), 10)
tail(d)

bukaera <- tail(d)
bukaera

# Q: and the most frequent two-character word?
arrange(d, desc(lemmalength = 2))

arrange(d, lemmalength, desc(ehme_freq))
arrange(d, lemmalength, -ehme_freq)

arrange(arrange(d, lemmalength), desc(ehme_freq))

# Q: what is the most frequent POS?
arrange(count(d, pos), -n)

count(d, pos, sort = TRUE)

# filter data using the filter() function
# logical operators: >, <, ==, !=, etc.
g <- filter(d, pos == "ize")

# Q: save all the pronouns into a separate dataframe
pronouns <- filter(d, pos == "izr")
pronouns

#--------------------------------------------------------------
# plot data
#--------------------------------------------------------------

# visual help: https://www.r-graph-gallery.com/

# are longer pronouns less frequent?
# 3 steps to create a plot: 1=data, 2=geometry, 3=aesthetics
ggplot(pronouns) +
  geom_point(aes(x = lemmalength, y = ehme_log))

# jitter to avoid overlap
ggplot(pronouns) +
  geom_jitter(aes(x = lemmalength, y = ehme_log))

# alpha to visualise overlap
ggplot(pronouns) +
  geom_jitter(aes(x = lemmalength, y = ehme_log), alpha = 0.8)

# Q: how do we visualise the actual words (instead of dots)?

ggplot(pronouns) +
  geom_label(aes(x = lemmalength, y = ehme_log, label = lemma), alpha = 0.5)

# Q: modify axis labels, add title
ggplot(pronouns) +
  geom_label(aes(x = lemmalength, y = ehme_log, label = lemma), alpha = 0.5) +
  xlab("Luzera") +
  ylab("Maiztasuna (log)") +
  ggtitle("Long pronouns are less frequent")

# quick stats preview: lm() for simple linear regression:
# the equation y ~ x means: response ~ predictor(s) means: does predictor x explain response y?
# are longer words less frequent? does word length explain word frequency?
freq_model <- lm(ehme_log ~ lemmalength, d)
summary(freq_model)

#--------------------------------------------------------------
# how to read xlsx (excel) data
#--------------------------------------------------------------

# data kindly provided by: Alex Artzelus

# search the internet: e.g. r how to read xlsx
# several options; for instance:
library(readxl)
garazi <- read_xlsx('../hidden/Emaitza_taula_barrixa.xlsx', sheet = 3)

# tip: store each dataframe in a separate file
# better csv than xlsx (better = lighter, faster, more compatible)
garazi <- read_csv('../data/garazi_alldata.csv')

#--------------------------------------------------------------
# pipes, group_by, mutate
#--------------------------------------------------------------

# overview of the data
count(garazi, Herria)

# %>% ceci n'est pas une pipe:
# welcome the pipe (%>%), write readable code on the fly.
# a pipe (%>%) passes the object on left hand side as first argument of function on righthand side.
# x %>% f(y) is the same as f(x, y)

# what is the distribution of a given feature within a given group of speakers?
# filter one feature (e.g. rhotics)
# group by location and/or age and/or gender
# check response count for each group
# add proportion within each group
# arrange by proportion








garazi %>% 
  filter(feature == "Dardarkarixak") %>% 
  group_by(Herria) %>% 
  count(Erantzuna) %>% 
  mutate(proportion = n/sum(n)) %>% 
  ungroup() %>% 
  filter(Erantzuna == 'r') %>% 
  arrange(proportion)

# plot with facets
garazi %>% 
  count(feature, Adina, Erantzuna) %>% 
  ggplot() +
  geom_col(aes(x = Erantzuna, y = n, fill = Adina), position = position_dodge2()) +
  facet_wrap(~ feature, scales = "free")

#--------------------------------------------------------------
# next
#--------------------------------------------------------------

# tidy data: join different dataframes
# stats: run and understand regressions
# plots: facets, colours


