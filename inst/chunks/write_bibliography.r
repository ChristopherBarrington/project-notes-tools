
#! write software/packages references

sessionInfo()$otherPkgs %>%
 sapply(purrr::pluck, 'Package') %>%
 base::subset(!grepl('helpr|projectData|datarepository|project.notes.tools', .)) %>%
 knitr::write_bib(file='files/software.bib')

if(length(software_doi)>0)
  RefManageR::GetBibEntryWithDOI(doi=software_doi) %>%
    RefManageR::WriteBib(bib=., file='files/software.bibtex', append=TRUE)

sprintf(fmt='cd %s ; academic import --bibtex %s/files/software.bibtex --publication-dir publication/software --no-overwrite', website_path, knitting_path) %>% system(ignore.stdout=TRUE)

#! write academic references

if(length(academic_doi)>0) {
  RefManageR::GetBibEntryWithDOI(doi=academic_doi) %>%
    RefManageR::WriteBib(bib=., file='files/academic.bibtex', append=FALSE)

  sprintf(fmt='cd %s ; academic import --bibtex %s/files/academic.bibtex --publication-dir publication/academic --no-overwrite', website_path, knitting_path) %>% system(ignore.stdout=TRUE)
}
