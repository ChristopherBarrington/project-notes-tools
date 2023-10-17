#! R configuration; these should not need to be read to understand the later chunks

require(project.notes.tools)

#! configure multicore processing
system('hostname', intern=TRUE) %>%
	str_remove('\\d+') %>%
	switch(babs=8, ca=32, gpu=32, hmem=96, 4) %>%
	Sys.getenv(x='SLURM_CPUS_PER_TASK') %>%
	as.numeric() %T>%
	assign(x='ncores', envir=globalenv()) %>%
	registerDoMC()

#! add a path to the root of this project
project_path <- system(command='pwd -P | cut --fields 1-10 --delimiter /', intern=TRUE)
list(slug=getwd() |> basename(),
     project=system('pwd -P | cut --fields 1-10 --delimiter /', intern=TRUE),
     scientist=system('pwd -P | cut --fields 1-9 --delimiter /', intern=TRUE),
     lab=system('pwd -P | cut --fields 1-8 --delimiter /', intern=TRUE),
     projects=system('pwd -P | cut --fields 1-7 --delimiter /', intern=TRUE),
     dropbox_project=system('pwd -P | cut --fields 7-10 --delimiter /', intern=TRUE),
     dropbox_complete=system('pwd -P | cut --fields 1-6 --complement --delimiter /', intern=TRUE)) |>
     {\(x) list_modify(x, website=file.path(x$project, 'project-notes'))}() |>
     {\(x) list_modify(x, content=file.path(x$website, 'content'))}() -> project_paths

#! parse the .babs file, if it exists
file.path(project_path, '.babs') %>% (\(x)
	switch(file.exists(x) |> as.character(),
	       `TRUE`={read_yaml(x) %>% pluck(1)},
	       `FALSE`={list()},
	       'error!')) -> project_babs

# connect to the project's pins board
path('pinboard') %>% (\(x)
	switch(dir.exists(x) |> as.character(),
	       `TRUE`=board_folder(x),
	       `FALSE`=NULL)) -> pinboard

#! r options
options(scipen=32,
        stringsAsFactors=FALSE,
        width=ifelse(interactive(), helpr:::get_screen_width(), 256))
