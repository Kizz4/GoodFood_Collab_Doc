container goodFood "C2_Option3_Containers" {
    include *
    exclude "element.tag==Database"
    exclude goodFood.logsService
    autoLayout tb 700 110
    title "C2 - Container View"
}

container goodFood "C2_Option3_EndToEnd" {
    include customer franchiseManager courier
    include goodFood.webApp goodFood.mobileClientApp goodFood.mobileCourierApp
    include goodFood.apiGateway goodFood.serviceDiscovery goodFood.authPlatform
    include goodFood.customerService goodFood.catalogueService goodFood.orderService
    include goodFood.localAssortmentService goodFood.preparationService
    include goodFood.paymentService goodFood.deliveryService goodFood.sagaOrchestrator
    include goodFood.messageBroker goodFood.cacheRedis
    include bnbPayment googleMapsApi
    autoLayout tb 700 110
    title "C2 - Order to Delivery"
}

container goodFood "C2_Option3_Integrations" {
    include goodFood.apiGateway goodFood.serviceDiscovery
    include goodFood.integrationHub goodFood.notificationService goodFood.paymentService
    include goodFood.localAssortmentService goodFood.supplierService goodFood.preparationService goodFood.deliveryService
    include goodFood.messageBroker
    include dynamics365 sageTreasury microsoft365 tpSystem bnbPayment googleMapsApi
    include sendGridApi twilioApi firebaseFcm
    autoLayout tb 700 110
    title "C2 - External Integrations"
}
