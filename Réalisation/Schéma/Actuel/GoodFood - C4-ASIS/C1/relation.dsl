client -> goodFoodAsIs "Passe commande" "Web"
franchiseManager -> goodFoodAsIs "Gere operations franchises" "Web"
serviceCommunication -> goodFoodAsIs "Traite les reclamations" "Back-office"
serviceComptabilite -> goodFoodAsIs "Controle les ventes" "Back-office"
serviceInformatique -> goodFoodAsIs "Support et incidents" "Back-office"

pwiHosting -> goodFoodAsIs "Heberge et supervise" "Prestataire"
wimHosting -> goodFoodAsIs "Maintient et heberge la synchro WCF" "Prestataire"

goodFoodAsIs -> bnbBank "Paiement en ligne" "HTTPS"
goodFoodAsIs -> dynamics365 "Synchronisation clients/ventes" "WCF/API"
goodFoodAsIs -> microsoft365 "Reclamations email" "SMTP/Outlook"

tpSystem -> bnbBank "Transactions TPE" "Flux bancaire"
bnbBank -> sageTresorerie "Transactions quotidiennes" "EBICS"
sageTresorerie -> dynamics365 "Remontee finances consolidees" "Connecteur ERP"
