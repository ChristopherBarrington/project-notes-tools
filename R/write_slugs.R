write_slugs <- function(slugs)
	Map(slug=slugs, name=names(slugs),
	    function(slug, name) {str_replace_all(name, '_', ' ') %>% sprintf(fmt='[%s]: {{< ref "%s" >}}', slug)}) |>
		str_c(collapse='\n') |>
		cat()
