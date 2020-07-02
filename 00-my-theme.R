# My themes and helper functions ####

to_drive_D <- function(
	x,
	drive_D = T) {
	if ('drive_D' %in% ls(envir = .GlobalEnv)) {
		drive_D <- get('drive_D', envir = .GlobalEnv)
	}
	if (drive_D &
			grepl("Windows", Sys.info()['sysname'], ignore.case = T)) {
		return(
			gsub('/GM/', '/GM output/', gsub("C:/", "D:/", x))
		)
	} else {
		if (drive_D & grepl("Darwin", Sys.info()['sysname'], ignore.case = T) &
				grepl("kevinchen", Sys.info()['login'], ignore.case = T)) {
			gsub(".*/GM",
					 "/Volumes/KCHEN/GM output", x)
		} else {
			return(x)}}
}


lualatex <- function(
	pattern = ".*\\.tex",
	directory = here::here("reports"),
	magick = T,
	break_after = 30,
	png_density = 400) {

	dir.create(directory, F, T)
	if (magick) {dir.create(paste0(gsub("/$", "", directory), "/images"), F, T)}

	if (!grepl("\\.tex$", pattern)) {
		pattern <- paste0(pattern, "\\.tex")
	}

	if (grepl("Windows", Sys.info()['sysname'], ignore.case = T)) {
		# Windows
		library(stringr)
		directory <- gsub("/", "\\", directory)
		invisible(sapply(
			grep(pattern, list.files(directory), value = T), function(
				file.tex) {system((paste(
					paste0("cd \"", directory, "\"\n"),
					paste0("for %i in (", file.tex, ") do"),
					"lualatex \"$i\"; del \"%~ni.log\"; del \"%~ni.aux\";",
					if (magick) {
						paste0("magick -density ", png_density, " \"%~ni.pdf\" \".\\images\\%~ni.png\"")
						} else {NULL},
					sep = " ")), timeout = break_after)}
		))
	}
	if (grepl("Darwin", Sys.info()['sysname'], ignore.case = T)) {
		# OS X
		invisible(sapply(
			grep(pattern, list.files(directory), value = T), function(
				file.tex) {system((paste(
					paste0("cd \"", directory, "\";"),
					paste0("for i in \"", file.tex,"\"; do {"),
					"lualatex \"$i\"; rm \"${i%.tex}.aux\";",
					if (magick) {
						paste0("magick -density ", png_density, " \"${i%.tex}.pdf\" \"./images/${i%.tex}.png\";")
						} else {NULL},
					"} done", sep = "\n")), timeout = break_after)}
		))
	}
}


library(extrafont)
loadfonts()
library(ggrepel)
# library(tikzDevice)

library(ggplot2)
library(viridis)
library(cowplot)
library(xtable)
library(tikzDevice)

library(knitr)

mytheme <- theme_bw() +
	theme(
		axis.text = element_text(size = 6, color = "black"),
		axis.title = element_text(size = 8),
		plot.title = element_text(size = 8),
		legend.title = element_text(size = 8),
		legend.text = element_text(size = 8),
		strip.text = element_text(size = 8, margin = margin(5, 5, 5, 5, "pt"))
		# legend.position="none"
	)

mytheme.web <- theme_bw() +
	theme(
		axis.text = element_text(size = 12, color = 'black'),
		axis.title = element_text(size = 12),
		plot.title = element_text(size = 12),
		legend.title = element_text(size = 12),
		legend.text = element_text(size = 12),
		strip.text = element_text(size = 12)
		# legend.position="none"
	)

tikzLualatexPackages.option <- getOption("tikzLualatexPackages")

options(
	xtable.comment = F,
	xtable.include.rownames = F,
	xtable.booktabs = T,
	xtable.sanitize.text.function = function(x) {
		x
	},
	xtable.floating = F,
	# floatrow does not respect H
	xtable.table.placement = "H",
	xtable.caption.placement = 'top',
	tikzLatexPackages = c(
		"\\usepackage{tikz}",
		"\\usepackage[active,tightpage]{preview}",
		"\\PreviewEnvironment{pgfpicture}",
		"\\setlength\\PreviewBorder{0pt}",
		"\\usepackage{bm}"
	),
	knitr.kable.NA = "",
	tikzDefaultEngine = 'luatex',
	tikzLualatexPackages = c(
		# "\\usepackage[utf8]{inputenc}",
		"\\usepackage{amssymb}",
		"\\usepackage[no-math]{fontspec}\n",
		paste0(
			"\\setmainfont{Arial}",
			ifelse(Sys.info()["sysname"] == "Darwin" &
						 	Sys.info()["login"] == "kevinchen",
						 "\n",
						 "[Extension = .ttf,
			UprightFont = *,
			BoldFont = *bd,
			talicFont = *i,
			BoldItalicFont = *bi]\n")),
		"\\usepackage[italic]{mathastext}",
		"\\usepackage{tikz}\n",
		"\\usepackage[active,tightpage,psfixbb]{preview}\n",
		"\\PreviewEnvironment{pgfpicture}\n",
		"\\setlength\\PreviewBorder{0pt}\n"
	)
)


library(pander)
panderOptions('table.split.table', 500)
