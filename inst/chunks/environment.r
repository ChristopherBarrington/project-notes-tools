# ---------------------------------------------------------------------------
# R environment configuration
# - these conveniences should not need to be read to understand later chunks
# ---------------------------------------------------------------------------

require(project.notes.tools)

## ---- configure multicore processing
system('hostname', intern=TRUE) %>%
	str_remove('\\d+') %>%
	switch(babs=8, cn=32, gpu=32, nhmem=128, 4) %>%
	Sys.getenv(x='SLURM_CPUS_PER_TASK') %>%
	as.numeric() %T>%
	assign(x='ncores', envir=globalenv()) %>%
	registerDoMC()

## ---- add a path to the root of this project
list(project='1-10',
     scientist='1-9',
     lab='1-8',
     projects='1-7',
     dropbox_project='7-10',
     dropbox_complete='1-6 --complement') |>
	lapply(sprintf, fmt='pwd -P | cut --delimiter / --fields %s') |>
	lapply(system, intern=TRUE) |>
	list_modify(slug=getwd() |> basename()) |>
	{\(x) list_modify(x, website=file.path(x$project, 'project-notes'))}() |>
	{\(x) list_modify(x, content=file.path(x$website, 'content'))}() -> project_paths

## ---- parse the .babs file, if it exists
project_paths |>
	pluck('project') |>
	file.path('.babs') %>% (\(x)
	switch(file.exists(x) |> as.character(),
	       `TRUE`={read_yaml(x) %>% pluck(1)},
	       `FALSE`={list()},
	       'error!')) -> project_babs

## ---- connect to the project's pins board
project_paths |>
	pluck('project') |>
	file.path('pinboard') %>% (\(x)
	switch(dir.exists(x) |> as.character(),
	       `TRUE`=board_folder(x),
	       `FALSE`=NULL)) -> pinboard

## ---- r options
options(scipen=32,
        stringsAsFactors=FALSE,
        width=ifelse(interactive(), helpr:::get_screen_width(), 256))
