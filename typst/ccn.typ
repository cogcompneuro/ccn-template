// CCN Conference Typst Template (v2026.3)
// =========================================
//
// Apply with a show rule:
//   #import "ccn.typ": ccn
//   #show: ccn.with(mode: "submission", title: [...], authors: (...))
//
// Modes (passed to `mode:`):
//   "submission"        Anonymized (default).
//   "preprint"          Deanonymized, no footer or page numbers.
//   "proceedings"       Deanonymized, branded footer + DOI (required).
//   "extended-abstract" Deanonymized, branded footer.

#let ccn-version = "v2026.3"

// Recursively extract plain text from content, so things like
// `title: [Bayesian *Inference* in $X$]` can populate PDF metadata
// without losing markup at the rendering site. Strings pass through.
#let _content-to-string(c) = {
  if c == none { "" }
  else if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(_content-to-string).join("") }
  else if c.has("body") { _content-to-string(c.body) }
  else { "" }
}

#let ccn-defaults = (
  year: 2026,
  edition: "9th",
  location: "New York, NY, USA",
)

// ----------------------------------------------------------------------------
// Palette.
// ----------------------------------------------------------------------------

#let ccn-blue = rgb("#b2c6de")
#let ccn-pink = rgb("#efc6bf")
#let ccn-green = rgb("#add8c0")

#let ccn-links = rgb("#a0b2c8")
#let ccn-footer-text = rgb("#828c9b")

// ----------------------------------------------------------------------------
// License registry.
// ----------------------------------------------------------------------------

#let ccn-licenses = (
  "CC BY 4.0": "https://creativecommons.org/licenses/by/4.0/",
  "CC BY-SA 4.0": "https://creativecommons.org/licenses/by-sa/4.0/",
  "CC BY-NC 4.0": "https://creativecommons.org/licenses/by-nc/4.0/",
  "CC BY-ND 4.0": "https://creativecommons.org/licenses/by-nd/4.0/",
  "CC BY-NC-SA 4.0": "https://creativecommons.org/licenses/by-nc-sa/4.0/",
  "CC BY-NC-ND 4.0": "https://creativecommons.org/licenses/by-nc-nd/4.0/",
)

// ----------------------------------------------------------------------------
// CCN logo (inline SVG; three-circle Venn with lens-shape intersections).
// ----------------------------------------------------------------------------

#let ccn-logo-svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='-0.3756 -0.3225 0.7512 0.7175'>
  <defs>
    <clipPath id='A'><circle cx='-0.1256' cy='-0.0725' r='0.25'/></clipPath>
    <clipPath id='B'><circle cx='0.1256' cy='-0.0725' r='0.25'/></clipPath>
  </defs>
  <circle cx='-0.1256' cy='-0.0725' r='0.25' fill='#b2c6de'/>
  <circle cx='0.1256' cy='-0.0725' r='0.25' fill='#efc6bf'/>
  <circle cx='0' cy='0.145' r='0.25' fill='#add8c0'/>
  <g clip-path='url(#A)'>
    <circle cx='0.1256' cy='-0.0725' r='0.25' fill='#f6e6ef'/>
    <circle cx='0' cy='0.145' r='0.25' fill='#ceeeef'/>
  </g>
  <g clip-path='url(#B)'>
    <circle cx='0' cy='0.145' r='0.25' fill='#f5eee0'/>
    <g clip-path='url(#A)'>
      <circle cx='0' cy='0.145' r='0.25' fill='#faf8f8'/>
    </g>
  </g>
</svg>"

// Default size matches ccn.cls's TikZ \ccnlogo: \radius=0.25cm + \sep=0.145cm
// → bounding box 0.7512cm wide × 0.7175cm tall. Using cm rather than em pins
// the glyph to LaTeX's physical size regardless of the surrounding font size.
#let ccn-logo(size: 0.7175cm) = box(image(bytes(ccn-logo-svg), format: "svg", height: size))

// ----------------------------------------------------------------------------
// Footer text + first-page branded footer assembly.
// ----------------------------------------------------------------------------

#let _doi-link(doi) = {
  if doi != none and doi != "" {
    [#link("https://doi.org/" + doi)[#text(fill: ccn-links, raw("doi:" + doi))] ]
  }
}

