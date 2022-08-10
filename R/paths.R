#' Paths for the project
#' 
#' A list of paths to different parts of the project.
#' 
#' @param ... Ignored.
#' 
#' @value
#' A character string absolute path.
#' 
list(slug=getwd() |> basename(),
     knitting=getwd(),
     content=getwd() |> stringr::str_remove('/content/.*') |> file.path('content'),
     website=getwd() |> stringr::str_remove('/content/.*'),
     project=system('pwd -P | cut -f 1-10 -d/', intern=TRUE),
     scientist=system('pwd -P | cut -f 1-9 -d/', intern=TRUE),
     lab=system('pwd -P | cut -f 1-8 -d/', intern=TRUE),
     projects=system('pwd -P | cut -f 1-7 -d/', intern=TRUE)) -> project_paths
