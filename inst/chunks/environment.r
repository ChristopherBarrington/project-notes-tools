#! R configuration; these should not need to be read to understand the later chunks

#! load general libraries
library(digest)
library(doMC)
library(fs)
library(grid)
library(gridExtra)
library(gtools)
library(kableExtra)
library(openxlsx)
library(patchwork)
library(RColorBrewer)
library(rslurm)
library(RefManageR)
library(scales)
library(yaml)

library(datarepository)
library(helpr)

library(plyr)
library(magrittr)
library(tidyverse)

#! configure multicore processing
system('hostname', intern=TRUE) %>%
  str_remove('\\d+') %>%
  switch(babs=16, ca=32, gpu=32, hmem=96, 4) %>%
  Sys.getenv(x='SLURM_CPUS_PER_TASK') %>%
  as.numeric() %T>%
  assign(x='ncores', envir=globalenv()) %>%
  registerDoMC()

#! add a path to the root of this project
project_path <- system(command='pwd -P | cut -f 1-10 -d/', intern=TRUE)

#! parse the .babs file, if it exists
file.path(project_path, '.babs') %>%
  when(file.exists(.)~read_yaml(.) %>% pluck(1),
       TRUE~list()) -> project_babs

#! r options
options(scipen=32,
        stringsAsFactors=FALSE,
        width=ifelse(interactive(), helpr:::get_screen_width(), 256))
