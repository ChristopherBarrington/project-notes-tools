#' Paths for the project
#' 
#' A list of functions that provide paths to different parts of the project.
#' 
#' @param ... Ignored.
#' 
#' @value
#' Each function returns a character string absolute path.
#' 
#' @importFrom magrittr %>%
#' @importFrom stringr str_remove
#' 
#' @export
#' 
list(slug=function(...) getwd() %>% basename(),
     knitting_path=function(...) getwd(),
     content_path=function(...) getwd() %>% file.path(., 'content'),
     website_path=function(...) getwd() %>% str_remove('/content/.*'),
     project_path=function(...) system('pwd -P | cut -f 1-10 -d/', intern=TRUE),
     scientist_path=function(...) system('pwd -P | cut -f 1-9 -d/', intern=TRUE),
     lab_path=function(...) system('pwd -P | cut -f 1-8 -d/', intern=TRUE),
     projects_path=function(...) system('pwd -P | cut -f 1-7 -d/', intern=TRUE)) -> project_paths
