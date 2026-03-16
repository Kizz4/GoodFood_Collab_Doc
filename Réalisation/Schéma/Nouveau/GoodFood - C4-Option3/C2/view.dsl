container goodFood "C2_Option3_Containers" {
    include *
    autoLayout tb 700 110
    title "Good Food 3.0 - Option 3 - Cible finale microservices"
}

container goodFood "C2_Option3_EndToEnd" {
    include client franchise livreur
    include goodFood.webApp goodFood.mobileClientApp goodFood.mobileCourierApp
    include goodFood.apiGateway goodFood.authPlatform
    include goodFood.customerService goodFood.catalogueService goodFood.orderService
    include goodFood.paymentService goodFood.deliveryService goodFood.sagaOrchestrator
    include goodFood.messageBroker
    include goodFood.customerDb goodFood.catalogueDb goodFood.orderDb
    include goodFood.paymentDb goodFood.deliveryDb goodFood.sagaDb
    include bnbPayment googleMapsApi
    autoLayout lr
    title "Good Food 3.0 - Option 3 - Parcours commande à livraison (cible finale)"
}

container goodFood "C2_Option3_Integrations" {
    include goodFood.integrationHub goodFood.notificationService goodFood.paymentService goodFood.franchiseService goodFood.deliveryService
    include dynamics365 sageTreasury microsoft365 tpSystem bnbPayment googleMapsApi
    include sendGridApi twilioApi firebaseFcm
    autoLayout lr
    title "Good Food 3.0 - Option 3 - Intégrations externes (cible finale)"
}
