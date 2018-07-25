
SCRIPTS = typeset.sed postfix.sed shortwords.sed lastfix.sed
TYPECHECK = typecheck.sh

SCRIPTDIR = $(dir $(lastword $(MAKEFILE_LIST)))
ASCRIPTS = $(addprefix $(SCRIPTDIR),$(SCRIPTS))
ATYPECHECK = $(abspath $(addprefix $(SCRIPTDIR),$(TYPECHECK)))
MAXSCRIPTRETRY = 10
MAXSCRIPTCYCLES = 5

DIFFOUT = >/dev/null
PASSDIFFOUT = >/dev/null
FINALDIFFOUT = >/dev/null

default: autocorr

%.bak: % $(ASCRIPTS)
	@if [ ! $@ -ot $< ]; then \
		echo "The scripts were modified. Restore $<"; \
		mv $@ $<; \
	fi
	@cat $< >$@
	@set -e; \
	for j in $$(seq 1 $(MAXSCRIPTCYCLES)); do \
		cat $< >$<.pass; \
		for s in $(ASCRIPTS); do \
			for i in $$(seq 1 $(MAXSCRIPTRETRY)); do \
				echo "Applying $$s to $<... ($$j:$$i)" >&2; \
				cat $< | $$s >$<.temp; \
				if ! diff $< $<.temp $(PASSDIFFOUT); then \
					mv -f $<.temp $<; \
				else \
					rm $<.temp; \
					break; \
				fi; \
			done; \
			if [ $$i -eq $(MAXSCRIPTRETRY) ]; then \
				echo "Error: Too much retries" >&2; \
				touch $@; \
				exit 1; \
			fi; \
		done; \
		if diff $<.pass $< $(FINALDIFFOUT); then \
			rm $<.pass; \
			break; \
		fi; \
	done; \
	rm -f $<.pass; \
	if [ $$j -eq $(MAXSCRIPTCYCLES) ]; then \
		echo "Error: Too much cycles" >&2; \
		exit 1; \
	fi
	@touch $@

applyscripts: $(APPLYTOFILES:=.bak)

autocorr: doautocorr typecheck

doautocorr: checkscripts applyscripts
	@modified=0; \
	for t in $(APPLYTOFILES); do \
		echo "$$t" $(DIFFOUT); \
		if ! diff $$t.bak $$t $(DIFFOUT); then \
			echo "Warning: $$t was modified by the autocorrector"; \
			modified=1; \
		fi; \
	done; \
	if [ $$modified -ne 0 ]; then \
		if [ -n '$(DIFFOUT)' ]; then \
			echo "*** Please, investigate the changes using .bak copies ***"; \
		else \
			echo "*** Please, investigate the changes above ***"; \
		fi; \
		exit 2; \
	fi; \
	echo "*** Good news: the autocorrector has changed nothing. ***"

typecheck: $(ATYPECHECK)
	@ret=0; \
	$(if $(DIR),cd $(DIR);) \
	for t in $(if $(DIR),$(PARTTEXFILES),$(APPLYTOFILES)); do \
		echo "$$t" $(DIFFOUT); \
		$(ATYPECHECK) "$$t" || ret=$$?; \
	done; \
	if [ $$ret -ne 0 ]; then \
		echo "*** The type check has found some possible errors. ***"; \
		echo "*** Please, check the listed lines manually. ***"; \
		exit $$ret; \
	fi

restore:
	@for t in $(APPLYTOFILES); do \
		[ ! -e $$t.bak ] || mv -vf $$t.bak $$t; \
	done

approve:
	rm -fv $(APPLYTOFILES:=.bak)

checkscripts: $(ASCRIPTS)
	@echo "Checking the scripts..."
	make -C test

check: checkscripts

clean:
	$(MAKE) -C test clean

.PHONY: autocorr restore approve clean check
.DELETE_ON_ERROR:
