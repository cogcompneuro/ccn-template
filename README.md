# CCN Template

Official templates for submission to the [Conference on Cognitive Computational Neuroscience (CCN)](https://ccneuro.org).
See the [CCN documentation](https://cogcompneuro.github.io/docs/) for detailed submission instructions.

Templates are provided in two formats, **LaTeX** and **Microsoft Word**, that render the same layout.
To access the files, click the green **Code** button above, then **Download ZIP**, and unzip.

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

## Word

### Templates

- **`word/ccn_extended_abstract_anonymous.dotx`** — for **double-blind submission**: anonymized author block, "In submission to…" footer.
- **`word/ccn_extended_abstract_camera_ready.dotx`** — for an **accepted** extended abstract: author block and the official footer with the CCN logo.

CCN does not allow a Word template for the Proceedings track due to the difficulty in ensuring visual coherence among the published Proceedings with Word.

### Instructions

With Microsoft Word installed, double-click the template `.dotx` file for your stage; Word creates a new document from it. If submitting the deanonymized version, replace the placeholder title, author block (camera-ready only), abstract, and body text with your own, keeping the section structure and formatting.

> **Note on line numbers.** Line numbers are a *nice-to-have* (not required) for CCN double-blind review. Microsoft Word's line-numbering feature does **not** render correctly for this template's multi-column, multi-section layout (it numbers only the first column and miscounts across section breaks), so the Word template ships without them. If you'd like line numbers, the **LaTeX** and **Typst** templates in submission mode include them and number correctly.

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
