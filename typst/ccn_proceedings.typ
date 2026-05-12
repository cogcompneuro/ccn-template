// -----------------------------------------------------------------------
// CCN Conference - Proceedings Track Template (Typst)
// For papers up to 8 pages (excluding references plus supplement).
// -----------------------------------------------------------------------

#import "ccn.typ": ccn

// Modes:
//   "submission"  (default) anonymized for review
//   "preprint"    deanonymized, no footer or page numbers
//   "proceedings" camera-ready (after acceptance) — requires `doi:`
#show: ccn.with(
  mode: "submission",
  // mode: "proceedings", doi: "10.1234/ccn.2026.001",

  title: [Formatting Instructions for CCN 2026 Proceedings],

  // Authors are automatically anonymized in submission mode.
  authors: (
    (name: "Author One",   affil: (1,)),
    (name: "Author Two",   affil: (1,)),
    (name: "Author Three", affil: (2,)),
    (name: "Author Four",  affil: (2, 3)),
    (name: "Author Five",  affil: (3,)),
    (name: "Author Six",   affil: (4,)),
    (name: "Author Seven", affil: (4,)),
    (name: "Author Eight", affil: (1, 4)),
  ),
  affiliations: (
    "Department of Neuroscience, First University",
    "Institute for Brain Research, Second University",
    "Center for Neural Computation, Third University",
    "Department of Psychology, Fourth University",
  ),
  emails: "author1@first.edu, author3@second.edu, corresponding@fourth.edu",

  abstract: [
    The abstract should be identical to the text version submitted in the web form
    and should not exceed 300 words. CCN has an interdisciplinary audience. Hence
    a good abstract should (a) give context about what the problem is and why it
    matters (b) give the contents and explain what was done and what was found
    (c) give a clear conclusion including what we learned and how it changes the
    way we think about the universe. And because Konrad is writing this, he can
    not avoid shamelessly plugging his writing guide:
    #link("https://doi.org/10.1371/journal.pcbi.1005619")[doi.org/10.1371/journal.pcbi.1005619].
    See you at CCN.
  ],
)


= General Formatting Instructions

The text, tables and figures of a CCN proceedings submission can be no longer than
8 pages. This is including figures, tables, but excluding references and the
supplement.

The text of the paper should be formatted in two columns with an overall width of
7 inches (17.8 cm) and length of 9.25 inches (23.5 cm), with 0.25 inches between
the columns. Leave two line spaces between the last author listed and the text of
the paper. The left margin should be 0.75 inches and the top margin should be
1 inch. Use 10~point Helvetica or compatible with 12~point vertical spacing,
unless otherwise specified.

The title should be in 14~point, bold, and centered. The title should be formatted
with initial caps (the first letter of content words capitalized and the rest
lower case).

Indent the first line of each paragraph by 1/8~inch (except for the first paragraph
of a new section). Do not add extra vertical space between paragraphs.


= Structure

We recommend a clear structure, typically including an introduction, followed by
sections such as methods and results for experimental work (which may be
substituted e.g. for theoretical work), and concluded with a discussion.


= First Level Headings

First level headings should be in 12~point, initial caps, bold and centered.
Leave one line space above the heading and 1/4~line space below the heading.


== Second Level Headings

Second level headings should be 11~point, initial caps, bold, and flush left.
Leave one line space above the heading and 1/4~line space below the heading.


=== Third Level Headings
Third level headings should be 10~point, initial caps, bold, and flush left.
Leave one line space above the heading, but no space after the heading.


= Formalities, Footnotes, and Floats

Use standard APA citation format. Citations within the text should include the
author's last name and year. If the authors' names are included in the sentence,
place only the year in parentheses, as in #cite(<NewellSimon1972a>, form: "prose"),
but otherwise place the entire reference in parentheses with the authors and year
separated by a comma @NewellSimon1972a. List multiple references alphabetically
and separate them by semicolons @ChalnickBillman1988a @NewellSimon1972a. Use the
"et~al." construction for any citation with three or more authors, from the first
mention onward.


== Footnotes

Indicate footnotes with a number#footnote[Sample of the first footnote.] in the
text. Place the footnotes in 9~point type at the bottom of the column on which
they appear. Precede the footnote block with a horizontal rule.#footnote[Sample of
the second footnote.]


