if(exists('slugs') && {slugs %>% length() %>% is_greater_than(0)})
  Map(slug=slugs, name=names(slugs), function(slug, name)
    name %>% str_replace_all('_', ' ') %>% sprintf(fmt='[%s]: {{< ref "%s" >}}', slug)) %>%
    str_c(collapse='\n') %>%
    cat()
