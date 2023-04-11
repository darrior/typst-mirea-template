// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let indent_first = 12.5mm

#let equation_counter = counter("equation")
#let image_counter = counter("image")
#let table_counter = counter("table")
#let code_counter = counter("code")

#let crutch = {
  linebreak()
  v(-1.5em)
}

#let eqn(content) = {
  figure(
    kind: "eqn",
    supplement: "Формула",
    content
  )
}

#let numberless(content) = {
  set heading(numbering: none)
  pagebreak(weak: true)
  set align(center)
  [= #content]
}

#let application = {
  
} 

#let project(title: "", authors: (), body) = {
  // Set the document's basic properties.
  set document(author: authors, title: title)
  set page(
    margin: (left: 30mm, right: 10mm, top: 20mm, bottom: 20mm),
    numbering: "1",
    number-align: center,
  )

  show outline: it => {
    set par(first-line-indent: 0pt)
    set page(numbering: none)
    set outline(
      title: align(center)[#upper[Содержание]],
    )
    it
  }
  
  set text(font: "Times New Roman", lang: "ru", size: 14pt)
  set heading(numbering: "1.1")
  
  // Set run-in subheadings, starting at level 3.
  set par(
      justify: true, 
      first-line-indent: indent_first,
      leading: 1em
  )
  
  show heading: it => {
    show par: p => {
      set par(first-line-indent: 0pt)
      block(spacing: 2em, p)
    }
    if it.level == 1 {  
      set text(18pt)
      if it.numbering != none {
      pagebreak(weak: true)
      image_counter.step()
      table_counter.step()
      equation_counter.step()
      code_counter.step()
      h(indent_first)
      counter(heading).display()
      h(5pt)
      upper(it.body)
      } else {
        upper(it.body)
        parbreak()
    }
    } else if it.level >= 2 {
      parbreak()
      if it.level == 2 { 
        set text(16pt)
      } else {
        set text(14pt)
      }
      h(indent_first)
      counter(heading).display()
      h(5pt)
      it.body
      parbreak()
    }
  }

  show par: it => {
    set block( spacing: 1em)
    it
  }
  
  show list: it => {
    set block(spacing: 1em)
    set par(hanging-indent: 0mm)
    it
    crutch
  }

  set list(
    indent: 1.25cm,
    body-indent: 1cm,
    tight: true,
    spacing: 1em,
    marker: [---]
    )
  
  show enum: it => {
    set block(spacing: 1em)
    set par(hanging-indent: 0mm)
    it
    crutch
  }

  set enum(
    indent: 1.25cm,
    body-indent: 1cm,
  )
  
  show table: it => {
    set table(
      align: center,
    )
    set text(12pt)
    it
    crutch
  }
  set figure(numbering: "1.1")
  
  show figure.where(kind: image): it => {
    image_counter.step(level: 2)
    set align(center)
    it.body
    set text(12pt, weight: "bold")
    set par(leading: 2pt)
    it.supplement
    " "
    image_counter.display()
    if it.has("caption") {
      [ --- ]
      it.caption
    }
  }

  show figure.where(kind: table): it => {
    table_counter.step(level: 2)
    {  
      set text(12pt, style: "italic")
      set par(
        first-line-indent: 0pt,
        leading: 2pt
      )
      it.supplement
      " "
      table_counter.display()
      if it.has("caption") {
        [ --- ]
        it.caption
      }
      v(-0.5em)
    }
    set align(center)
    it.body
  }

  show figure.where(kind: raw): it => {
    code_counter.step(level: 2)
    {
      set text(12pt, style: "italic")
      set par(
        leading: 2pt,
        first-line-indent: 0pt,
      )
      "Листинг "
      code_counter.display()
      if it.has("caption") {
        [ --- ]
        it.caption
      }
      v(-0.5em)
    }
    it.body
  }

  show figure.where(kind: "eqn"): it => {
    equation_counter.step(level: 2)
    set math.equation(
      block: true,
      numbering: (..args) => {
        "(" + equation_counter.display() + ")"
      }
    )
    it.body
    crutch
  }
  
  show raw: it => {
    set text(12pt, font: "Courier New")
    set block(
      stroke: black,
      inset: 0.5em,
      width: 100%)  
    it
  }

  show ref: it => {
    locate(loc => {
      let find_figure = query(it.target, loc).first()
      let num
      if find_figure.func() == figure { 
        if find_figure.kind == table {
          find_figure.supplement + " "
          num = table_counter.at(find_figure.location())     
        } else if find_figure.kind == image {
          find_figure.supplement + " "
          num = image_counter.at(find_figure.location())   
        } else if find_figure.kind == raw {
          num = code_counter.at(find_figure.location())
          find_figure.supplement + " "
        } else if find_figure.kind == "eqn" {
          num = equation_counter.at(find_figure.location())
        }
        if num.len() < 2 {
          num.push(0)
        }
        str(num.first()) + "." + str(num.last() + 1)
      } else  {
        it
      }
    })
  }

  body
}
