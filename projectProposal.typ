#import "./lib/common.typ": authors, course, projectName, university, authors
#import "./lib/commonReport.typ": docBody, firstPage, indexPage

#import "@preview/chronos:0.3.0"


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

    == The Problem

    Kubernetes is already a quite capable tool, offering pretty much
    all you could ever ask for when it comes to container
    orchestration.
    Two particularly useful features for managing large
    clusters are Horizontal and Vertical Pod Autoscaling, which allow
    Kubernetes to adjust the number of pods and the resources assigned
    to them respectively. These functionalities help ensuring that
    the cluster can grow to meet demand as well as shrink to avoid
    wasting resources while they are not needed.

    The scaling of a cluster's resources is limited to what the nodes
    are physically able to provide. The provisioning of
    nodes is outside of Kubernetes' scope and must therefore be
    handled externally. This can be done with an external application
    that interacts with both Kubernetes' API and the cloud proviser's
    API.

    The focus of this project is to bridge the gap between the
    infrastructure handling nodes and Kubernetes handling pods,
    with the goals of:
    - Allowing for new nodes to be created to host pods that would not
      otherwise fit in the existing nodes.
    - Removing nodes that are deemed unnecessary for hosting the
      current workload.

    Specifically, we want to implement an autoscaler capable of
    dynamically expanding or shrinking a cluster hosted in nodes created
    with OpenNebula.


    = Project Proposal Details and Architecture
    Our solution is an application that periodically checks the
    cluster status and decides whether or not it is necessary to scale
    the cluster up or down using OpenNebula's API.

    \
    #figure(
      caption: [Simplified flow of an individual autoscaler loop]
    )[
      #align(center)[
        #chronos.diagram({
          import chronos: *
          _par("K", display-name: "Kubernetes")
          _par("A", display-name: "Autoscaler")
          _par("N", display-name: "OpenNebula")

          _seq("A", "K", comment: "Get cluster status")
          _seq("K", "A", comment: "Status")

          _seq("A", "A", comment: "Evaluation")

          _seq("A", "N", comment: "Scaling request")
          _seq("N", "A", comment: "Response")
        })
      ]
    ]

    \
    The environment for project demonstration will be structured as
    follows:
    - A machine running a Linux OS with OpenNebula installed
    - A set of OpenNebula managed VMs, all part of a Kubernetes cluster
      - A Master node containing the Kubernetes Control Plane and the
        autoscaler application
      - Worker nodes running code that simulates work

    Below is a diagram representing the structure of this environment:
    #figure(
      caption: [Diagram for the project environment],
    )[
      #underline[THIS SHOULD BE CHANGED WITH AN UPDATED DIAGRAM]
      #image("img/Env_diagram.png", width: 20cm)
    ]

    OpenNebula will be installed using MiniOne (much like the
    environment for the class lab activities).\
    There are several options for running Kubernetes. We have
    decided to diverge from the lab environment and use `kubeadm`
    instead of `minikube` for our installation due to limitations
    related to working with multiple nodes.\

    // The cluster network will be configured with the appropriate
    // security policies to ensure no communication can take place
    // unless deemed strictly necessary.

    \
    The application will be written in Go, mainly because of previous
    experience both group members have with the language. An additional
    "controller" tool could be also developed to provide a way to do
    manual modifications to the cluster or to aid with the in-person
    demonstration.

    == Possible improvements in complexity
    + Multiple types of worker nodes to introduce scheduling limitations
      related to labels
    + Network policies to restrict traffic between different types of
      nodes and the outside
  ],
  [#projectName],
  [Project proposal],
)
