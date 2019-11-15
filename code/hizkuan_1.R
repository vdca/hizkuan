
#--------------------------------------------------------------
# global
#--------------------------------------------------------------

# install.packages("tidyverse")
library("tidyverse")

#--------------------------------------------------------------
# this is a section
#--------------------------------------------------------------

# R, Rstudio, R packages, tidyverse
# goals: (1) tidy, (2) statistical analysis, (3) plots and visual exploration

# scripts: analysis1.R

# help:
#   - search-search-search the web
#   - read the R documentation: ?function
#   - books, courses, tutorials: e.g. https://r4ds.had.co.nz/; Baayen 2008
#   - talk to people, groups: e.g. R-Ladies (https://rladies.org/)

#--------------------------------------------------------------
# types of data, functions
#--------------------------------------------------------------

# this is a comment!

"this is not a comment"

# how do you RUN stuff from the script?
# send a command (= line) from the script, down to the console
# by pressing: ctrl + enter

3
3.14
"great"
notgreat

nchar("great")

# R is a powerful calculator
1+1
2*35/10

# in R, you do stuff using functions.
# a function is just a small program you can use by writing its name.
# e.g. the function class() tells you what kind of data we are dealing with.
# functions usually take n arguments between parentheses: e.g. class(x)

class(3)
class("great")
print("hello")
sqrt(16)
?sqrt

# we can store stuff (e.g. data) in named variables.
# we can use whatever we have stored by naming the variable in the future.
# we assign stuff to variables using a sort-of arrow:

a <- "hitz bat"
nchar(a)
nchar("hitz bat")

zerrendabat <- c("hitzbat", "luzeagobat", "bost", "lasdjflkdsajflkajsdlkfjdsalkfalsdjflkasjflkjdsaflkjsadflkjdsalkf")
zerrendabat
nchar(zerrendabat)

named_variable <- "stuff stored in variable"
named_variable

thisyear <- 2019
thisyear
thisyear - 18

#--------------------------------------------------------------
# data structures
#--------------------------------------------------------------

# single data points
3
"hitz"

# one-dimensional data (= vector)
c(3, 4, 9, 12)

# two-dimensional data (= data frame, matrix)
experiment <- data.frame(subject = c(1, 1, 2, 2),
                         sentence = c("a", "b", "a", "b"),
                         reaction_time = c(450, 324, 560, 450))
experiment

# you can extract a column as a vector using the dollar sign ($)
experiment$reaction_time

mean(experiment$reaction_time)

# in R we use vectors everywhere
a <- 1:100
sqrt(a)

# Q: what will the output of a+1 be?
a+1

# Q: what is the mean of a?

#--------------------------------------------------------------
# read and write data
#--------------------------------------------------------------

# important: always check your working directory (=wd),
# all paths to a file are relative to the working directory

# you can check the current working directory:

# and set it by using the setwd() function, or clicking:
# Session > Set Working Directory > To Source File Location

d <- read_csv("../data/ehme.csv")

neredatumarabilosoak <- read_csv("../data/ehme.csv")

#--------------------------------------------------------------
# quickly explore data
#--------------------------------------------------------------

# number of rows and columns
nrow(d)
ncol(d)

# structure of the data
class(d)
str(d)

# preview data
d

#--------------------------------------------------------------
# filter, analyse, summarise data
#--------------------------------------------------------------

# the tidyverse provides useful and intuitive verbs (= functions):

# Q: what is the shortest word?
arrange(d, lemmalength)

# Q: and the longest word?


# Q: and the most frequent two-character word?


# Q: what is the most frequent POS?
count(d, pos)

# filter data using the filter() function
filter(d, pos == "ize")

# Q: what is the mean frequency for nouns?


# are longer words less frequent?
freq_model <- lm(ehme_log ~ lemmalength, d)
summary(freq_model)

#--------------------------------------------------------------
# plot data
#--------------------------------------------------------------

# visual help: https://www.r-graph-gallery.com/

ggplot(d) +
  aes(x = pos) +
  geom_bar()

# are longer pronouns less frequent?
d %>% 
  filter(pos == "izr") %>% 
  ggplot() +
  aes(x = lemmalength, y = ehme_log) +
  geom_jitter(alpha = 0.5)

#--------------------------------------------------------------
# next?
#--------------------------------------------------------------

# what kind of data? reaction times? grammaticality judgements?
# create new columns with transformed data; e.g. normalised RT
# more on regression models
# more plots
