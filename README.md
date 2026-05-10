# CCN Template

Official templates for submission to the [Conference on Cognitive Computational Neuroscience (CCN)](https://ccneuro.org).
See the [CCN documentation](https://cogcompneuro.github.io/docs/) for detailed instructions on submission to CCN.

## LaTeX

### Templates

- **`latex/ccn_proceedings.tex`** — Full proceedings paper (8 pages + references)
- **`latex/ccn_extended_abstract.tex`** — Extended abstract (2 pages + references)

### Document class options

```latex
% Anonymized
\documentclass{ccn}                      % for submission (default): anonymous, line numbers

% Deanonymized
\documentclass[proceedings]{ccn}         % for accepted proceedings papers only
\documentclass[extended-abstract]{ccn}   % for accepted extended abstracts only
\documentclass[preprint]{ccn}            % for dissemination on preprint servers before acceptance
```

### Instructions

First, click the green **Code** button above, then **Download ZIP**.

#### Option 1: Cloud development

Upload the zip to [Overleaf](https://www.overleaf.com/) via *New Project → Upload Project*.

#### Option 2: Local development

Unzip and build with a tool such as [`latexmk`](https://ctan.org/pkg/latexmk/) that has support for `biber`:

```bash
cd latex
latexmk -pdf ccn_proceedings.tex
```

## Typst

### Templates

- **`typst/ccn_proceedings.typ`** — Full proceedings paper (8 pages + references)
- **`typst/ccn_extended_abstract.typ`** — Extended abstract (2 pages + references)

### Mode options

```typst
// Anonymized
#show: ccn.with(mode: "submission", ...)               // for submission (default): anonymous

// Deanonymized
#show: ccn.with(mode: "proceedings", doi: "...", ...)  // for accepted proceedings papers only
#show: ccn.with(mode: "extended-abstract", ...)        // for accepted extended abstracts only
#show: ccn.with(mode: "preprint", ...)                 // for dissemination on preprint servers before acceptance
```

### Instructions

First, click the green **Code** button above, then **Download ZIP**.

#### Option 1: Cloud development

Upload the zip to the [Typst web app](https://typst.app/).

#### Option 2: Local development

Unzip and build with [`typst`](https://github.com/typst/typst):

```bash
cd typst
typst compile ccn_proceedings.typ
```
