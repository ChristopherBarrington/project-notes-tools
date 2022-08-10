#' Paths for the project
#' 
#' A list of functions that provide paths to different parts of the project.
#' 
#' @param ... Ignored.
#' 
#' @value
#' Each function returns a character string absolute path.
#' 
# list(slug=function(...) getwd() |> basename(),
#      knitting=function(...) getwd(),
#      content=function(...) getwd() |> stringr::str_remove('/content/.*') |> file.path('content'),
#      website=function(...) getwd() |> stringr::str_remove('/content/.*'),
#      project=function(...) system('pwd -P | cut -f 1-10 -d/', intern=TRUE),
#      scientist=function(...) system('pwd -P | cut -f 1-9 -d/', intern=TRUE),
#      lab=function(...) system('pwd -P | cut -f 1-8 -d/', intern=TRUE),
#      projects=function(...) system('pwd -P | cut -f 1-7 -d/', intern=TRUE)) -> project_paths
