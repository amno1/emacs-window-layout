.POSIX:
.PHONY: clean compile native fix-cl uninstall install-native install-all install
.SUFFIXES: .el .elc .eln

SRCS := $(wildcard *.el)

LISPINCL ?= $(addprefix -L ,${HOME}/.emacs.d/lisp)
LISPINCL += -L .
LISPINCL += $(addprefix -L ,${HOME}/.emacs.d/elpa/sauron-*)

ifeq ($(PREFIX),)
    PREFIX := ${HOME}/.emacs.d/
endif

EM = emacs --batch

%.elc: %.el
	$(EM) $(LISPINCL) -f batch-byte-compile $<

.elc.eln:
	$(EM) $(LISPINCL) --eval '(native-compile "$<")'

fix-cl:
	./bash-fix-old-cl.sh

compile: fix-cl ${patsubst %.el, %.elc, $(SRCS)}

native: ${patsubst %.el, %.eln, $(SRCS)}

install: compile
	mkdir -p $(DESTDIR)$(PREFIX)/lisp
	cp *.el $(DESTDIR)$(PREFIX)/lisp
	cp *.elc $(DESTDIR)$(PREFIX)/lisp

install-native: native
	cp eln-*/* $(DESTDIR)$(PREFIX)/lisp/eln-*

install-all: install install-native

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/lisp/ne2wm-*

clean:
	rm -rf *.elc eln-*

