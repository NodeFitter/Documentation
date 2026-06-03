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

    The #course course at the #university requires the creation of a project which demonstrate the knowledge acquired by the students. \
    Given the opportunity to openly choose a problem and proposing a solution, this group would like to proceed as follows.

    In a cloud-oriented environment, virtualization is a fundamental aspect, independently from the chosen method: Virtual Machines (VMs) or containers. Generally, in order to orchestrate containers, a solution like Kubernetes is used, which, under proper configuration, deploys pods and balance network traffic between them.

    However, an important limitation is present: containers, like any other application, run over a machine, but Kubernetes has no native functionality regarding the automatic deploy of new VMs when the ones available are not sufficient to cover the various users' requests.

    The project proposal of this group consists in the creation of scheduler which periodically checks available resources and automatically deploys new VMs when such availability goes under a certain alarm threshold. Naturally, the scheduler must also delete VMs when those additional resources are no longer required.

    For demonstration purposes, this group would also like to create a basic application which offers some sort of functionality, like an authentication service, accessible by users: since software engineering principles dictate the division of an application into application, business and persistence logic, it will not be possible for Kubernetes to schedule new pods containing the mentioned logics in every VM, but every VM will be able to host only one type of logic and the scheduler will be required to automatically setup the new VM for accepting only specific type of pods (for example, a VM will be setup as eligible for pods containing the application logic of the service only) based on the resources needed for each type of logic.

    Finally, users should not be able to contact the business and persistence logic and the application logic should not be able to contact the persistence logic directly: for this reason, network policies should be created to allow users to only contact the application logic and for the persistence logic to only be contacted by the network logic.

    The system, as a whole, has been provisionally named by this group as *CloudedLogin*.

    = Proposed technologies


    = Proposed architecture

  ],
  [#projectName],
  [Project proposal],
)
