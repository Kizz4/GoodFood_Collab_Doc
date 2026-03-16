workspace "Good Food 3.0 - Option 3" "Architecture C4 de la cible microservices finale de l'option 3, avec lecture de trajectoire par codes couleur" {
    !identifiers hierarchical
    !docs docs
    !decisions decisions

    model {
        !include definition/actors.dsl

        goodFood = softwareSystem "Good Food 3.0 - Option 3" "Plateforme de commande, franchise et back-office décrite dans son état cible microservices final, avec un code couleur qui rappelle les étapes de transformation" {
            !include definition/clients.dsl
            !include definition/infrastructure.dsl
            !include definition/services.dsl
            !include definition/db.dsl
        }

        !include C1/relation.dsl
        !include C2/relation.dsl
        !include C3/relation.dsl
    }

    views {
        !include C1/view.dsl
        !include C2/view.dsl
        !include C3/view.dsl
        !include style.dsl
    }

    configuration {
        scope "SoftwareSystem"
    }
}
