customerDb = container "DB Compte Client" "Profils, adresses et préférences client" "PostgreSQL" "Database" {
    tags "Phase1"
}

catalogueDb = container "DB Catalogue" "Menus, produits, disponibilités et horaires" "PostgreSQL" "Database" {
    tags "Phase1"
}

orderDb = container "DB Commande" "Panier, commande, promotions et statuts" "PostgreSQL" "Database" {
    tags "Phase1"
}

complaintDb = container "DB Réclamations" "Avis, incidents et workflow de traitement" "PostgreSQL" "Database" {
    tags "Phase2"
}

franchiseDb = container "DB Franchise" "Promotions locales, fournisseurs et opérations réseau" "PostgreSQL" "Database" {
    tags "Phase2"
}

paymentDb = container "DB Paiement" "Paiements, remboursements et états" "PostgreSQL" "Database" {
    tags "Phase3"
}

deliveryDb = container "DB Livraison" "Missions, statuts, tracking, ETA et preuve de livraison" "MongoDB" "Database" {
    tags "Phase3"
}

notificationDb = container "DB Notification" "Préférences, templates et historique technique" "PostgreSQL" "Database" {
    tags "Phase3"
}

integrationDb = container "DB Intégration" "Outbox, journalisation technique et reprises d'intégration" "PostgreSQL" "Database" {
    tags "Phase3"
}

authDb = container "DB IAM" "Identités et configuration Keycloak" "PostgreSQL" "Database"

sagaDb = container "DB Saga" "États de saga et compensations distribuées" "PostgreSQL" "Database" {
    tags "Phase4"
}
