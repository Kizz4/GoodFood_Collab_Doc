container goodFood "1_C2_Schema" {
    include acteurSchema clientSchema gatewaySchema discoverySchema authSchema authDbSchema serviceSchema dbSchema brokerSchema loggerSchema
    autoLayout tb
    title "Good Food - C2 Schéma simplifié"
}

container goodFood "2_C2_Containers" {
    include *
    autoLayout tb 800 100
    title "Good Food - Architecture Containers"
}

container goodFood "6_C2_CommandeEndToEnd" {
    include client restaurateur livreur
    include goodFood.webApp goodFood.mobileApp
    include goodFood.apiGateway
    include goodFood.commandeService goodFood.paiementService goodFood.livraisonService
    include goodFood.messageBroker
    include goodFood.commandeDb goodFood.paiementDb
    include stripeApi googleMapsApi
    autoLayout tb 800 100
    title "Good Food - Parcours Commande (End-to-End)"
}

container goodFood "9_C2_IntegrationsExternes" {
    include goodFood.paiementService
    include goodFood.comptabiliteService
    include goodFood.livraisonService
    include goodFood.notificationService
    include stripeApi sageErp googleMapsApi
    include sendGridApi twilioApi firebaseFcm
    autoLayout tb 800 100
    title "Good Food - Intégrations Externes"
}

container goodFood "10_C2_Reclamations_Support" {
    include client restaurateur
    include goodFood.webApp
    include goodFood.apiGateway
    include goodFood.communicationService
    include goodFood.communicationDb
    include serviceCommunication serviceInformatique
    autoLayout tb 800 100
    title "Good Food - Réclamations & Support"
}
