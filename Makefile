## Makefile для сборки проекта
## ---------------------------

## Имя основного файла издания без суффикса .tex:
BASENAME = testbook

## Опциональный суффикс для выбора варианта (прибавляется к BASENAME):
TYPE =

## Имена составных частей издания без префикса $(BASENAME) и
## суффикса .tex (таки образом имена файлов должны соответствовать
## шаблону $(BASENAME).имя.tex):
PARTS = title annot fw ch1 ch2

## Список файлов библиографии из директории bib/ (без суффикса):
BIB = marx-engels lenin stalin ikki misc philosophy plehanov \
	  s-d revision reaction

## Команда для внесения произвольных исправлений в файл .bbl:
FIXBBL = 

## Сборка выполняется командой `make`. Удалить PDF и промежуточные
## файлы можно командой `make clean`.
##
## Запуск автокорректора --- командой `make autocorr`.
## Для принятия или отката изменений автокорректора есть
## команды `make approve` и `make restore` соответственно.
##
## Кроме автокорректора есть ещё команда `make typecheck` для
## поиска "подозрительных" мест в наборе, которые не обязательно
## являются ошибками, но требуют ручного контроля.


# -----

NAME = $(BASENAME)$(if $(TYPE),.$(TYPE))

LATEX = lualatex
BIBTEX = biber
MAXRERUN = 5

TEXT = $(addprefix $(BASENAME).,$(PARTS))
PARTTEXFILES = $(addsuffix .tex,$(TEXT))
TEXFILES = $(NAME).tex $(PARTTEXFILES)

BOOKSUF = .book
SIGNATURE = 16

BIBFILES = $(addsuffix .bib,$(addprefix bib/,$(BIB)))

MAKEFILEDIR = $(dir $(lastword $(MAKEFILE_LIST)))
SCRIPTDIR = $(MAKEFILEDIR)scripts

pdf: $(NAME).pdf

clean: clean-book
	rm -fv $(addprefix $(NAME),.aux .toc .out .log .run.xml \
		   .bcf .bbl .blg .pdf)
	for i in `seq 1 $(MAXRERUN)`; do rm -fv $(NAME).$$i.aux; done
	$(MAKE) -C $(SCRIPTDIR) clean

$(NAME).aux $(if $(BIBFILES),$(NAME).bcf) $(NAME).toc: $(TEXFILES)
	$(LATEX) $(NAME)

run: $(TEXFILES)
	$(LATEX) $(NAME)
	@if grep -q '$(CHECKUBOX)' $(NAME).log; then \
		echo "Warning: underfull boxes."; \
	fi
	@if grep -n --color '$(CHECKOBOX)' $(NAME).log; then \
		exit 1; \
	fi

$(NAME).bbl: $(NAME).aux $(if $(BIBFILES),$(NAME).bcf $(BIBFILES) $(FIXBBL))
	$(if $(BIBFILES),$(BIBTEX) $(NAME))
	$(if $(FIXBBL),cat $@ | $(FIXBBL) >$@.temp && mv -f $@.temp $@)

$(NAME).pdf: $(if $(BIBFILES),$(NAME).bbl) $(NAME).toc
	$(LATEX) $(NAME)
	@if ! grep -q 'There were undefined references' $(NAME).log; then \
		run=1; while [ $$run -lt $(MAXRERUN) ] && grep -q 'Page breaks have changed\.' $(NAME).log; do \
			cp -vf $(NAME).aux $(NAME).$$run.aux; \
			run=$$((run + 1)); \
			$(LATEX) $(NAME); \
		done; \
		touch $(NAME).bbl; \
	else \
		echo "Warning: There were undefined references!"; \
		exit 1; \
	fi
	@if grep -q 'Page breaks have changed\.' $(NAME).log; then \
		echo "Warning: Page breaks have changed!"; \
		exit 2; \
	else \
		touch $(NAME).pdf; \
	fi
	@if grep -q '$(CHECKUBOX)' $(NAME).log; then \
		echo "Warning: underfull boxes."; \
	fi
	@if grep -n --color '$(CHECKOBOX)' $(NAME).log; then \
		exit 1; \
	fi

CHECKOBOX = Overfull[[:space:]]\(\\[^[:space:]]\)*box
CHECKUBOX = Underfull[[:space:]]\(\\[^[:space:]]\)*box

checkbox: $(NAME).log
	@grep -A2 -n --color '$(CHECKUBOX)' $(NAME).log ||:
	@if grep -A2 -n --color '$(CHECKOBOX)' $(NAME).log; then \
		exit 1; \
	fi

remake: clean pdf

export PARTTEXFILES
APPLYTOFILES = $(abspath $(PARTTEXFILES))
export APPLYTOFILES
autocorr:
	$(MAKE) -C $(SCRIPTDIR)
typecheck:
	$(MAKE) -C $(SCRIPTDIR) typecheck DIR=..
restore:
	$(MAKE) -C $(SCRIPTDIR) restore
approve:
	$(MAKE) -C $(SCRIPTDIR) approve

.PHONY: clean autocorr restore approve checkbox remake diff clean-diff \
		project-rename book booklet clean-book cleanup-nesting

