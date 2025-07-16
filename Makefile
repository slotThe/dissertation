COMPILE_FLAGS := -file-line-error -interaction=batchmode -halt-on-error -fmt=prec.fmt
.PHONY: clean nuke compress

define manual_compile_work
	make prec.fmt
	pdflatex $(COMPILE_FLAGS) -draftmode main
	bibtex main
	pdflatex $(COMPILE_FLAGS) -draftmode main
	pdflatex $(COMPILE_FLAGS) -draftmode main
	pdflatex $(COMPILE_FLAGS) main
endef

# Externalisation means some references inside of TikZ pictures will not show
# up, but it's *much* faster than the actual main.pdf job.
draft: main.tex figures chapters prec.fmt prec.tex main.bib
	mkdir -p figures-ext
	pdflatex -shell-escape $(COMPILE_FLAGS) main # potentially creates figures
	bibtex main
	pdflatex $(COMPILE_FLAGS) -draftmode main
	pdflatex $(COMPILE_FLAGS) -synctex=1 main

prec.fmt: prec.tex styles
	pdflatex -ini -file-line-error -jobname="prec" "&pdflatex prec.tex\dump"

compress: main.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -sOutputFile=main-compressed.pdf main.pdf

# No externalisation (so all references show up).
main.pdf: main.tex figures chapters prec.fmt prec.tex
	sed -i 's/externalize=true/externalize=false/' prec.tex
	$(call manual_compile_work)
	sed -i 's/externalize=false/externalize=true/' prec.tex

# No externalisation (so all references show up) and no link colours.
print: main.tex figures chapters prec.fmt prec.tex main.bib
	sed -i 's/externalize=true/externalize=false,colorlinks=false/' prec.tex
	$(call manual_compile_work)
	sed -i 's/externalize=false,colorlinks=false/externalize=true/' prec.tex

clean:
	latexmk -C
	rm -f *.xml *.auxlock *.ptb *-blx.bib *.bbl *.aux *.log *.fls *_latexmk *.nav *.out *.snm *.toc _region_* *.blg *.fmt *.lox *.mmz *.xmpdata
	rm -fr _region_.prv/
	rm -fr auto/
	sed -i 's/externalize=false,colorlinks=false/externalize=true/' prec.tex

nuke:
	make clean
	rm figures-ext/*
