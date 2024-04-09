#! setup knitr

require(project.notes.tools)

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
                  batch_chunk=list(cache=FALSE, echo=FALSE, message=FALSE, warning=FALSE),
                  analysis_code=list(cache=FALSE, eval=FALSE, fold_code=TRUE),
                  analysis_show=list(cache=FALSE, echo=FALSE, eval=TRUE, fold_code=NULL))

#! modify hooks
#! set cropping hook to crop all plots when `crop` is included in the chunk options
knit_hooks$set(crop=hook_pdfcrop)

#! hook to add html tags before/after code chunk for hiding/showing chunk
knit_hooks$set(fold_code=function(before, options, envir) {
	if(before) {
		options %>% pluck('engine') %>% sprintf(fmt='<details><summary>%s code</summary>') %>% return()
	} else {
		return('</details>\n')
	}
})

#! modify plot hook to include a hyperlink to the output figures for each dev format in the caption
local({
	original_plot_hook <- knit_hooks$get('plot')
	knit_hooks$set(plot=function(x, options) {
		# make markdown links to the rendered figure files
		figure_file_root <- sprintf(fmt='%s-%s', {file.path(options$fig.path, options$label) %>% str_replace_all('//', '/')}, options$fig.cur)
		options$dev %>%
			lapply(function(dev) sprintf(fmt='[%s](%s.%s)', dev, figure_file_root, dev)) %>%
			append(list(sep=' ', 'Download this figure:'), .) %>%
			do.call(what=str_c) -> download_links

		# modify the incoming options
		options$fig.cap %<>% str_c(download_links, sep=' ')

		# create the markdown
		original_plot_hook(x, options) %>% str_c('\n\n')})
})

#! setup custom engines
#! write a yaml chunk
yaml_engine <- function(options)
	formatted_text_engine(options=options, language='yaml')

#! write a json chunk
json_engine <- function(options)
	formatted_text_engine(options=options, language='json')

#! write a generic chunk
formatted_text_engine <- function(options, language='plain') {
	options |> pluck('code-fold', .default='false') -> code_fold
	options |> pluck('code-summary', .default='Code') -> code_summary
	chunk_def <- sprintf(fmt='```{.%s .cell-code code-fold="%s" code-summary="%s"}\n', language, code_fold, code_summary)
	options$code %>% sprintf(fmt='%s\n') %>% c(chunk_def, ., '```\n')
}

#! provide the above engines
knit_engines$set(yaml=yaml_engine, json=json_engine)