== Tables

Number tables consecutively. Place the table number and title (in 10~point) above
the table with one line space above the caption and one line space below it, as
in @sample-table. You may float tables to the top or bottom of a column, or set
wide tables across both columns.

#let sample-table = [ 
  #figure(
    table(
      columns: 2,
      align: left,
      stroke: none,
      table.hline(),
      [*Error type*], [*Example*],
      table.hline(),
      [Take smaller], [63 - 44 = 21],
      [Always borrow], [96 - 42 = 34],
      [0 - N = N], [70 - 47 = 37],
      [0 - N = 0], [70 - 47 = 30],
      table.hline(),
    ),
    caption: [Sample table title.],
    scope: "parent",
    placement: auto,
  )<sample-table> 
]



== Figures

Make sure that the artwork can be printed well (e.g. dark colors) and that the
figures make understanding the paper easy. Number figures sequentially, placing
the figure number and caption, in 10~point, after the figure with one line space
above the caption and one line space below it, as in @sample-figure. If
necessary, leave extra white space at the bottom of the page to avoid splitting
the figure and figure caption. You may float figures to the top or bottom of a
column, or set wide figures across both columns.

#figure(
  rect(width: 4cm, height: 4cm, stroke: 0.5pt),
  caption: [This is a figure spanning a single column.],
  placement: auto,
) <sample-figure>

#figure(
  rect(width: 12cm, height: 4cm, stroke: 0.5pt),
  caption: [This is a figure spanning both columns.],
  placement: bottom,
  scope: "parent",
) <sample-figure-wide>

// Note: sample-table is defined above, but instantiating it here forces
// it to appear on the second page.
#sample-table

== Math

Display equations should be set out from the text and numbered for easy reference:
$ P(H | D) = (P(D | H) P(H)) / P(D) . $


= Supplementary Materials

An *Acknowledgments* section may appear before the references (and may extend to
a 9th page) to include author contributions. Use of automated tools (such as
generative AI) must be disclosed in this section, describing the tools used and
their role (e.g., drafting, editing, code generation). A technical *Appendix* may
start on a new page after the references.


= Double-blind Review

CCN's reviewing process is double-blind, and it is the authors' responsibility to
anonymize their submissions. Do not include any identifying information, such as
author names, affiliations, or acknowledgments, in the abstract, main text,
figures, or metadata. When citing your own work, ensure anonymity to maintain
double-blind review standards (e.g., write "In previous work by Author et al.
(2024), ..." instead of "In our previous work (Author et al., 2024), ..."). If
citing a non-anonymous preprint (e.g., from arXiv, social media, or other
websites), use anonymized phrasing (e.g., "Author et al. (2024) concurrently
demonstrate ..."). Reviewers are instructed not to actively seek out such
preprints, but their discovery does not constitute a conflict of interest.
Alternatively, authors may choose not to cite their own non-anonymous preprints,
such as those on arXiv. However, prior publications on related topics must be
appropriately anonymized when cited. We encourage including links to code and
artifacts in the spirit of open science, but please ensure that the linked
material is anonymized; e.g. create a dedicated account to host your material
rather than the account of one of the authors. Reviewers are not required to
review linked material.


= Referencing Prior Work

Follow the APA Publication Manual for citation format, both within the text and
in the reference list, with the following exceptions: (a) do not cite the page
numbers of any book, including chapters in edited volumes; (b) use the same
format for unpublished references as for published ones. Alphabetize references
by the surnames of the authors, with single author entries preceding multiple
author entries. Order references by the same authors by the year of publication,
with the earliest first.

Use a first level section heading, *References*, as shown below. Use a hanging
indent style, with the first line of the reference flush against the left margin
and subsequent lines indented by 1/8~inch. Below are example references for a
conference paper, book chapter, journal article, dissertation, book, technical
report, and edited volume, respectively.

#cite(<ChalnickBillman1988a>, form: none)
#cite(<Feigenbaum1963a>, form: none)
#cite(<Hill1983a>, form: none)
#cite(<OhlssonLangley1985a>, form: none)
#cite(<Matlock2001>, form: none)
#cite(<NewellSimon1972a>, form: none)
#cite(<ShragerLangley1990a>, form: none)

#bibliography("ccn_references.bib")
