client -> goodFood.webApp "Web" "HTTPS"
client -> goodFood.mobileClientApp "Mobile" "HTTPS"
franchise -> goodFood.webApp "Web" "HTTPS"
livreur -> goodFood.mobileCourierApp "Mobile" "HTTPS"
serviceComptabilite -> goodFood.webApp "Back-office" "HTTPS"
serviceCommunication -> goodFood.webApp "Back-office" "HTTPS"
serviceInformatique -> goodFood.webApp "Back-office" "HTTPS"

goodFood.webApp -> goodFood.apiGateway "API" "REST/HTTPS"
goodFood.mobileClientApp -> goodFood.apiGateway "API" "REST/HTTPS"
goodFood.mobileCourierApp -> goodFood.apiGateway "API" "REST/HTTPS"

goodFood.apiGateway -> goodFood.authPlatform "Auth" "OIDC/JWT"
goodFood.authPlatform -> goodFood.authDb "Stocke identité et configuration" "PostgreSQL"

goodFood.apiGateway -> goodFood.serviceDiscovery "Discovery" "HTTP"
goodFood.apiGateway -> goodFood.customerService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.catalogueService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.orderService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.complaintService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.franchiseService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.paymentService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.deliveryService "API" "REST/HTTPS"
goodFood.apiGateway -> goodFood.notificationService "API" "REST/HTTPS"

goodFood.customerService -> goodFood.customerDb "Lecture/écriture" "PostgreSQL"

goodFood.catalogueService -> goodFood.catalogueDb "Lecture/écriture" "PostgreSQL"
goodFood.catalogueService -> goodFood.cacheRedis "Cache" "Redis"

goodFood.orderService -> goodFood.customerService "REST" "REST/HTTPS"
goodFood.orderService -> goodFood.catalogueService "REST" "REST/HTTPS"
goodFood.orderService -> goodFood.orderDb "Lecture/écriture" "PostgreSQL"
goodFood.orderService -> goodFood.messageBroker "Events" "AMQP"

goodFood.complaintService -> goodFood.complaintDb "Lecture/écriture" "PostgreSQL"
goodFood.complaintService -> goodFood.messageBroker "Events" "AMQP"

goodFood.franchiseService -> goodFood.franchiseDb "Lecture/écriture" "PostgreSQL"
goodFood.franchiseService -> goodFood.messageBroker "Events" "AMQP"

goodFood.paymentService -> goodFood.paymentDb "Lecture/écriture" "PostgreSQL"
goodFood.paymentService -> goodFood.messageBroker "Events" "AMQP"
goodFood.paymentService -> bnbPayment "PSP" "HTTPS/API"

goodFood.deliveryService -> goodFood.deliveryDb "Lecture/écriture" "MongoDB"
goodFood.deliveryService -> goodFood.messageBroker "Events" "AMQP"
goodFood.deliveryService -> googleMapsApi "Maps" "HTTPS"

goodFood.notificationService -> goodFood.notificationDb "Lecture/écriture" "PostgreSQL"
goodFood.notificationService -> goodFood.messageBroker "Events" "AMQP"
goodFood.notificationService -> sendGridApi "Email" "HTTPS/API"
goodFood.notificationService -> twilioApi "SMS" "HTTPS/API"
goodFood.notificationService -> firebaseFcm "Push" "HTTPS/API"

goodFood.integrationHub -> goodFood.messageBroker "Events" "AMQP"
goodFood.integrationHub -> goodFood.integrationDb "Outbox, traces et états techniques" "PostgreSQL"
goodFood.integrationHub -> dynamics365 "ERP" "HTTPS/API"
goodFood.integrationHub -> sageTreasury "Trésorerie" "HTTPS/API"
goodFood.integrationHub -> microsoft365 "Messagerie" "HTTPS/API"
goodFood.integrationHub -> tpSystem "POS" "HTTPS/API"
goodFood.integrationHub -> bnbPayment "EBICS" "HTTPS/EBICS"

goodFood.sagaOrchestrator -> goodFood.messageBroker "Events" "AMQP"
goodFood.sagaOrchestrator -> goodFood.sagaDb "Persiste les états de saga" "PostgreSQL"
