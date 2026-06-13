#import "./lib/common.typ": authors, course, projectName, university, authors
#import "./lib/commonReport.typ": docBody, firstPage, indexPage

#import "@preview/chronos:0.3.0"


#firstPage([#course], "Project proposal")

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
    all you could ever ask when it comes to container
    orchestration.
    Two particularly useful features for managing large
    clusters are *Horizontal* and *Vertical Pod Autoscaling*, which allow
    Kubernetes to adjust the number of pods and the resources assigned
    to them, respectively. These functionalities help ensure that
    the cluster can grow to meet demand, as well as shrink to avoid
    wasting resources while they are not needed.

    The scaling of a cluster's resources is limited to what the nodes
    are physically able to provide. The provisioning of
    nodes is outside of Kubernetes' scope and must therefore be
    handled externally. This can be done with an external application
    that interacts with both Kubernetes' API and the cloud provider's
    API.

    The focus of this project is to bridge the gap between the
    infrastructure handling nodes and Kubernetes handling pods,
    with the goals of:
    - Allowing for new nodes to be created to host pods that would not
      otherwise fit in the existing nodes;
    - Removing nodes that are deemed unnecessary for hosting the
      current workload.

    Specifically, we want to implement an *autoscaler* capable of
    dynamically expanding or shrinking a cluster hosted in nodes created
    with OpenNebula.


    = Project Proposal Details and Architecture

    Our solution is an application that periodically checks the
    cluster status and decides whether or not it is necessary to *scale*
    the cluster up or down using *OpenNebula's API* (@scheme).

    #v(0.3em)
    #figure(
      caption: [Simplified flow of an individual autoscaler loop],
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
    ] #label("scheme")
    #v(0.3em)

    The environment in which the project will run is to be structured as
    follows:
    - A *machine* running a Linux OS with *OpenNebula* installed;
    - A set of *OpenNebula-managed VMs*, all part of a Kubernetes cluster
      - A *Master Node* containing the Kubernetes *Control Plane* and the
        *autoscaler* application;
      - *Worker Nodes* running code that simulates work.

    Below is a diagram representing the structure of this environment (@diagram):

    #v(0.3em)
    #figure(
      caption: [Diagram for the project environment],
    )[
      #image("img/Arch(itecture).png", width: 90%)
    ]#label("diagram")
    #v(0.3em)

    OpenNebula will be installed using *MiniOne* (similarly to the
    environment for the class lab activities).

    There are several options for running Kubernetes. We have
    decided to diverge from the lab environment and use *`kubeadm`*
    instead of *`minikube`* for our installation due to limitations
    related to working with multiple nodes.

    A *logging service* will be deployed in every node via a
    *DaemonSet* to perform audits and improve traceability.

    The application will be written in *Go*, mainly because of previous
    experience both group members had with the language. An additional
    "controller" tool could also be developed to provide a way to do
    manual modifications to the cluster or to aid with the in-person
    demonstration.

    == Possible complexity improvements

    In order to improve the proposal, some additional improvements can be potentially implemented based on the complexity goal.

    Firstly, instead of allowing the scheduler to schedule pods on every node that is currently part of the cluster, nodes can be configured to only be able to host certain types of pods. This could be achieved by using labels.

    Then, the autoscaler should configure the new VMs by automatically setting up the appropriate label for the hosted node based on what is requested.

    Lastly, an additional improvement could be about network policies: for security reasons, it would be important that only pods with a certain label should be able to contact another pod with a different label.
  ],
  [#projectName],
  [Project proposal],
)
