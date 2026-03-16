client = person "Client" "Commande, paiement, suivi et réclamations" {
    tags "Utilisateur"
}

franchise = person "Franchisé / Restaurateur" "Gère menus, promotions, préparation et opérations locales" {
    tags "Utilisateur"
}

livreur = person "Livreur" "Consulte ses missions et confirme les livraisons" {
    tags "Utilisateur"
}

serviceComptabilite = person "Comptabilité" "Suit les journaux, rapprochements et flux financiers" {
    tags "BackOffice"
}

serviceCommunication = person "Communication" "Traite les avis, réclamations et messages entrants" {
    tags "BackOffice"
}

serviceInformatique = person "Support IT" "Support fonctionnel et technique de niveau 1" {
    tags "BackOffice"
}

microsoft365 = softwareSystem "Microsoft 365" "Messagerie, boîtes partagées et collaboration" {
    tags "Externe"
}

dynamics365 = softwareSystem "Microsoft Dynamics 365" "ERP finance, RH, CRM et stocks" {
    tags "Externe"
}

sageTreasury = softwareSystem "Sage Trésorerie" "Trésorerie et rapprochements" {
    tags "Externe"
}

bnbPayment = softwareSystem "BNB / PSP" "Paiement en ligne et flux bancaires EBICS" {
    tags "Externe"
}

tpSystem = softwareSystem "TP System / Nouveau système de caisse" "TPE, POS et encaissement terrain" {
    tags "Externe"
}

googleMapsApi = softwareSystem "Google Maps" "Calcul d'itinéraires et ETA" {
    tags "Externe"
}

sendGridApi = softwareSystem "SendGrid" "Envoi d'emails transactionnels" {
    tags "Externe"
}

twilioApi = softwareSystem "Twilio" "Envoi de SMS" {
    tags "Externe"
}

firebaseFcm = softwareSystem "Firebase Cloud Messaging" "Notifications push" {
    tags "Externe"
}
