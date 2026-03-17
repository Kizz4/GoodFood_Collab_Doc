workspace "Good Food 3.0 - Option 3" "C4 model of the final Option 3 microservices target" {
    !identifiers hierarchical
    !docs docs
    !decisions decisions

    model {
        !include definition/actors.dsl

        goodFood = softwareSystem "Good Food 3.0 - Option 3" "Ordering, franchise, and back-office platform on Kubernetes" {
            tags "TechKubernetes"
            !include definition/clients.dsl

            group "Kubernetes Cluster" {
                !include definition/infrastructure.dsl
                !include definition/services.dsl
                !include definition/db.dsl
            }
        }

        !include C1/relation.dsl
        !include C2/relation.dsl
        !include C4/relation.dsl
    }

    views {
        !include C1/view.dsl
        !include C2/view.dsl
        !include C3/view.dsl
        !include C4/view.dsl
        !include style.dsl
    }

    configuration {
        scope "SoftwareSystem"
    }
}
