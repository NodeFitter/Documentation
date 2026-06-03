#import "./lib/common.typ": authors, course, projectName, university, authors
#import "./lib/commonReport.typ": docBody, firstPage, indexPage

#firstPage([#course], "Project proposal")

#pagebreak()


#indexPage()

#docBody(
  [
    = Introduction

    == Group information
    #figure(
      table(
        columns: (33%, 30%, 37%),
        align: (x, y) => {
          if (y == 0) {
            center + horizon
          } else if (x != 0) {
            center + horizon
          } else {
            horizon
          }
        },

        table.header([*Student*], [*Student Id*], [*Email*]),
        [#authors.lorenzo.name #authors.lorenzo.surname], [#authors.lorenzo.stid], [#authors.lorenzo.email],
        [#authors.matteo.name #authors.matteo.surname], [#authors.matteo.stid], [#authors.matteo.email],
      ),
      caption: "Group information summary table",
    )

    == Project proposal description

    The #course course at the #university requires the creation of a project which demonstrate the knowledge acquired by the students.

    Given the opportunity to openly choose a problem and proposing a solution, this group would like to proceed as follows.

    The company "Monolithic Products Inc." decided to start offering its costumers scalable and cloud-oriented services due to their rapidly growing costumer base.

    The company developed a multi-phase plan in order to adapt itself to the new reality, however, given the current monolithic infrastructure of their software and the corresponding relevant amount of work, the business board decided to ask for the help of 3#super("rd") party developers in order to complete some of the planned tasks.

    The business board entrusted this group the task of creating a scalable solution that is able to manage in a secure way the authentication service of their main product.

    Specifically, it is necessary to build a custom scheduler, called "CloudedLogin", that will be able to monitor in real time the resources usage of the various Virtual Machines (VMs) which will be dedicated to the execution of the application, business and data management logics of the authentication infrastructure, automatically creating new VMs when the available resources are going under an alarm threshold and automatically deleting them when these are no longer necessary.

    Additionally, the 3 logics have to be containerized in order to guarantee a fast deployment of each one of them when needed and the network traffic have to be configured in such a way that it is not possible from external users to directly reach the business or the data management logic, meaning that customers can contact only the application logic. Furthermore, the data management logic can be contacted only by the business logic, and the business logic can be contacted only by the application logic.

    Finally, VMs are exclusively dedicated into hosting only one type of logic, meaning that a VM cannot contain two type of logic at the same time (for example, it is not possible that a VM is running both an instance of the application logic and one of the data management logic).

    = Proposed technologies


    = Proposed architecture

  ],
  [#projectName],
  [Project proposal],
)
