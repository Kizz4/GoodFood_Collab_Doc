client -> goodFoodAsIs.legacyWebApp "Consulte et commande" "HTTPS"
franchiseManager -> goodFoodAsIs.legacyWebApp "Gere menus/promotions" "HTTPS"

serviceCommunication -> goodFoodAsIs.backOfficePortal "Consulte les tickets et avis" "Web"
serviceComptabilite -> goodFoodAsIs.backOfficePortal "Consulte les ventes" "Web"
serviceInformatique -> goodFoodAsIs.backOfficePortal "Support N1" "Web"

goodFoodAsIs.legacyWebApp -> goodFoodAsIs.legacySqlServerDb "Lecture/ecriture" "SQL"
goodFoodAsIs.backOfficePortal -> goodFoodAsIs.legacySqlServerDb "Lecture/ecriture" "SQL"

goodFoodAsIs.legacyWebApp -> bnbBank "Paiement virtuel" "HTTPS"

goodFoodAsIs.legacyWebApp -> goodFoodAsIs.emailRelay "Envoi formulaire reclamation" "SMTP"
goodFoodAsIs.emailRelay -> microsoft365 "Route vers boite contact" "SMTP"
serviceCommunication -> microsoft365 "Traite emails entrants" "Outlook"
serviceCommunication -> dynamics365 "Trace/suit les reclamations" "ERP"

goodFoodAsIs.legacyWebApp -> goodFoodAsIs.erpSyncWcf "Declenche export donnees" "WCF"
goodFoodAsIs.erpSyncWcf -> goodFoodAsIs.legacySqlServerDb "Lit donnees clients/ventes" "SQL"
goodFoodAsIs.erpSyncWcf -> dynamics365 "Pousse synchro journaliere" "WCF/API"

pwiHosting -> goodFoodAsIs.legacyWebApp "Hebergement + supervision" "Run"
wimHosting -> goodFoodAsIs.erpSyncWcf "Hebergement + maintenance" "Run"

tpSystem -> bnbBank "Flux de paiements physiques" "Flux bancaire"
bnbBank -> sageTresorerie "Export transactions de la veille" "EBICS"
serviceComptabilite -> sageTresorerie "Rapprochement/tresorerie" "Sage"
sageTresorerie -> dynamics365 "Consolidation finance" "Connecteur"
