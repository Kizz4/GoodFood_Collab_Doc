container goodFood "C2_Option3_Containers" {
    include *
    exclude "element.tag==Database"
    exclude goodFood.logsService
    autoLayout tb 700 110
    title "Good Food 3.0 - Option 3 - Final microservices target"
}

container goodFood "C2_Option3_EndToEnd" {
    include client franchise livreur
    include goodFood.webApp goodFood.mobileClientApp goodFood.mobileCourierApp
    include goodFood.apiGateway goodFood.serviceDiscovery goodFood.authPlatform
    include goodFood.customerService goodFood.catalogueService goodFood.orderService
    include goodFood.paymentService goodFood.deliveryService goodFood.sagaOrchestrator
    include goodFood.messageBroker goodFood.cacheRedis
    include bnbPayment googleMapsApi
    autoLayout lr
    title "Good Food 3.0 - Option 3 - Order-to-delivery flow (final target)"
}

container goodFood "C2_Option3_Integrations" {
    include goodFood.apiGateway goodFood.serviceDiscovery
    include goodFood.integrationHub goodFood.notificationService goodFood.paymentService goodFood.franchiseService goodFood.deliveryService
    include goodFood.messageBroker
    include dynamics365 sageTreasury microsoft365 tpSystem bnbPayment googleMapsApi
    include sendGridApi twilioApi firebaseFcm
    autoLayout lr
    title "Good Food 3.0 - Option 3 - External integrations (final target)"
}
