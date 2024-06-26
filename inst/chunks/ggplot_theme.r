# -----------------------------------------
# define a generic customised ggplot theme
# -----------------------------------------

require(project.notes.tools)

(theme_bw() +
 theme(text=element_text(size=10, colour='black'),
       panel.grid.minor=element_blank(),
       strip.background=element_blank())) %>%
theme_set()
