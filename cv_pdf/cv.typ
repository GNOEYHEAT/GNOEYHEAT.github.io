// CV PDF template. Built by bin/build_cv_pdf.py from _data/cv.yml and
// _bibliography/papers.bib; edit those files to change the content.
// sys.inputs: lang ("en" | "ko"), papers (JSON list prepared from papers.bib)

#let lang = sys.inputs.at("lang", default: "en")
#let cv = yaml("/_data/cv.yml")
#let t = yaml("/_data/i18n.yml").at(lang)
#let papers = json(bytes(sys.inputs.at("papers", default: "[]")))

// ---------------------------------------------------------------- helpers
#let loc(v) = if type(v) == dictionary { v.at(lang, default: v.at("en", default: "")) } else if v == none { "" } else { str(v) }

#let months = ("Jan.", "Feb.", "Mar.", "Apr.", "May", "Jun.", "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec.")
#let ym(s) = {
  let parts = str(s).split("-")
  if parts.len() < 2 { str(s) } else if lang == "ko" { parts.at(0) + "." + parts.at(1) } else {
    months.at(int(parts.at(1)) - 1) + " " + parts.at(0)
  }
}
#let period(start, end) = {
  let from = ym(start)
  if end == none or end == "" { from } else if end == "present" { from + " – " + t.present } else if end == "open" {
    from + " –"
  } else { from + " – " + ym(end) }
}

#let selves = cv.self_names
#let author-list(names) = names.map(n => if n in selves { strong(n) } else { n }).join(", ")
#let paper-authors(list) = list.map(a => if a.name in selves { strong(a.name + a.mark) } else { a.name + a.mark }).join(", ")

// ---------------------------------------------------------------- page style
#let accent = rgb("#1f3a5f")
#set document(title: loc(cv.name) + " — CV", author: loc(cv.name))
#set page(paper: "a4", margin: (x: 1.8cm, top: 1.7cm, bottom: 1.6cm), footer: context [
  #set text(8pt, fill: luma(120))
  #loc(cv.name) — CV #h(1fr) #counter(page).display("1 / 1", both: true)
])
#set text(
  font: ("Libertinus Serif", "Noto Serif CJK KR"),
  size: 10pt,
  lang: lang,
)
#set par(justify: false, leading: 0.55em)

#let section(title) = {
  v(0.9em)
  block(below: 0.55em, sticky: true)[
    #text(12pt, weight: "bold", fill: accent, title)
    #v(-0.65em)
    #line(length: 100%, stroke: 0.6pt + accent)
  ]
}

// Dated row: left = main text, right = date
#let row(body, when) = block(below: 0.5em, grid(
  columns: (1fr, auto),
  column-gutter: 1em,
  body, align(right, text(fill: luma(70), when)),
))
#let sub(s) = text(fill: luma(80), s)

// ---------------------------------------------------------------- header
#align(center)[
  #text(22pt, weight: "bold", loc(cv.name)) #h(0.4em) #text(13pt, fill: luma(90), loc(cv.name_alt))
  #v(-0.4em)
  #text(10pt, loc(cv.headline))
  #v(-0.2em)
  #text(9pt)[
    #link("mailto:" + cv.contact.email)[#cv.contact.email] ·
    #link("https://" + cv.contact.website)[#cv.contact.website] ·
    #link("https://github.com/" + cv.contact.github)[github.com/#cv.contact.github] ·
    #link("https://www.linkedin.com/in/" + cv.contact.linkedin + "/")[linkedin.com/in/#cv.contact.linkedin] ·
    #link("https://scholar.google.com/citations?user=" + cv.contact.scholar)[Google Scholar]
  ]
]

// ---------------------------------------------------------------- sections
#section(t.education)
#for e in cv.education {
  row([*#loc(e.degree)* \ #sub(loc(e.school) + (if lang == "ko" { " " } else { ", " }) + loc(e.department))], period(
    e.start,
    e.at("end", default: none),
  ))
  for d in e.at("details", default: ()) {
    block(above: -0.2em, below: 0.35em, pad(left: 1em, list(loc(d))))
  }
  v(0.3em)
}

#section(t.experience)
#for e in cv.experience {
  row([*#loc(e.position)* \ #sub(loc(e.organization))], period(
    e.start,
    e.at("end", default: none),
  ))
}

#section(t.research_interests)
#cv.research_interests.map(loc).join(" · ")

#section(t.publications)
#let numbered(items) = enum(numbering: "[1]", tight: false, spacing: 0.6em, ..items)
#text(10.5pt, weight: "bold", t.under_review)
#numbered(papers.filter(p => p.status == "review").map(p => [#paper-authors(p.authors), "#p.title," #emph(
    p.note,
  ), #p.year.]))
#text(10.5pt, weight: "bold", t.journal_and_proceedings)
#numbered(papers.filter(p => p.status != "review").map(p => [#paper-authors(p.authors), "#p.title," #emph(
    p.venue,
  ), #p.year.#if p.note != "" [ (#p.note)]]))
#text(8.5pt, fill: luma(90), t.equal_contribution)

#section(t.domestic_presentations)
#numbered(cv.domestic_presentations.map(p => [#author-list(p.authors), "#loc(p.title)," #emph(loc(p.venue)), #loc(
    p.location,
  ), #ym(p.date). (#loc(p.type))]))

#section(t.patents)
#numbered(cv.patents.map(p => [#author-list(p.authors), "#loc(p.title)," #(
    if p.status == "application" { t.patent_application } else { t.patent_registration }
  ) #p.number.]))

#section(t.projects)
#for e in cv.projects {
  row([#loc(e.title) \ #sub(loc(e.sponsor))], period(e.start, e.at("end", default: none)))
}

#section(t.awards)
#for e in cv.awards {
  row([#loc(e.title), *#loc(e.prize)* #h(0.3em) #sub("· " + loc(e.awarder))], ym(e.date))
}

#section(t.competitions)
#for c in cv.competitions { list(loc(c)) }

#section(t.fellowships)
#for e in cv.fellowships {
  row([#loc(e.title) #h(0.3em) #sub("· " + loc(e.organization))], period(e.start, e.at("end", default: none)))
}

#section(t.certificates)
#for e in cv.certificates {
  row(loc(e.title), ym(e.date))
}
