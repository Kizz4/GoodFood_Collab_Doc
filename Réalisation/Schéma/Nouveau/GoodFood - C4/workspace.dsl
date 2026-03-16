workspace "Good Food 3.0" "Architecture C4 - Système de gestion de franchise de restauration" {
    !identifiers hierarchical
    !docs docs
    !decisions decisions

    model {

        # Acteurs + systèmes externes (OK au niveau racine)
        !include definition/actors.dsl
        !include definition/schema.dsl

        # Si "clients.dsl" contient Stripe/Sage/GoogleMaps -> tu peux le laisser ici
        # Sinon, ne l'inclus pas ici.

        goodFood = softwareSystem "Good Food 3.0" "Plateforme de gestion de franchise" {

            # Tout ce qui définit des containers doit être ici
            !include definition/clients.dsl
            !include definition/infrastructure.dsl
            !include definition/services.dsl
            !include definition/db.dsl
        }

        # Relations
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
