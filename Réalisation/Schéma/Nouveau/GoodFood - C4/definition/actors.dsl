client = person "Client" "Commande des repas en ligne" {
    tags "Utilisateur"
}

livreur = person "Livreur" "Effectue les livraisons" {
    tags "Utilisateur"
}

restaurateur = person "Restaurateur" "Prépare les commandes" {
    tags "Utilisateur"
}

serviceComptabilite = person "Comptabilité" "Gère les paiements" {
    tags "BackOffice"
}
serviceCommunication = person "Communication" "Gère les avis/réclamations" {
    tags "BackOffice"
}
serviceInformatique = person "Support" "Support technique" {
    tags "BackOffice"
}

stripeApi = softwareSystem "Stripe" "Paiement en ligne" {
    tags "Externe"
}

sageErp = softwareSystem "Sage ERP" "Comptabilité" {
    tags "Externe"
}

googleMapsApi = softwareSystem "Google Maps" "Cartographie & GPS" {
    tags "Externe"
}

sendGridApi = softwareSystem "SendGrid" "Envoi d'emails" {
    tags "Externe"
}

twilioApi = softwareSystem "Twilio" "Envoi SMS" {
    tags "Externe"
}

firebaseFcm = softwareSystem "Firebase Cloud Messaging" "Notifications push" {
    tags "Externe"
}
