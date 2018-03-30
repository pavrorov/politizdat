
TESTFILES = typetest.test

check: $(TESTFILES) $(TESTFILES:.test=.check) applyscripts
	@for f in $(TESTFILES:.test=.tex); do \
		if ! diff $${f%.*}.check $$f; then \
			echo "Test $$f FAILED!" >&2; \
			exit 1; \
		fi; \
	done
	@echo "Check PASSED"

APPLYTOFILES := $(addprefix test/,$(TESTFILES:.test=.tex))
export APPLYTOFILES
applyscripts: $(TESTFILES:.test=.tex)
	$(MAKE) -C .. applyscripts 

%.tex: %.test
	cat $< >$@

clean:
	rm -fv $(TESTFILES:.test=.tex) $(TESTFILES:.test=.tex.bak)

.SECONDARY: $(TESTFILES:.test=.tex)
.PHONY: check clean applyscripts
.DELETE_ON_ERROR:
