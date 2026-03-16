client = person "Client final" "Commande des repas et suit ses commandes" {
    tags "Person"
}

franchiseManager = person "Franchise / Restaurant" "Gere menus, commandes et operations locales" {
    tags "Person"
}

serviceCommunication = person "Service communication" "Traite les reclamations (email, telephone)" {
    tags "BackOffice"
}

serviceComptabilite = person "Service comptabilite" "Controle les rapprochements bancaires et la tresorerie" {
    tags "BackOffice"
}

serviceInformatique = person "Service informatique (N1)" "Support utilisateur et interface avec les prestataires" {
    tags "BackOffice"
}

bnbBank = softwareSystem "BNB (banque + paiement virtuel)" "Paiement en ligne et flux bancaires EBICS" {
    tags "Externe"
}

dynamics365 = softwareSystem "Microsoft Dynamics 365" "ERP franchise (finance, RH, CRM, stocks)" {
    tags "Externe"
}

sageTresorerie = softwareSystem "Sage Tresorerie (siege)" "Tresorerie et rapprochements comptables on-prem" {
    tags "Externe"
}

microsoft365 = softwareSystem "Microsoft 365" "Messagerie, bureautique et boites partages" {
    tags "Externe"
}

tpSystem = softwareSystem "TP System / TPE restaurants" "Terminaux de paiement physiques" {
    tags "Externe"
}

pwiHosting = softwareSystem "PWI (hebergeur)" "Hebergement et supervision de l'application de commande" {
    tags "Externe"
}

wimHosting = softwareSystem "WIM (prestataire dev)" "Maintenance historique et hebergement de la synchro WCF" {
    tags "Externe"
}
