workspace "Good Food AS-IS" "Architecture C4 - application actuelle" {
    !identifiers hierarchical
    !docs docs
    !decisions decisions

    model {
        !include definition/actors.dsl

        goodFoodAsIs = softwareSystem "Good Food Commande en ligne (AS-IS)" "Plateforme actuelle de commande en ligne et ses integrations historiques" {
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
        themes default
    }

    configuration {
        scope "SoftwareSystem"
    }
}
