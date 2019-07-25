#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
##  Setup for most Rmd needs
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Keep it clean
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(tidyverse)
library(magrittr)
# defPar <- par()
# mytheme <- theme_bw() +
# 	theme(text=element_text(family="Trebuchet MS"),
# 				axis.text = element_text(size = 10),
# 				axis.title = element_text(size = 11),
# 				plot.title = element_text(size = 12),
# 				legend.title = element_text(size = 11),
# 				legend.text = element_text(size = 10)
# 				# legend.position="none"
# 	)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# High-level graphics
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# library(Hmisc)
# library(scales)
# library(foreign)
library(extrafont)#; font_import(); loadfonts()
library(graphics)
library(tikzDevice)

dot2tex <- function(x,engine='ftikz') {
	root <- substr(x, start=1, stop=nchar(x) - 4)
	if (engine == 'ftikz') {
		system(paste0('dot2tex -tmath -ftikz --preproc ', root, '.dot | dot2tex > ', root, '.tex'))} else {
			system(paste0('dot2tex -tmath --preproc ', root, '.dot | dot2tex > ', root, '.tex'))
		}
	system(paste0('sed -i.tex "s|{article}|[12pt]{standalone}|g" ', root, '.tex'))
	system(paste0('sed -i.tex "s|\\enlargethispage{100cm}| |g" ', root, '.tex'))
	system(paste0('pdflatex ', root, '.tex'))
	system(paste0('rm ', root, c('.aux', '.tex.tex', '.log'),collapse = '; '))
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Diagramming needs
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# library(diagram)
library(DiagrammeR)
# library(dagR)
# library(vistime)

# Rothman causal pies
# rothPieTheme <- theme_minimal() +
# 	theme(
# 		axis.title = element_blank(),
# 		panel.border = element_blank(),
# 		panel.grid = element_blank(),
# 		plot.title = element_text(size = 10),
# 		text=element_text(family="Trebuchet MS"),
# 		axis.text.x=element_blank(),
# 		axis.text.y=element_blank(),
# 		legend.position="none"
# 	)
#