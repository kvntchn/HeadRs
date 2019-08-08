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