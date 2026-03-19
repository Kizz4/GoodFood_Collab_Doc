customer -> goodFood.webApp "Web" "HTTPS"
customer -> goodFood.mobileClientApp "Mobile" "HTTPS"
franchiseManager -> goodFood.webApp "Web" "HTTPS"
courier -> goodFood.mobileCourierApp "Mobile" "HTTPS"
accountingTeam -> goodFood.webApp "Back-office" "HTTPS"
customerCareTeam -> goodFood.webApp "Back-office" "HTTPS"
itSupportTeam -> goodFood.webApp "Back-office" "HTTPS"

goodFood.webApp -> goodFood.apiGateway "API" "REST/HTTPS"
goodFood.mobileClientApp -> goodFood.apiGateway "API" "REST/HTTPS"
goodFood.mobileCourierApp -> goodFood.apiGateway "API" "REST/HTTPS"

goodFood.apiGateway -> goodFood.authPlatform "Auth" "OIDC/JWT"
goodFood.authPlatform -> goodFood.authDb "Stores identities" "PostgreSQL"

goodFood.apiGateway -> goodFood.serviceDiscovery "Discovery" "HTTP"
goodFood.apiGateway -> goodFood.customerService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.catalogueService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.orderService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.complaintService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.localAssortmentService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.supplierService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.preparationService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.paymentService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.deliveryService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.notificationService "API" "REST/HTTPS"

goodFood.customerService -> goodFood.customerDb "Read/write" "PostgreSQL"

goodFood.catalogueService -> goodFood.catalogueDb "Read/write resolved store catalog" "PostgreSQL"
goodFood.catalogueService -> goodFood.cacheRedis "Cache" "Redis"
goodFood.catalogueService -> goodFood.messageBroker "Consumes product and local assortment events; publishes resolved catalog updates" "AMQP"

goodFood.orderService -> goodFood.orderDb "Read/write" "PostgreSQL"
goodFood.orderService -> goodFood.messageBroker "Publishes order events and consumes catalog snapshot, preparation, and payment updates" "AMQP"

goodFood.complaintService -> goodFood.complaintDb "Read/write" "PostgreSQL"
goodFood.complaintService -> goodFood.messageBroker "Publishes complaint events" "AMQP"

goodFood.localAssortmentService -> goodFood.localAssortmentDb "Read/write local assortment and promotion rules" "PostgreSQL"
goodFood.localAssortmentService -> goodFood.messageBroker "Publishes local assortment events" "AMQP"

goodFood.supplierService -> goodFood.supplierDb "Read/write supplier and sourcing rules" "PostgreSQL"
goodFood.supplierService -> goodFood.messageBroker "Publishes supplier sync events" "AMQP"

goodFood.preparationService -> goodFood.preparationDb "Read/write preparation workflow" "PostgreSQL"
goodFood.preparationService -> goodFood.messageBroker "Consumes order and payment lifecycle events; publishes preparation events" "AMQP"

goodFood.paymentService -> goodFood.paymentDb "Read/write" "PostgreSQL"
goodFood.paymentService -> goodFood.messageBroker "Consumes payment commands and publishes payment events" "AMQP"
goodFood.paymentService -> bnbPayment "Online PSP" "HTTPS/API"

goodFood.deliveryService -> goodFood.deliveryDb "Read/write" "MongoDB"
goodFood.deliveryService -> goodFood.messageBroker "Consumes delivery commands and publishes delivery events" "AMQP"
goodFood.deliveryService -> googleMapsApi "Maps" "HTTPS"

goodFood.notificationService -> goodFood.notificationDb "Read/write" "PostgreSQL"
goodFood.notificationService -> goodFood.messageBroker "Consumes notification events" "AMQP"
goodFood.notificationService -> sendGridApi "Email" "HTTPS/API"
goodFood.notificationService -> twilioApi "SMS" "HTTPS/API"
goodFood.notificationService -> firebaseFcm "Push" "HTTPS/API"

goodFood.integrationHub -> goodFood.messageBroker "Consumes integration and store sync events" "AMQP"
goodFood.integrationHub -> goodFood.integrationDb "Stores state" "PostgreSQL"
goodFood.integrationHub -> dynamics365 "ERP" "HTTPS/API"
goodFood.integrationHub -> sageTreasury "Treasury" "HTTPS/API"
goodFood.integrationHub -> microsoft365 "Messaging" "HTTPS/API"
goodFood.integrationHub -> tpSystem "Store-side sync" "HTTPS/API"
goodFood.integrationHub -> bnbPayment "EBICS" "HTTPS/EBICS"

goodFood.sagaOrchestrator -> goodFood.messageBroker "Consumes order events and publishes orchestration commands" "AMQP"
goodFood.sagaOrchestrator -> goodFood.sagaDb "Saga state" "PostgreSQL"
