container goodFood "C3_Option3_RuntimeAndData" {
    include goodFood.apiGateway
    include goodFood.serviceDiscovery
    include goodFood.authPlatform
    include goodFood.authDb
    include goodFood.messageBroker
    include goodFood.cacheRedis
    include goodFood.customerService
    include goodFood.catalogueService
    include goodFood.orderService
    include goodFood.complaintService
    include goodFood.franchiseService
    include goodFood.paymentService
    include goodFood.deliveryService
    include goodFood.notificationService
    include goodFood.integrationHub
    include goodFood.sagaOrchestrator
    include goodFood.customerDb
    include goodFood.catalogueDb
    include goodFood.orderDb
    include goodFood.complaintDb
    include goodFood.franchiseDb
    include goodFood.paymentDb
    include goodFood.deliveryDb
    include goodFood.notificationDb
    include goodFood.integrationDb
    include goodFood.sagaDb
    autoLayout tb 700 110
    title "C3 - Runtime and Data"
}