#let _copyright(year, license, license-url) = [
  Copyright #year by the author(s). Licensed under #link(license-url)[#license].
]

#let _footer-text(mode, year, edition, location, doi, license, license-url) = {
  if mode == "submission" {
    [In submission to the _#edition Conference on Cognitive Computational Neuroscience_ (CCN #year).]
  } else if mode == "proceedings" {
    [In _Proceedings of the #edition Conference on Cognitive Computational Neuroscience_, #location, #year. ] + _doi-link(doi) + _copyright(year, license, license-url)
  } else if mode == "extended-abstract" {
    [Extended abstract presented at the _#edition Conference on Cognitive Computational Neuroscience_, #location, #year. ] + _copyright(year, license, license-url)
  } else {
    []
  }
}

#let _first-page-footer(mode, year, edition, location, doi, license, license-url) = {
  let txt = _footer-text(mode, year, edition, location, doi, license, license-url)
  set text(size: 10pt, fill: ccn-footer-text)
  if mode == "proceedings" or mode == "extended-abstract" {
    grid(
      columns: (auto, 1fr),
      column-gutter: 0.8em,
      align: (horizon + left, horizon + left),
      ccn-logo(),
      txt,
    )
  } else {
    txt
  }
}

// ----------------------------------------------------------------------------
// Author block.
// ----------------------------------------------------------------------------
//
// authors: array of dicts (name, optional affil: tuple of ints into
//          affiliations, optional email)
// affiliations: array of strings, indexed from 1
// emails: optional string or array; if omitted, per-author emails are collected

#let _format-authors(authors, affiliations: (), emails: none) = {
  let has-affil = affiliations.len() > 0
  if emails == none {
    let collected = authors.map(a => a.at("email", default: none)).filter(e => e != none)
    if collected.len() > 0 {
      emails = collected.join(", ")
    }
  }
  let entries = authors.map(a => {
    let name = a.at("name")
    let supers = a.at("affil", default: ())
    if has-affil and supers != () and supers.len() > 0 {
      for i in supers {
        assert(
          type(i) == int and i >= 1 and i <= affiliations.len(),
          message: "ccn: affil index " + repr(i) + " for author '" + name
            + "' is out of range 1.." + str(affiliations.len()),
        )
      }
      let s = supers.map(i => str(i)).join(",")
      [#name#super[#s]]
    } else {
      [#name]
    }
  })
  let joined = if entries.len() == 0 {
    []
  } else if entries.len() == 1 {
    entries.at(0)
  } else if entries.len() == 2 {
    entries.at(0) + [ and ] + entries.at(1)
  } else {
    entries.slice(0, -1).map(e => e + [, ]).join() + [and ] + entries.last()
  }
  align(center)[
    #set par(leading: 0.5em)
    #text(weight: "bold")[#joined]
    #if has-affil [
      \
      #v(0.5em, weak: true)
      #set text(size: 9pt)
      #for (i, aff) in affiliations.enumerate() [
        #if affiliations.len() > 1 [#super[#str(i + 1)]#h(0.16em)]#aff#if i < affiliations.len() - 1 [\ ]
      ]
    ]
    #if emails != none [
      \
      #v(0.25em, weak: true)
      #set text(size: 9pt)
      #if type(emails) == array { emails.join(", ") } else { emails }
    ]
  ]
}

// ----------------------------------------------------------------------------
// Main template.
// ----------------------------------------------------------------------------

