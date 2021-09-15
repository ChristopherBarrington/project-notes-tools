#! R configuration; these should not need to be read to understand the later chunks

#! load general libraries
library(RColorBrewer)
library(grid)
library(gridExtra)
library(gtools)
library(scales)
library(kableExtra)
library(patchwork)
library(openxlsx)
library(rslurm)

library(helpr)
library(datarepository)

library(plyr)
library(magrittr)
library(tidyverse)

#! configure multicore processing
system('hostname', intern=TRUE) %>%
  str_remove('\\d+') %>%
  switch(babs=16, ca=32, gpu=32, hmem=96, 4) %T>%
  assign(x='ncores', envir=globalenv()) %>%
  doMC::registerDoMC()

#! define paths for the project
knitting_path <- getwd()
website_path <- knitting_path %>% str_remove('/content/.*')
project_path <- knitting_path %>% str_split('/') %>% unlist() %>% head(n=10) %>% str_c(collapse='/')
slug <- knitting_path %>% basename()

#! parse the .babs file, if it exists
file.path(project_path, '.babs') %>%
  when(file.exists(.)~yaml::read_yaml(.)[[1]], TRUE~list()) -> project_babs

#! r options
options(scipen=32,
        width=ifelse(interactive(), helpr:::get_screen_width(), 256),
        stringsAsFactors=FALSE)
