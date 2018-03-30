
TESTFILES = typetest.test

check: $(PARTTEXFILES) $(PARTTEXFILES:.test=.check) applyscripts
	@for f in $(PARTTEXFILES); do \
		if ! diff $${f%.*}.check $$f; then \
			echo "Test $$f FAILED!" >&2; \
			exit 1; \
		fi; \
	done

%.tex: %.test
	cp -f $< $@

clean:
	rm -fv $(TESTFILES:.test=.tex)

PARTTEXFILES = $(TESTFILES:.test=.tex)
include ../scripts/Makefile