.DELETE_ON_ERROR:

DIFFRES = 600
diff: | clean-diff
	@if [ ! -e $(NAME).pdf ]; then \
		echo "Please, make the $(NAME).pdf first"; \
	fi
	@if [ -z "$(B)" ]; then \
		echo "Please, specify the file to compare as B="; \
		exit 2; \
	fi
	@echo "Making $(NAME).pdf pages..."
	gs -q -sDEVICE=pbm -dNOPAUSE -dBATCH -sOutputFile=A-%04d.pbm -r$(DIFFRES) $(NAME).pdf
	@echo "Making $(B) pages..."
	gs -q -sDEVICE=pbm -dNOPAUSE -dBATCH -sOutputFile=B-%04d.pbm -r$(DIFFRES) $(B)
	@echo "Comparing pages..."
	@differ=0; \
	for b in B-[0-9][0-9][0-9][0-9].pbm; do \
		if diff $$b A$${b#B} >/dev/null; then \
			rm -f $$b A$${b#B}; \
		else \
			differ=1; \
			p=$${b#B-}; p=$${p%.pbm}; \
			echo "Page $$p differ (see A$${b#B} and $$b)"; \
		fi; \
	done; \
	if [ $$differ -eq 0 ]; then \
		echo "The $(NAME).pdf and $(B) files are the same"; \
	else \
		exit 1; \
	fi

clean-diff:
	@rm -f A-[0-9][0-9][0-9][0-9].pbm \
		   B-[0-9][0-9][0-9][0-9].pbm

## ---

W2L_CONF = $(MAKEFILEDIR)/w2l.conf.xml

%.odt: %.doc
	lowriter --headless --convert-to odt '$<'

%.odt: %.docx
	lowriter --headless --convert-to odt '$<'

%.tex: %.odt $(W2L_CONF)
	w2l -latex -config=$(W2L_CONF) '$<' '$@'
	sed -i -f $(SCRIPTDIR)/replace.sed '$@'
	sed -i -f $(SCRIPTDIR)/w2l.post.sed '$@'

replace: $(PARTTEXFILES)
	for f in $(PARTTEXFILES); do \
		sed -i -f $(SCRIPTDIR)/replace.sed $$f; \
	done

## ---

%.tex: %.md
	pandoc -S -f markdown -t latex -o $@ $<

%.html: %.tex
	$(SCRIPTDIR)/simplify.sed $< >.$<
	pandoc -S $(EXPORTOPTS) -f latex -t html -o $@ .$<

%.export.odt: %.tex
	$(SCRIPTDIR)/simplify.sed $< >.$<
	pandoc -S $(EXPORTOPTS) -f latex -t odt -o $@ .$<

## ---

define newline


endef

MAKEFILE = $(lastword $(MAKEFILE_LIST))
TOPDIR = $(dir $(MAKEFILE))
project-rename:
	@$(if $(TO),:,echo "Usage: project-rename TO=<new name>"; exit 1)
	$(foreach p,$(PARTS),$(if $(wildcard $(TOPDIR)/.git),git) mv $(BASENAME).$(p).tex $(TO).$(p).tex$(newline))
	$(if $(wildcard $(TOPDIR)/.git),git) mv $(BASENAME).tex $(TO).tex
	sed -i$(foreach p,$(PARTS), -e 's/\\input{$(BASENAME).$(p)}/\\input{$(TO).$(p)}/') $(TO).tex
	sed -i -e 's/^BASENAME = .*/BASENAME = $(TO)/' $(MAKEFILE)


book: $(NAME)$(BOOKSUF).pdf

$(NAME)$(BOOKSUF).pdf: $(NAME)$(BOOKSUF).tex $(NAME).pdf
	$(LATEX) $(NAME)$(BOOKSUF)

$(NAME)$(BOOKSUF).tex:
	echo '\documentclass{article}'	>$@
	echo '\usepackage{pdfpages}'	>>$@
	echo '\begin{document}'			>>$@
	echo '\includepdf[pages=-,landscape=true,signature=$(SIGNATURE)]{$(NAME)}' >>$@
	echo '\end{document}'			>>$@

booklet: $(NAME)$(BOOKSUF).tex
	sed -i -e 's/signature=[0-9]\+/booklet=true/' $<
	$(LATEX) $(NAME)$(BOOKSUF)

clean-book:
	rm -fv $(NAME)$(BOOKSUF).tex $(NAME)$(BOOKSUF).pdf

cleanup-nesting:
	sed -i -e '/^[[:space:]]*\\\(begin\|end\){[[:space:]]*midsloppypar[[:space:]]*}[[:space:]]*$$/ d' \
		   -e '/^[[:space:]]*\\enlargethispage{[^}]\+}[[:space:]]*$$/ d' \
		   -e '/^[[:space:]]*\\setprechapter{[[:space:]]*\\v\(space\*\?{\|skip\)[^}]\+\(}[[:space:]]*\)\+$$/ d' \
		   -e '/^[[:space:]]*\\\(markend\|goodbreak\)[[:space:]]*$$/ d' \
		$(TEXFILES)
