# libraries to make bibliography
library(rcrossref)
# library(bibtex)
library(magrittr)

dir.create(path='files', recursive=TRUE, showWarnings=FALSE)

# write a bibliography of loaded packages
sessionInfo()$otherPkgs %>%
  sapply(purrr::pluck, 'Package') %>%
  base::subset(!grepl('helpr|projectData|datarepository|project.notes.tools', .)) %>%
  knitr::write_bib(file='files/bibliography.bib')

if(length(software_doi)>0)
  software_doi %>%
    rcrossref::cr_cn() %>%
    lapply(paste, collapse=' ') %>%
    unlist() %>%
    write(file='files/bibliography.bib', append=TRUE)
