```{r write_slugs}
#| cache=FALSE,
#| echo=FALSE,
#| eval=opts_current$get('slugs') %>% is.null() %>% not(),
#| results='asis'

slugs <- opts_current$get('slugs')

Map(slug=slugs, name=names(slugs), function(slug, name)
    str_replace_all(name, '_', ' ') %>% sprintf(fmt='[%s]: {{< ref "%s" >}}', slug)) %>%
  str_c(collapse='\n') %>%
  cat()
```
