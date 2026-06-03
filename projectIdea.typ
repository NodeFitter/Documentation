#import "./lib/common.typ": authors, course, projectName
#import "./lib/commonReport.typ": docBody, firstPage, indexPage

#firstPage([#course], "Project proposal")

#pagebreak()


#indexPage()

#docBody(
  [

    = Project description

    = Proposed technologies


    = Proposed architecture

  ],
  [#projectName],
  [Project proposal],
)
