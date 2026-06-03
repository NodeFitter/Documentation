#import "./common.typ": authors, course, linkColor, mainColor, projectName, university

#let firstPage(title, docType) = {
  show link: set text(fill: linkColor)
  set document(
    title: [#title - #course - #university],
    author: (
      authors.lorenzo.name + " " + authors.lorenzo.surname + " - Student Id " + authors.lorenzo.stid,
      authors.matteo.name + " " + authors.matteo.surname + " - Student Id " + authors.matteo.stid,
    ),
    description: [Project documentation for the #course course at #university],
  )
  set page(
    margin: 0em,
  )

  grid(
    columns: (35%, 65%),
    [#rect(fill: mainColor, width: 100%, height: 105%)],
    [
      #align(center + horizon)[#text(size: 3em, weight: "bold")[#title]]

      #align(center + horizon)[#image("../img/mdi--cloud-key.svg", width: 30%) #text(
          size: 2em,
          weight: "bold",
        )[#projectName]]

      #align(center + horizon)[#text(size: 1.5em, weight: "bold")[#docType]]

      #v(10em)

      #align(left)[
        #table(
          stroke: none,
          table.vline(x: 1, start: 0, stroke: mainColor),
          columns: (45%, auto),
          align: (x, y) => {
            if (x == 0) {
              right
            } else {
              left
            }
          },
          [*Group members*], [#authors.lorenzo.name #authors.lorenzo.surname (#authors.lorenzo.stid)],
          [], [#authors.matteo.name #authors.matteo.surname (#authors.matteo.stid)],
        )
      ]

      #align(center + bottom)[

        *University of Trento* - *A.Y. 2025/2026*

        #v(1em)
      ]

    ],
  )
}

#let indexPage(imageList: true, tableList: true) = {
  set page(
    margin: auto,
    footer: [
      #align(center)[#context [#counter(page).display("1 of 1", both: true)]] \
      #place(dx: -71pt, dy: -2pt)[#rect(height: 50%, width: 135%, stroke: none, fill: mainColor)]
    ],
  )

  show outline.entry.where(level: 1): it => {
    v(12pt, weak: true)
    text(size: 1.2em)[*#it*]
  }

  outline(depth: 4, title: text(size: 2em)[#v(0em) Index #v(0.5em)], indent: 1em)

  if (imageList == true) {
    text(size: 2em)[#v(0.5em) *Images* #v(-0.5em)]

    show outline: set text(weight: "thin")
    outline(
      title: [],
      target: figure.where(kind: image),
    )
  }

  if (tableList == true) {
    text(size: 2em)[#v(0.5em) *Tables* #v(-0.5em)]

    show outline: set text(weight: "thin")
    outline(
      title: [],
      target: figure.where(kind: table),
    )
  }
}

#let docBody(body, title, docType) = {
  show figure: set block(breakable: true)
  show link: it => underline(text(fill: linkColor)[#it])
  show ref: rf => underline(text(fill: mainColor)[#rf])

  set heading(numbering: "1.")

  show heading.where(level: 1): h => {
    set text(size: 1.5em)
    pagebreak()
    h
    v(0.25em)
  }

  set page(
    margin: auto,
    header: [

      #grid(
        columns: (33%, 33%, 33%),
        align: (x, y) => {
          if x == 0 {
            left + horizon
          } else if x == 1 {
            center + horizon
          } else {
            right + horizon
          }
        },
        [#title], [#course], [#docType],
      )

      #line(length: 100%, stroke: mainColor)


    ],
    footer: [
      #align(center)[#context [#counter(page).display("1 of 1", both: true)]] \
      #place(dx: -71pt, dy: -2pt)[#rect(height: 50%, width: 135%, stroke: none, fill: mainColor)]
    ],
  )

  body
}
