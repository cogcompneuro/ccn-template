# CCN template build + visual diff
#
#   make           build everything (LaTeX + Typst)
#   make latex     build only the LaTeX PDFs
#   make typst     build only the Typst PDFs
#   make diff      build all + overlay each LaTeX PDF against the matching
#                  Typst PDF using diff-pdf; writes diff_*.pdf to a temp dir
#                  ($DIFF_DIR, default /tmp/ccn-diff/$USER) so collaborators
#                  don't trample each other's outputs
#   make clean     remove generated PDFs and aux files

LATEX_DIR := latex
TYPST_DIR := typst
DIFF_DIR  ?= /tmp/ccn-diff/$(USER)

LATEX_PDF := $(LATEX_DIR)/ccn_proceedings.pdf $(LATEX_DIR)/ccn_extended_abstract.pdf
TYPST_PDF := $(TYPST_DIR)/ccn_proceedings.pdf $(TYPST_DIR)/ccn_extended_abstract.pdf

LATEXMK ?= latexmk
TYPST   ?= typst
DIFFPDF ?= diff-pdf

.PHONY: all latex typst diff clean help
.DEFAULT_GOAL := all

all: latex typst

latex: $(LATEX_PDF)

typst: $(TYPST_PDF)

$(LATEX_DIR)/%.pdf: $(LATEX_DIR)/%.tex $(LATEX_DIR)/ccn.cls $(LATEX_DIR)/ccn_references.bib
	cd $(LATEX_DIR) && $(LATEXMK) -pdf -interaction=nonstopmode -silent $(notdir $<)

$(TYPST_DIR)/%.pdf: $(TYPST_DIR)/%.typ $(TYPST_DIR)/ccn.typ $(TYPST_DIR)/ccn_references.bib
	cd $(TYPST_DIR) && $(TYPST) compile $(notdir $<)

# Visual overlay diff. diff-pdf exit code 1 means "PDFs differ" — that's the
# expected signal, not a build failure, hence the leading `-`.
diff: all
	@mkdir -p $(DIFF_DIR)
	@echo "Diffing proceedings (LaTeX vs Typst)…"
	-@$(DIFFPDF) --output-diff=$(DIFF_DIR)/diff_proceedings.pdf --grayscale --mark-differences \
		$(LATEX_DIR)/ccn_proceedings.pdf $(TYPST_DIR)/ccn_proceedings.pdf
	@echo "Diffing extended abstract (LaTeX vs Typst)…"
	-@$(DIFFPDF) --output-diff=$(DIFF_DIR)/diff_extended_abstract.pdf --grayscale --mark-differences \
		$(LATEX_DIR)/ccn_extended_abstract.pdf $(TYPST_DIR)/ccn_extended_abstract.pdf
	@echo ""
	@echo "Diffs written to:"
	@echo "  $(DIFF_DIR)/diff_proceedings.pdf"
	@echo "  $(DIFF_DIR)/diff_extended_abstract.pdf"

clean:
	rm -f $(LATEX_DIR)/*.aux $(LATEX_DIR)/*.bbl $(LATEX_DIR)/*.bcf \
	      $(LATEX_DIR)/*.blg $(LATEX_DIR)/*.fdb_latexmk $(LATEX_DIR)/*.fls \
	      $(LATEX_DIR)/*.log $(LATEX_DIR)/*.out $(LATEX_DIR)/*.run.xml \
	      $(LATEX_DIR)/*.pdf $(TYPST_DIR)/*.pdf
	rm -rf $(DIFF_DIR)

help:
	@awk '/^[a-zA-Z_-]+:.*##/{split($$0,a,"##"); printf "  %-12s %s\n",substr(a[1],1,index(a[1],":")-1),a[2]}' $(MAKEFILE_LIST) || \
	  grep -E '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | grep -v '^\.'
