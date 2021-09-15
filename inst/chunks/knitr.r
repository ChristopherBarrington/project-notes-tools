# setup knitr
library(knitr)

opts_knit$set(progress=TRUE, verbose=FALSE)

opts_chunk$set(cache=TRUE, cache.path='knitr_cache/',
               include=TRUE, eval=TRUE,
               warning=FALSE, message=FALSE, results='hold', comment='#', prompt=FALSE,
               fig.align='center',
               fig.width=20, fig.height=20, crop=TRUE,
               dev=c('png','pdf'), dev.args=list(png=list(type='cairo')), dpi=150)

opts_template$set(r=list(),
                  bash=list(eval=FALSE),
                  callout=list(cache=FALSE),
                  hidden=list(echo=FALSE),
                  print_code=list(eval=FALSE))

# modify plot hook to include a hyperlink to the output figures for each dev format
local({
  original_plot_hook <- knitr::knit_hooks$get('plot')
  knitr::knit_hooks$set(plot=function(x, options) {
    figure_file_root <- sprintf(fmt='%s-%s', {file.path(options$fig.path, options$label) %>% str_replace_all('//', '/')}, options$fig.cur)

    options$dev %>%
      lapply(function(dev) htmltools::a(href=sprintf(fmt='%s.%s', figure_file_root, dev), target='_blank', dev)) %>%
      append(list(class='figure_download_links', '- Download this figure:'), .) %>%
      do.call(what=htmltools::p) %>%
      as.character() -> download_links

    if(packageVersion('knitr')<'1.27') {
      # define system commands to crop figures
      croppers <- list(pdf=function(f) sprintf(fmt='pdfcrop %s.pdf %s.pdf', f, f),
                       png=function(f) sprintf(fmt='convert -trim %s.png %s.png', f, f))

      # crop figures
      options$dev %>%
        lapply(function(dev) croppers[[dev]](f=figure_file_root) %>% system(ignore.stdout=TRUE, ignore.stderr=TRUE))
    }

    original_plot_hook(x, options) %>% str_c(download_links, sep='\n')})})

# setup custom engines
knitr::knit_engines$set(method_section=function(options) {
  sprintf(fmt='<div class="method_section">%s</div>', options$colour, options$code)})
