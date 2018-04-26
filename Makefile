## Makefile для сборки проекта
## ---------------------------

## Имя основного файла издания без суффикса .tex:
BASENAME = testbook

## Опциональный суффикс для выбора варианта (прибавляется к BASENAME):
TYPE =

## Имена составных частей издания без префикса $(BASENAME) и
## суффикса .tex (таки образом имена файлов должны соответствовать
## шаблону $(BASENAME).имя.tex):
PARTS = title fw ch1 ch2

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


# -----

NAME = $(BASENAME)$(if $(TYPE),.$(TYPE))

LATEX = lualatex
BIBTEX = biber
MAXRERUN = 5

TEXT = $(addprefix $(BASENAME).,$(PARTS))
PARTTEXFILES = $(addsuffix .tex,$(TEXT))
TEXFILES = $(NAME).tex $(PARTTEXFILES)

BIBFILES = $(addsuffix .bib,$(addprefix bib/,$(BIB)))

pdf: $(NAME).pdf

clean:
	rm -fv $(addprefix $(NAME),.aux .toc .out .log .run.xml \
		   .bcf .bbl .blg .pdf)
	for i in `seq 1 $(MAXRERUN)`; do rm -fv $(NAME).$$i.aux; done
	$(MAKE) -C scripts clean

$(NAME).aux $(NAME).bcf $(NAME).toc: $(TEXFILES)
	$(LATEX) $(NAME)

run: $(TEXFILES)
	$(LATEX) $(NAME)
	@if grep -q '$(CHECKUBOX)' $(NAME).log; then \
		echo "Warning: underfull boxes."; \
	fi
	@if grep -n --color '$(CHECKOBOX)' $(NAME).log; then \
		exit 1; \
	fi

$(NAME).bbl: $(NAME).aux $(NAME).bcf $(BIBFILES) $(FIXBBL)
	$(BIBTEX) $(NAME)
	$(if $(FIXBBL),cat $@ | $(FIXBBL) >$@.temp && mv -f $@.temp $@)

$(NAME).pdf: $(NAME).bbl $(NAME).toc
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

APPLYTOFILES = $(addprefix ../,$(PARTTEXFILES))
export APPLYTOFILES
autocorr:
	$(MAKE) -C scripts
restore:
	$(MAKE) -C scripts restore
approve:
	$(MAKE) -C scripts approve

.PHONY: clean autocorr restore approve checkbox remake diff clean-diff

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
