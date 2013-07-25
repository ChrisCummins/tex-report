# Makefile for tex projects.
#
# Copyright (C) 2013 Chris Cummins <chrisc.101@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Portability
CD         := cd
RM         := rm -fv
TEX        := pdftex                      \
               -output-format pdf         \
               -progname pdflatex         \
               -file-line-error           \
	       -interaction errorstopmode
PDF_READER := xdg-open

# Customisation
WC_SCRIPT  := .tex/wc.sh
WC_FILE    := wc.tex
WC         := $(shell $(WC_SCRIPT) | tail -n1 | awk '{ print $$1 }')

SOURCE_DIR := .
SOURCES    := $(wildcard $(SOURCE_DIR)/*.tex) $(WC_FILE)
TMP_FILES  := `find . \( -name "*.aux"   \
                      -o -name "*.log"   \
                      -o -name "*.lof"   \
                      -o -name "*.toc" \) -print`

INIT_FILE  := .tex/initialised
INIT_SCRIPT:= .tex/setup.sh

all: $(SOURCES)
# First time setup
ifeq ($(wildcard $(INIT_FILE)),)
	@$(INIT_SCRIPT)
	touch $(INIT_FILE)
endif
	$(CD) $(SOURCE_DIR) && $(TEX) main.tex
	$(CD) $(SOURCE_DIR) && $(TEX) main.tex
	$(RM) $(SOURCE_DIR)/$(WC_FILE)
	$(RM) $(TMP_FILES)
# Show wordcount
ifneq ($(wildcard $(INIT_FILE)),)
	@$(WC_SCRIPT)
endif

$(WC_FILE):
	@echo "Word count: $(WC)." > $(WC_FILE)

.PHONY: clean

clean:
	$(RM) $(TMP_FILES)
	$(RM) `find . -name '*.pdf'`

open:
	@$(PDF_READER) main.pdf &>/dev/null
