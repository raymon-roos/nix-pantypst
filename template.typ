// Typst article layout template
// by John Maxwell, jmax@sfu.ca, VERSION as of March 2025
// Modified by Raymon Roos, as of December 2025
//
// This template is for Typst with Pandoc
// The assumption is markdown source, with a
// YAML metadata block (title, author, date...)
// Usage:
//    pandoc article.md \
//      -f markdown --wrap=none \
//      -t pdf --pdf-engine=typst \
//      -V template=article.typ \
//      -o article.pdf


// This bit from Pandoc, to help parse incoming metadata
#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let conf(
  title: none, // These first few come through from markdown metadata
  subtitle: none,
  authors: (),
  keywords: (),
  date: none,
  abstract: none,
  lang: "en",
  region: "US",
  paper: "a4",
  margin: (top: 1in, bottom: 1.15in, inside: 1.0in, outside: 1.1in),
  cols: 1,
  font: none,
  fontsize: 12pt,
  sectionnumbering: none,
  pagenumbering: "1",
  doc,
) = {
  set document(
    title: title,
    author: authors.map(author => content-to-string(author.name)),
    keywords: keywords,
  )
  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
    columns: cols,
    footer: context {
      align(right, counter(page).display("1"))
    },
  )


  // Text defaults
  set text(
    lang: lang,
    region: region,
    font: font, // see 'conf' above
    size: fontsize,
    spacing: 90%, // tighter than normal is nice
    alternates: false,
    discretionary-ligatures: false,
    historical-ligatures: false,
    number-width: "proportional",
  )
  set strong(delta: 200) // use semibold instead of bold


  // Block quotations
  set quote(block: true)
  show quote: set block(spacing: 18pt)
  show quote: set pad(x: 1.5em)
  show quote: set par(leading: 8pt)
  show quote: set text(style: "normal")

  // Lists
  set list(indent: 1em)
  set enum(indent: 1em)

  // Code blocks: coloured monospace
  show raw: set block(inset: (left: 2em, top: 1em, right: 1em, bottom: 1em))
  show raw: set text(fill: rgb(purple), size: 9pt)

  // Images and figures:
  set image(fit: "contain")
  show image: it => {
    align(center, it)
  }
  set figure(gap: 1em, supplement: none, placement: none)
  show figure.caption: set text(size: 10pt) // how to set space below?
  show figure: set block(below: 2.0em)

  // HEADINGS
  show heading: set text(hyphenate: false)
  set heading(numbering: sectionnumbering)

  show heading.where(level: 1): it => align(left, block(
    above: 22pt,
    below: 12pt,
    width: 100%,
  )[
    #v(12pt) // space above
    #set par(leading: 16pt)
    #set text(
      font: font,
      weight: "regular",
      style: "normal",
      size: fontsize + 4pt,
    )
    #block(it.body)
    #v(6pt) // space below

  ])

  show heading.where(level: 2): it => align(left, block(
    above: 16pt,
    below: 12pt,
    width: 80%,
  )[
    #set text(weight: "regular", style: "normal", size: fontsize + 2pt)
    #block(it.body)
  ])

  show heading.where(level: 3): it => align(left, block(
    above: 14pt,
    below: 8pt,
  )[
    #set text(weight: "regular", size: fontsize + 1pt, tracking: 0.02em)
    #block([#smallcaps(all: true)[#it.body]])
  ])


  // STYLING LABELLED SECTIONS
  show <epigraph>: set text(rgb("#777"))
  show <epigraph>: set par(justify: false)

  show <refs>: set par(
    justify: false,
    spacing: 16pt,
    first-line-indent: 0em,
    hanging-indent: 2em,
    leading: 8pt,
  )


  // STYLING SPECIFIC STRINGS OF TEXT
  show "LaTeX": smallcaps
  show regex("https?://\S+"): set text(style: "normal", rgb("#33d"))


  // THIS IS THE TITLE BLOCK
  if title != none or authors.len() > 0 or date != none or abstract != none {
    v(1em)
    set par(justify: false)
    align(left, text(size: 18pt)[
      #title#if subtitle != none [: #emph[#subtitle] ]
    ])
    if authors.len() > 0 {
      v(0.5em)
      align(left, text(size: 12pt)[#authors.first().name])
    }
    if date != none {
      v(0.5em)
      align(left, text(size: 12pt)[#date])
    }
    if abstract != none {
      v(0.5em)
      align(
        left,
        text(size: 11pt, tracking: 0.05em)[ABSTRACT: ]
          + text(size: 11pt, style: "italic")[#abstract],
      )
    }
    v(1em)
    line(start: (1%, 0%), end: (99%, 0%), stroke: 1pt + gray)
    v(4em)
  }

  // This is the actual body:

  set par(justify: true) //default for the rest of the doc

  doc // HERE is the actual body content
} // end 'let conf'

