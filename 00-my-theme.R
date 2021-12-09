# My themes and helper functions ####
library(tidyverse)
library(xtable)
library(pander)
library(tikzDevice)
library(knitr)

# Yihui's softwrap
hook_output = knit_hooks$get('output')
knit_hooks$set(output = function(x, options) {
	# this hook is used only when the linewidth option is not NULL
	if (!is.null(n <- options$linewidth)) {
		x = knitr:::split_lines(x)
		# any lines wider than n should be wrapped
		if (any(nchar(x) > n)) x = strwrap(x, width = n)
		x = paste(x, collapse = '\n')
	}
	hook_output(x, options)
})

# Path on external drive with analogous file hierarchy
to_drive_D <- function(
	x,
	drive_D = T,
	here.dir = NULL) {
	here.dir <- gsub(".*/", "", ifelse(is.null(here.dir), here::here(), here.dir))
	if ('drive_D' %in% ls(envir = .GlobalEnv)) {
		drive_D <- get('drive_D', envir = .GlobalEnv)
	}
	if (drive_D &
			grepl("Windows", Sys.info()['sysname'], ignore.case = T)) {
		return(
			gsub('/GM[A-Za-z-]*',
					 paste0('/GM output/', here.dir),
					 gsub("C:/", "D:/", x), ignore.case = T)
		)
	} else {
		if (drive_D & grepl("Darwin", Sys.info()['sysname'], ignore.case = T) &
				grepl("kevinchen", Sys.info()['login'], ignore.case = T)) {
			gsub(".*/GM[A-Za-z-]*",
					 paste0(ifelse(dir.exists("/Volumes/KCHEN/GM output/"), "/Volumes/KCHEN/GM output/",""),
					 			 here.dir,
					 			 ifelse(dir.exists("/Volumes/KCHEN/GM output/"), "","/private")), x, ignore.case = T)
		} else {
			return(x)}}
}

# Run LuaLaTex
latex <- function(
	pattern = ".*\\.tex",
	directory = here::here("reports"),
	magick = T,
	break_after = 30,
	img_density = 400,
	img_format = "png",
	compiler = "latex",
	compilation.options = NULL) {

	dir.create(directory, F, T)
	if (magick) {dir.create(paste0(gsub("/$", "", directory), "/images"), F, T)}

	if (!grepl("\\.tex$", pattern, ignore.case = T)) {
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
					paste0(compiler, " ",
								 paste(compilation.options, collapse = " "),
								 " \"$i\""),
					"; del \"%~ni.log\"; del \"%~ni.aux\";",
					if (magick) {
						paste0("magick -density ", img_density, " \"%~ni.pdf\" \".\\images\\%~ni.", img_format, "\"")
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
					paste0(compiler, " ", paste(compilation.options, collapse = " "),
								 "\"$i\";"),
					"rm \"${i%.tex}.aux\"; rm \"${i%.tex}.log\"; rm \"${i%.tex}.out\";",
					if (magick) {
						paste0("magick -density ", img_density, " \"${i%.tex}.pdf\" \"./images/${i%.tex}.", img_format, "\";")
					} else {NULL},
					"} done", sep = "\n")), timeout = break_after)}
		))
	}
}

lualatex <- function(
	pattern = ".*\\.tex",
	directory = here::here("reports"),
	magick = T,
	break_after = 30,
	img_density = 400,
	img_format = "png",
	compilation.options = NULL) {
	return(latex(pattern, directory, magick, break_after, img_density, img_format, compiler = "lualatex", compilation.options))
}

# My ggplot theme for pdf
mytheme <- theme_bw() +
	theme(
		axis.text = element_text(size = 8, color = "black"),
		axis.title = element_text(size = 9),
		plot.title = element_text(size = 9),
		plot.subtitle = element_text(size = 8),
		legend.title = element_text(size = 9),
		legend.text = element_text(size = 9),
		plot.caption = element_text(size = 8),
		strip.text = element_text(size = 9, margin = margin(2.5, 2.5, 2.5, 2.5, "pt"))
		# legend.position="none"
	)

# My ggplot theme for html
mytheme.web <- theme_bw() +
	theme(
		axis.text = element_text(size = 12, color = 'black'),
		axis.title = element_text(size = 12),
		plot.title = element_text(size = 12),
		plot.subtitle = element_text(size = 10),
		legend.title = element_text(size = 12),
		legend.text = element_text(size = 12),
		plot.caption = element_text(size = 10),
		strip.text = element_text(size = 12)
		# legend.position="none"
	)

# https://github.com/clauswilke/dviz.supp/blob/master/R/align_legend.R
align_legend <- function(p, hjust = 0.5) {
	# extract legend
	g <- cowplot::plot_to_gtable(p)
	grobs <- g$grobs
	legend_index <- which(sapply(grobs, function(x) x$name) == "guide-box")
	legend <- grobs[[legend_index]]

	# extract guides table
	guides_index <- which(sapply(legend$grobs, function(x) x$name) == "layout")

	# there can be multiple guides within one legend box
	for (gi in guides_index) {
		guides <- legend$grobs[[gi]]

		# add extra column for spacing
		# guides$width[5] is the extra spacing from the end of the legend text
		# to the end of the legend title. If we instead distribute it by `hjust:(1-hjust)` on
		# both sides, we get an aligned legend
		spacing <- guides$width[5]
		guides <- gtable::gtable_add_cols(guides, hjust*spacing, 1)
		guides$widths[6] <- (1-hjust)*spacing
		title_index <- guides$layout$name == "title"
		guides$layout$l[title_index] <- 2

		# reconstruct guides and write back
		legend$grobs[[gi]] <- guides
	}

	# reconstruct legend and write back
	g$grobs[[legend_index]] <- legend
	g
}

# Save default TikZ options
tikzLualatexPackages.option <- getOption("tikzLualatexPackages")
# Set TikZ Options
options(
	tikzLatexPackages = c(
		"\\usepackage{tikz}\n",
		"\\usepackage[active,tightpage,psfixbb]{preview}\n",
		"\\PreviewEnvironment{pgfpicture}\n",
		"\\setlength\\PreviewBorder{0pt}\n",
		# "\\input{\\string~/HeadRs/common_supplement.tex}\n",
		# "\\input{\\string~/HeadRs/stathead.sty}\n",
		NULL
	),
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
		"\\setlength\\PreviewBorder{0pt}\n",
		# "\\input{\\string~/HeadRs/common_supplement.tex}\n",
		# "\\input{\\string~/HeadRs/stathead.sty}\n",
		NULL
	)
)

# Set xtable and kable options
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
	knitr.kable.NA = "")

# Set pander table split options
panderOptions('table.split.table', 500)
panderOptions('table.split.cells', 40)
