container goodFoodAsIs "ASIS_C2_Containers" {
    include *
    autoLayout tb 320 140
    title "Good Food AS-IS - Vue conteneurs"
}

container goodFoodAsIs "ASIS_C2_CommandePaiement" {
    include client franchiseManager
    include goodFoodAsIs.legacyWebApp goodFoodAsIs.legacySqlServerDb
    include bnbBank pwiHosting
    autoLayout lr 300 120
    title "Good Food AS-IS - Flux commande/paiement"
}

container goodFoodAsIs "ASIS_C2_IntegrationERP" {
    include goodFoodAsIs.legacyWebApp goodFoodAsIs.erpSyncWcf goodFoodAsIs.legacySqlServerDb
    include dynamics365 wimHosting
    autoLayout lr 300 120
    title "Good Food AS-IS - Integration ERP quotidienne"
}

container goodFoodAsIs "ASIS_C2_ComptaReclamations" {
    include serviceCommunication serviceComptabilite
    include goodFoodAsIs.backOfficePortal goodFoodAsIs.emailRelay
    include microsoft365 sageTresorerie dynamics365 bnbBank tpSystem
    autoLayout lr 300 120
    title "Good Food AS-IS - Reclamations et flux comptables"
}
