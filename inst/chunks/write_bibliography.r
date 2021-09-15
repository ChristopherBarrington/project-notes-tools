#! libraries to make bibliography

library(RefManageR)
library(magrittr)

#! write software/packages references

sessionInfo()$otherPkgs %>%
 sapply(purrr::pluck, 'Package') %>%
 base::subset(!grepl('helpr|projectData|datarepository|project.notes.tools', .)) %>%
 knitr::write_bib(file='files/software.bib')

RefManageR::GetBibEntryWithDOI(doi=software_doi) %>%
  when(!is.null(.)~RefManageR::WriteBib(bib=., file='files/software.bib', append=TRUE)) %>%
  invisible()

sprintf(fmt='cd %s ; academic import --bibtex %s/files/software.bib --publication-dir publication/software --no-overwrite', website_path, knitting_path) %>% system(ignore.stdout=TRUE)

#! write academic references

RefManageR::GetBibEntryWithDOI(doi=academic_doi) %>%
  when(!is.null(.)~RefManageR::WriteBib(bib=., file='files/academic.bib', append=FALSE)) %>%
  invisible()

sprintf(fmt='cd %s ; academic import --bibtex %s/files/academic.bib --publication-dir publication/academic --no-overwrite', website_path, knitting_path) %>% system(ignore.stdout=TRUE)
