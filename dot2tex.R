# dot2tex helper
# Kevin Chen
# August 8, 2019

dot2tex <- function(root, directory,
										format = 'pgf',
										prog = "dot",
										fig_only = T,
										break_after = 30) {

	if (grepl("\\.dot$|\\.gv$", root)) {
		root <- gsub("\\.dot$", "", root)
		root <- gsub("\\.gv$", "", root)
		}

	con <- file(paste0(directory, "/", root, ".sh"))
	writeLines(paste0(
		"cd ", directory, ";\n",
		'dot2tex -traw',
		paste0(" -f", format),
		' --preproc ', root, '.dot',
		' | dot2tex',
		paste0(" --prog=", prog),
		ifelse(fig_only, " --figonly", ""),
		' > ', root, '.tex', ";\n",
		NULL
	),
	con)
	close.connection(con)
	system(paste0(
		"source ~/.zprofile", "\n",
		"source ", paste0(directory, "/", root, ".sh", "\n"),
		"rm ", paste0(directory, "/", root, ".sh")))
}
