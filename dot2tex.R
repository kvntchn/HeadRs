# dot2tex helper
# Kevin Chen
# August 8, 2019

dot2tex <- function(root, dir, engine='ftikz') {
	if (grepl(".dot", root)) {
		root <- substr(root, start=1, stop=nchar(x) - 4)}
		if (grepl(".gv", root)) {
		root <- substr(root, start=1, stop=nchar(x) - 3)}
	root <- paste0('dir', '/', 'root')
	if (engine == 'ftikz') {
		system(paste0('dot2tex -tmath -ftikz --preproc ', root, '.dot | dot2tex > ', root, '.tex'))} else {
			system(paste0('dot2tex -tmath --preproc ', root, '.dot | dot2tex > ', root, '.tex'))
		}
	system(paste0('sed -i.tex "s|{article}|[12pt]{standalone}|g" ', root, '.tex'))
	system(paste0('sed -i.tex "s|\\enlargethispage{100cm}| |g" ', root, '.tex'))
	system(paste0('pdflatex ', root, '.tex'))
	system(paste0('rm ', root, c('.aux', '.tex.tex', '.log'),collapse = '; '))
}