#let ccn(
  mode: "submission",
  title: [Untitled],
  authors: (),
  affiliations: (),
  emails: none,
  abstract: none,
  doi: none,
  license: "CC BY 4.0",
  year: ccn-defaults.year,
  edition: ccn-defaults.edition,
  location: ccn-defaults.location,
  body,
) = {
  let valid-modes = ("submission", "preprint", "proceedings", "extended-abstract")
  assert(
    valid-modes.contains(mode),
    message: "ccn: unknown mode '" + mode + "'. Valid: " + valid-modes.join(", "),
  )
  if mode == "proceedings" {
    assert(
      doi != none and doi != "",
      message: "ccn: DOI required for proceedings mode. Pass doi: \"...\".",
    )
  }
  assert(
    license in ccn-licenses,
    message: "ccn: unknown license '" + license + "'. Valid: " + ccn-licenses.keys().join(", "),
  )
  let license-url = ccn-licenses.at(license)

  set document(
    title: _content-to-string(title),
    author: if mode == "submission" { "Anonymous" } else { authors.map(a => a.at("name")).join(", ") },
  )

  // Page layout — matches the LaTeX `geometry` settings from v2026.1:
  //   letter, textwidth 7", textheight 8.75" (page 1), 0.75" left, 1" top.
  // The page-1 branded footer renders in the page footer slot (inside the
  // bottom margin) rather than as a body float — that keeps it out of the
  // way of figure floats with `placement: bottom`.
  set page(
    paper: "us-letter",
    margin: (left: 0.75in, right: 0.75in, top: 1in, bottom: 0.75in),
    // Approximate ccn.cls `\footskip 30pt` (baseline-to-baseline from last
    // body line to footer); Typst's footer-descent is body-bottom-to-footer-top.
    footer-descent: 21pt,
    columns: 2,
    numbering: if mode == "preprint" { none } else { "1" },
    number-align: center,
    footer: context {
      if mode == "preprint" { return [] }
      let n = counter(page).get().first()
      if n == 1 {
        // Pad to a uniform 22pt height (2 lines + a touch) and align the
        // payload to the *bottom* so submission (1-line) and cam-ready
        // (2-line + logo) footers share the same bottom y — matching how
        // ccn.cls pins `\footskip` to the bottom margin regardless of how
        // many lines the footer wraps to.
        v(-41pt)
        block(
          height: 22pt,
          align(
            bottom + left,
            _first-page-footer(mode, year, edition, location, doi, license, license-url),
          ),
        )
      } else {
        align(center, text(size: 9pt)[#n])
      }
    },
  )
  set columns(gutter: 0.25in)

  // Body: 10pt sans-serif, 12pt baseline. Falls back through TeX Gyre Heros
  // / Helvetica / Arial — matches ccn.cls's tgheros (Helvetica-compatible).
  // DejaVu / Noto Sans are listed last to keep headless Linux out of Typst's
  // built-in serif fallback (Linux Libertine) when nothing else matches.
  set text(
    font: (
      "TeX Gyre Heros",
      "Helvetica",
      "Arial",
      "Liberation Sans",
      "DejaVu Sans",
      "Noto Sans",
    ),
    size: 10pt,
    top-edge: "cap-height",
    bottom-edge: "descender",
    lang: "en",
    costs: (hyphenation: 30%),
  )
  set par(
    justify: true,
    justification-limits: (
      // Character-level justification
      tracking: (min: -0.015em, max: 0.02em),
    ),
    // Targets LaTeX's 12pt baselineskip. With top-edge: "cap-height" and
    // bottom-edge: "descender", each line's frame is ~0.925em tall (TeX Gyre
    // Heros: cap-height 0.718 + descender 0.207), so leading 2.75pt yields
    // 10pt × 0.925 + 2.75pt = 12pt baseline-to-baseline.
    leading: 2.75pt,
    spacing: 2.75pt,
    first-line-indent: (amount: 0.125in, all: false),
  )
  set par.line(
    numbering: n => text(size: 6pt)[#n],
    number-clearance: 6pt,
  )

  // Heading spacings — match v2026.1 LaTeX (`\@startsection` uses 9pt
  // above-skip on §/§§/§§§). The body-text spec says "one line space
  // above" (12pt), but LaTeX deviates to 9pt. This tries to match that
  // behavior.
  let sec-above = 9pt
  let sec-below = 3pt

  // Heading show rules must return an explicit `block(...)` (not bare
  // content with `set block(...)` in scope). When the rule returns inline
  // content like `align(center, it.body)`, Typst's column flow doesn't
  // register the heading as a layout change, and `par.first-line-indent`
  // with `all: false` flips: every paragraph gets indented instead of being
  // skipped after the heading.
  show heading.where(level: 1): it => {
    block(above: sec-above, below: sec-below, width: 100%)[
      #set text(size: 12pt, weight: "bold")
      #align(center, it.body)
    ]
  }
  show heading.where(level: 2): it => {
    block(above: sec-above, below: sec-below, width: 100%)[
      #set text(size: 11pt, weight: "bold")
      #it.body
    ]
  }
  show heading.where(level: 3): it => {
    v(sec-above, weak: true)
    h(-0.125in)
    text(size: 10pt, weight: "bold", it.body)
    h(0.5em)
  }
  set heading(numbering: none)

  // Math: render Roman letters and digits in the body sans-serif, matching
  // the LaTeX template's `\RequirePackage[helvet]{sfmath}`. Math operators
  // and Greek glyphs fall through to Typst's bundled serif `New Computer
  // Modern Math`, mirroring sfmath's mix of Helvetica letters + CM symbols.
  show math.equation: set text(font: (
    "TeX Gyre Heros",
    "Helvetica",
    "Arial",
    "Liberation Sans",
    "DejaVu Sans",
    "Noto Sans",
    "New Computer Modern Math",
  ))
  set math.equation(numbering: "(1)")

  // Figures
  set figure(numbering: "1")
  show figure: set block(above: 12pt, below: 12pt)
  show figure.caption: it => {
    set par(first-line-indent: 0pt, justify: true)
    set text(size: 10pt)
    [#it.supplement #context it.counter.display(it.numbering): #it.body]
  }

  // Tables
  show figure.where(kind: table): set figure.caption(position: top)
  set table(
    stroke: none,
    inset: (top: 0.2em, bottom: 0.2em),
    gutter: 0pt,
  )
  show table.cell.where(y: 0): strong

  // Footnotes — match ccn.cls:
  //   \footnotesep 6.65pt           → gap between footnotes
  //   \skip\footins 9pt             → space from body to rule
  //   \footnoterule width 5pc       → 60pt-wide horizontal rule
  //   9pt text per spec
  set footnote.entry(
    separator: line(length: 60pt, stroke: 0.5pt),
    clearance: 9pt,
    gap: 6.65pt,
    indent: 0pt,
  )
  show footnote.entry: set text(size: 9pt)


  // Links + citations.
  show link: it => {
    if type(it.dest) == str and (it.dest.starts-with("http") or it.dest.starts-with("doi")) {
      text(fill: ccn-links, it)
    } else {
      it
    }
  }

  // Title block — spans both columns.
  //   Title: 14pt bold.
  //   Author→body gap: 24pt (two line spaces).
  place(
    top + center,
    scope: "parent",
    float: true,
    clearance: 24pt,
    block(width: 100%, breakable: false)[
      #align(center)[
        #set par(leading: 16pt - 14pt)
        #text(size: 14pt, weight: "bold")[#title]
      ]
      #v(7.5pt)
      #if mode == "submission" {
        align(center, text(weight: "bold")[Anonymous Author(s)])
      } else {
        _format-authors(authors, affiliations: affiliations, emails: emails)
      }
    ],
  )

  // Abstract: 9pt body, indented 1em either side ("\small + quote" in ccn.cls).
  if abstract != none {
    block(width: 100%, above: 0pt, below: 6pt, breakable: true)[
      #align(center)[#text(size: 10pt, weight: "bold")[Abstract]]
      #v(sec-below)
      #pad(left: 1em, right: 1em)[
        #set text(size: 9pt)
        #set par(first-line-indent: 0pt, justify: true, leading: 2.675pt, spacing: 2.675pt)
        #abstract
      ]
    ]
  }

  // Bibliography — APA style with 1/8" hanging indent per spec.
  set bibliography(title: "References", style: "apa")
  show bibliography: set par(hanging-indent: 0.125in, first-line-indent: 0pt)

  // Mirror ccn.cls's page-1 quirk (textheight 8.75" on page 1, 9.25" on
  // page 2+) by reserving 0.5" of body capacity at the bottom of page 1 —
  // matching `\AtBeginShipoutNext{\textheight=9.25in, footskip=30pt}` in
  // ccn.cls so Typst and LaTeX authors get the same effective page-1 budget.
  if mode != "preprint" {
    place(
      bottom + left,
      scope: "parent",
      float: true,
      clearance: 0pt,
      block(width: 100%, height: 0.5in),
    )
  }

  body
}
