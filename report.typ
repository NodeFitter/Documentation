#import "./lib/common.typ": authors, course, projectName, university, authors
#import "./lib/commonReport.typ": docBody, firstPage, indexPage

#firstPage([#course], "Project report")

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
        [#authors.lorenzo.name #authors.lorenzo.surname],
        [#authors.lorenzo.stid],
        [#link("mailto:" + authors.lorenzo.email)[#authors.lorenzo.email]],

        [#authors.matteo.name #authors.matteo.surname],
        [#authors.matteo.stid],
        [#link("mailto:" + authors.matteo.email)[#authors.matteo.email]],
      ),
      caption: "Group information summary table",
    )

    == Problem description

    #figure(
      caption: "Schema of the project final goal",
      image("img/Arch(itecture).png", width: 80%),
    )

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

    Specifically, this group implemented *NodeFitter*, an *autoscaler* capable of
    dynamically expanding or shrinking a cluster hosted in nodes created
    with OpenNebula.

    = Solution

    Regarding the proposed solution, NodeFitter is capable of interacting with OpenNebula via OpenNebula's API for the *go* language: based on memory and cpu consumption of every VM, the autoscaler automatically creates VMs upon resource deficit and makes them join the already existing Kubernetes cluster. At the same time, if a deployed VM does not host any pods, the autoscaler will automatically delete and remove from the cluster said VM.

    To effectively test *NodeFitter* capabilities, we developed a simple *go application* which exposes various endpoints, and deployed a *mariadb database* as a backend without persistency: both entity expose a counter uses by *horizontal pod autoscalers* (one for each of the components) to deploy new pods, while the different endpoints of the frontend application allow to test the two scaling together or independently.

    Finally, to satisfy the security requirement, *network policies* have been implemented to allow only the necessary connection between components, and logs of the various pods are automatically collected and pushed to a *loki* container, which interaction are possible via the *grafana* user interface.

    == OpenNebula Virtual Machines

    In order for the autoscaler to work properly, an initial setup of OpenNebula is needed. Specifically, the autoscaler will check upon starting up what VMs are currently running and from what template they have been instantiated from. If the autoscaler detects the presence of templates with no currently running VMs, the software will automatically create one VM per type of template. Additionally, every template has to be associated with an OpenNebula's VM group: this will allow to logically group VMs that will run the same type of pods. Specifically, when a VM will start and join the cluster, it will automatically have a kubernetes label ```env type=<VM-group-name>```: our deployment has been set up to only schedule a pod with the same label on node having the same exact label. For example, the frontend application will have label ```env type=frontend```, therefore it has been set up that such pod can be scheduled only on node with label ```env type=frontend```.

    NodeFitter uses two criteria to understand wether a new VM is necessary. Specifically, given an existing VM, a VM of the same type (in other words, instantiated from the same template) has to be created if:
    - the amount of *free memory* is *under* a certain configurable *threshold*;
    - the amount of *available CPU* is *under* a certain configurable *threshold*.

    Unfortunately, OpenNebula's monitoring data, accessible via API, includes memory consumption of both the VM and the hypervisor: therefore, such information needs to be pushed out from the VM. This is achievable using #link("https://docs.opennebula.io/7.4/product/virtual_machines_operation/multi-vm_workflows/onegate_usage/")[OpenNebula's OneGate], that allows to push information in the VM user template.

    With such consideration, NodeFitter modifies the VM template to include a base64-encoded script which pushes the necessary information into the user template. To regularly run the script, the VM needs to have the #link("https://wiki.qemu.org/Features/GuestAgent")[*QEMU guest agent*] active and OpenNebula has to be configured to use the guest agent's #link("https://www.qemu.org/docs/master/qapi-qga-index.html")[*guest-exec*] instruction to execute the script every time it updates the monitoring data. The custom command can be set up by modifying OpenNebula's *guestconfig.conf* file, as described in the #link("https://github.com/NodeFitter/NodeFitter/blob/main/VMsConfig/README.md")[VM setup README].

    Additionally, the autoscaler push another base-64 encoded command in the new VM template which will allow the VM to join the kubernetes cluster via `kubadm join` command and the following file:

    #grid(
      columns: (50%, 50%),
      [
        #figure(
          kind: "config",
          supplement: "Configuration example",
          caption: "kubeadm join configuration",
          text()[
            ```yaml
            kind: JoinConfiguration
            discovery:
              bootstrapToken:
                apiServerEndpoint: <endpoint>
                token: <token>
                caCertHashes:
                  - sha256:<cert-sha>
            nodeRegistration:
              kubeletExtraArgs:
                - name: node-labels
                  value: type=<VM-group-name>
            ```
            #v(1em)
          ],
        )

      ],
      [
        As it is possible to notice, the configuration requires the control plane address, the certificate hash and a valid token. The endpoint and the certificate must both be configured in the NodeFitter configuration, which will use them to generate a valid token and join file. To explicit the characteristic, NodeFitter is able to talk to the Kubernetes control plane to make possible for the VM to join the cluster.

        Generated tokens have a 10 minutes validity period.
      ],
    )

    Every time a new VM is detected, spawned or cloned, the autoscaler associate with such VM a configurable safe guard period: when the safe period is active, the VM cannot be deleted. This prevents the VM to be deleted while joining the cluster and waiting for a new pod to be scheduled on itself or to be deleted because Kubernetes chose to momentarily de-schedule a pod.

    The autoscaler check if a new VM needs to be scheduled regularly, but not continuously: an appropriate "cycle time" has to be chosen carefully and can be written in the autoscaler configuration.

    When a *VM* has *no pod of its type scheduled* on itself, provided that a safe guard is not active, it is firstly deleted from OpenNebula, then NodeFitter will contact the Kubernetes control plane to *delete the node* from the cluster.

    Finally, to interact with the autoscaler, a simple CTL, #link("https://github.com/NodeFitter/ScalerCtl")[*ScalerCtl*] who communicates with the autoscaler via unix sockets, has been created: more information available in the #link("https://github.com/NodeFitter/ScalerCtl/blob/main/README.md")[README].

    == Kubernetes



  ],
  [#projectName],
  [Project report],
)
