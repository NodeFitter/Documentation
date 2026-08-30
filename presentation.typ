#import "lib/commonPresentation.typ": cover, slide

#cover("NodeFitter")

#slide("The problem", [

  #align(center + horizon)[
    #grid(
      columns: (50%, 50%),
      align: (x, y) => {
        if (x == 0) {
          left
        } else {
          center + horizon
        }
      },
      [
        #text(size: 2em)[
          - Kubernetes automatically creates pods and schedule them...

          - But Kubernetes needs existing nodes to schedule pods on..

          - Provisioning nodes/VMs manually can become cumbersome

          - An automatic scaler is desirable
        ]
      ],
      [
        #image("img/mdi--cloud-cog.svg", width: 50%)
      ],
    )
  ]

])

#slide("The solution", [

  #align(center + horizon)[
    #text(size: 2em)[

      #grid(
        columns: (40%, 60%),
        align: (x, y) => {
          if (x == 0) {
            left
          } else {
            center + horizon
          }
        },
        [
          - NodeFitter is an automatic VM scaler for OpenNebula

          - Automatically provision VMs and manages their lifecycle within the Kubernetes cluster

          - VMs scheduling and descheduling is done according to currently available resources in existing nodes
        ],
        [
          #image("img/Arch(itecture).png", width: 100%)
        ],
      )

    ]

  ]

  // Show autoscheduler start

])

#slide("The solution in action (1/2)", [

  #text(size: 2em)[

    #align(center + horizon)[
      Let's test the autoscaler and its CLI
    ]

  ]

])

#slide("The demo", [

  #align(center + horizon)[
    #grid(
      columns: (50%, 50%),
      align: (x, y) => {
        if (x == 0) {
          left
        } else {
          center + horizon
        }
      },
      [
        #text(2em)[
          - A Go application and a MariaDB database

          - HPAs with custom metrics and logs

          - Pods divided into appropriate namespaces

          - Network Policy safeguard connections

          - Deployment script for initialization (including secrets)
        ]
      ],
      [
        #image("img/mdi--cloud-cog.svg", width: 50%)
      ],
    )
  ]

])

#slide("The solution in action (2/2)", [

  #text(size: 2em)[

    #align(center + horizon)[
      Let's test the deployment and its effect
    ]

  ]

])
