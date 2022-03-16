#! setup knitr
library(htmltools)
library(knitr)

#! knitr options
opts_knit$set(progress=TRUE, verbose=FALSE)

#! global chunk options
#! crop=TRUE : remove for no cropping, crop=FALSE is still interpreted as 'do cropping'
opts_chunk$set(cache=TRUE, cache.path='knitr_cache/',
               include=TRUE, eval=TRUE,
               warning=FALSE, message=FALSE, results='hold', comment='#', prompt=FALSE,
               fig.align='center', fig.show='asis',
               fig.width=20, fig.height=20, crop=TRUE,
               dev=c('png','pdf'), dev.args=list(png=list(type='cairo')), dpi=150)

#! define chunk templates
#! specify with opts.label='r' in the chunk for example
opts_template$set(r=list(),
                  bash=list(eval=FALSE),
                  callout=list(cache=FALSE),
                  hidden=list(echo=FALSE),
                  print_code=list(cache=FALSE, eval=FALSE),
                  batch_chunk=list(cache=FALSE, echo=FALSE, message=FALSE, warning=FALSE))
#! modify hooks
#! set cropping hook to crop all plots when `crop` is included in the chunk options
knit_hooks$set(crop=hook_pdfcrop)

#! modify plot hook to include a hyperlink to the output figures for each dev format
local({
  original_plot_hook <- knit_hooks$get('plot')
  knit_hooks$set(plot=function(x, options) {
    figure_file_root <- sprintf(fmt='%s-%s', {file.path(options$fig.path, options$label) %>% str_replace_all('//', '/')}, options$fig.cur)

    options$dev %>%
      lapply(function(dev) a(href=sprintf(fmt='%s.%s', figure_file_root, dev), target='_blank', dev)) %>%
      append(list(class='figure_download_links', '- Download this figure:'), .) %>%
      do.call(what=p) %>%
      as.character() -> download_links

    original_plot_hook(x, options) %>% str_c(download_links, sep='\n')})})

#! setup custom engines
# knit_engines$set(method_section=function(options) {
#   sprintf(fmt='<div class="method_section">%s</div>', options$colour, options$code)})

#! write a yaml chunk
knit_engines$set(yaml=function(options) options$code %>% sprintf(fmt='%s\n') %>% c('```yaml\n', ., '```\n'),
                 json=function(options) options$code %>% sprintf(fmt='%s\n') %>% c('```json\n', ., '```\n'))
