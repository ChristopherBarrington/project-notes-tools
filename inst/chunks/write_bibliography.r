
#! write software/packages references

sessionInfo()$otherPkgs %>%
 sapply(purrr::pluck, 'Package') %>%
 base::subset(!grepl('helpr|projectData|datarepository|project.notes.tools', .)) %>%
 knitr::write_bib(file='files/software.bib')

if(length(software_doi)>0)
  RefManageR::GetBibEntryWithDOI(doi=software_doi) %>%
    RefManageR::WriteBib(bib=., file='files/software.bib', append=TRUE)

file.rename(from='files/software.bib', to='files/software.bibtex')
sprintf(fmt='cd %s ; academic import --bibtex %s/files/software.bib --publication-dir publication/software --no-overwrite', website_path, knitting_path) %>% system(ignore.stdout=TRUE)

#! write academic references

if(length(academic_doi)>0) {
  RefManageR::GetBibEntryWithDOI(doi=academic_doi) %>%
    RefManageR::WriteBib(bib=., file='files/academic.bib', append=TRUE)

  file.rename(from='files/academic.bib', to='files/academic.bibtex')
  sprintf(fmt='cd %s ; academic import --bibtex %s/files/academic.bibtex --publication-dir publication/academic --no-overwrite', website_path, knitting_path) %>% system(ignore.stdout=TRUE)
}
