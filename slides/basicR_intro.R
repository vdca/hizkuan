#' ---
#' title: 'R basics for data analysis'
#' subtitle: ''
#' author: 
#' date: "`r Sys.time()`"
#' output:
#'   ioslides_presentation:
#'     widescreen: true
#'     toc: true
#'     transition: 0.2
#' ---

#+ setup, include=F
# echo=FALSE, warning=FALSE, message=FALSE, error = FALSE
library(knitr)
opts_chunk$set(tidy=TRUE, width=10, fig.width=4, fig.height=4, comment="" , prompt=TRUE )
# hook1 <- function(x){ gsub("```\n*```r*\n*", "", x) }
# knit_hooks$set(document = hook1)
hook2 <- function(x){ gsub("```\n+```\n", "", x) }
knit_hooks$set(document = hook2)


#' ## What is R
#'
#' R is a language for programming and statistics
#' 
#' Open source
#'
#' * Free
#' * Anyone can see the source code
#' * Anyone can contribute
#' 
#' Additional functions become available through packages
#' (15,242 available packages as of Nov 2019)
#' 

#' ## How does it work?
#' 
#' * R is command-line based
#' * No selecting from pull-down menus
#' * __Scripts__: plain text files that contain a list of commands that can be executed by a program (__R__). 
#' * Scripts may be used to automate processes.
#' 

#' ## Why should you care?
#'
#' Access to tools: 
#' 
#' * For plotting
#' * For statistics
#' * For combining, filtering and reorganizing data
#' 
#' Automation: speed + less error-prone + generalization to other datasets
#' 
#' Reproducibility: look up what you did, easily change few parameters + rerun
#'
#'


#--------------------------------------------------------------------------------