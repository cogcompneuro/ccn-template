# CCN template build + visual diff
#
#   make           build everything in submission mode (LaTeX + Typst)
#   make latex     build only the LaTeX PDFs (submission mode)
#   make typst     build only the Typst PDFs (submission mode)
#   make diff      build BOTH templates in EVERY applicable mode, then
#                  overlay each LaTeX PDF against the matching Typst PDF
#                  via diff-pdf. Output goes to DIFF_DIR (default
#                  /tmp/ccn-diff).
#                  Six combinations are produced:
#                    proceedings        × {submission, preprint, proceedings}
#                    extended_abstract  × {submission, preprint, extended-abstract}
#   make clean     remove generated PDFs and aux files

LATEX_DIR := latex
TYPST_DIR := typst
DIFF_DIR  ?= /tmp/ccn-diff

DOI_PLACEHOLDER := 10.1234/ccn.2026.001

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

# Visual overlay diff across all (template, mode) combinations.
# diff-pdf exit code 1 means "PDFs differ" — that's the expected signal
# while the Typst port is still converging on LaTeX rendering, so the
# target tolerates it.
diff:
	@mkdir -p $(DIFF_DIR)
	@for tpl in ccn_proceedings ccn_extended_abstract; do \
	  if [ "$$tpl" = "ccn_proceedings" ]; then \
	    modes="submission preprint proceedings"; \
	  else \
	    modes="submission preprint extended-abstract"; \
	  fi; \
	  for mode in $$modes; do \
	    out="$(DIFF_DIR)/$$tpl-$$mode"; \
	    rm -rf "$$out"; mkdir -p "$$out/latex" "$$out/typst"; \
	    cp $(LATEX_DIR)/ccn.cls $(LATEX_DIR)/ccn_references.bib "$$out/latex/"; \
	    cp $(TYPST_DIR)/ccn.typ $(TYPST_DIR)/ccn_references.bib "$$out/typst/"; \
	    awk -v m="$$mode" -v doi="$(DOI_PLACEHOLDER)" '\
	      /^\\documentclass\{ccn\}/ { \
	        if (m == "submission") print; \
	        else { print "\\documentclass[" m "]{ccn}"; \
	               if (m == "proceedings") print "\\ccndoi{" doi "}" } \
	        next } { print }' \
	      $(LATEX_DIR)/$$tpl.tex > "$$out/latex/$$tpl.tex"; \
	    awk -v m="$$mode" -v doi="$(DOI_PLACEHOLDER)" '\
	      /mode: "submission",/ { \
	        if (m == "submission") print; \
	        else if (m == "proceedings") \
	          print "  mode: \"proceedings\", doi: \"" doi "\","; \
	        else \
	          print "  mode: \"" m "\","; \
	        next } { print }' \
	      $(TYPST_DIR)/$$tpl.typ > "$$out/typst/$$tpl.typ"; \
	    echo "=== $$tpl × $$mode ==="; \
	    (cd "$$out/latex" && $(LATEXMK) -pdf -interaction=nonstopmode -silent $$tpl.tex >/dev/null 2>&1) || echo "  ! LaTeX build failed"; \
	    (cd "$$out/typst" && $(TYPST) compile $$tpl.typ 2>/dev/null) || echo "  ! Typst build failed"; \
	    if [ -f "$$out/latex/$$tpl.pdf" ] && [ -f "$$out/typst/$$tpl.pdf" ]; then \
	      $(DIFFPDF) --output-diff=$(DIFF_DIR)/diff_$$tpl-$$mode.pdf --grayscale --mark-differences \
	        "$$out/latex/$$tpl.pdf" "$$out/typst/$$tpl.pdf" >/dev/null 2>&1; \
	      echo "  → $(DIFF_DIR)/diff_$$tpl-$$mode.pdf"; \
	    else \
	      echo "  ! diff skipped (missing PDF)"; \
	    fi; \
	  done; \
	done
	@echo ""
	@echo "All diffs under $(DIFF_DIR)/"

clean:
	rm -f $(LATEX_DIR)/*.aux $(LATEX_DIR)/*.bbl $(LATEX_DIR)/*.bcf \
	      $(LATEX_DIR)/*.blg $(LATEX_DIR)/*.fdb_latexmk $(LATEX_DIR)/*.fls \
	      $(LATEX_DIR)/*.log $(LATEX_DIR)/*.out $(LATEX_DIR)/*.run.xml \
	      $(LATEX_DIR)/*.pdf $(TYPST_DIR)/*.pdf
	rm -rf $(DIFF_DIR)
