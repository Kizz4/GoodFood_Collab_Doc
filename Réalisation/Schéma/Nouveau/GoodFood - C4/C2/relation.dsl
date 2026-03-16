client -> goodFood.webApp "Utilise" "HTTPS"
restaurateur -> goodFood.webApp "Utilise" "HTTPS"
livreur -> goodFood.mobileApp "Utilise" "HTTPS"
serviceComptabilite -> goodFood.webApp "Utilise" "HTTPS"
serviceCommunication -> goodFood.webApp "Utilise" "HTTPS"
serviceInformatique -> goodFood.webApp "Utilise" "HTTPS"

goodFood.webApp -> goodFood.apiGateway "Appels API" "REST/HTTPS"
goodFood.mobileApp -> goodFood.apiGateway "Appels API" "REST/HTTPS"

goodFood.apiGateway -> goodFood.authService "Valide JWT" "JWT"
goodFood.authService -> goodFood.authDb "Stocke comptes" "PostgreSQL"

goodFood.apiGateway -> goodFood.serviceDiscovery "Découverte" "HTTP"
goodFood.apiGateway -> goodFood.commandeService "Route /orders" "REST/HTTPS"
goodFood.apiGateway -> goodFood.catalogueService "Route /catalog" "REST/HTTPS"
goodFood.apiGateway -> goodFood.paiementService "Route /payments" "REST/HTTPS"
goodFood.apiGateway -> goodFood.livraisonService "Route /delivery" "REST/HTTPS"
goodFood.apiGateway -> goodFood.communicationService "Route /support" "REST/HTTPS"
goodFood.apiGateway -> goodFood.comptabiliteService "Route /accounting" "REST/HTTPS"
goodFood.apiGateway -> goodFood.notificationService "Route /notifications" "REST/HTTPS"
goodFood.apiGateway -> goodFood.orchestrateurService "Route /saga" "REST/HTTPS"

goodFood.commandeService -> goodFood.messageBroker "Événements" "AMQP"
goodFood.paiementService -> goodFood.messageBroker "Événements" "AMQP"
goodFood.livraisonService -> goodFood.messageBroker "Événements" "AMQP"
goodFood.catalogueService -> goodFood.messageBroker "Événements" "AMQP"
goodFood.notificationService -> goodFood.messageBroker "Souscrit" "AMQP"
goodFood.comptabiliteService -> goodFood.messageBroker "Souscrit" "AMQP"
goodFood.orchestrateurService -> goodFood.messageBroker "Souscrit" "AMQP"

goodFood.commandeService -> goodFood.commandeDb "Lecture/écriture" "PostgreSQL"
goodFood.catalogueService -> goodFood.catalogueDb "Lecture/écriture" "PostgreSQL"
goodFood.paiementService -> goodFood.paiementDb "Lecture/écriture" "PostgreSQL"
goodFood.communicationService -> goodFood.communicationDb "Lecture/écriture" "PostgreSQL"

goodFood.paiementService -> stripeApi "Appels paiement" "HTTPS"
goodFood.comptabiliteService -> sageErp "Sync compta" "HTTPS"
goodFood.livraisonService -> googleMapsApi "Géolocalisation" "HTTPS"

goodFood.commandeService -> goodFood.cacheRedis "Cache" "Redis"
goodFood.catalogueService -> goodFood.cacheRedis "Cache" "Redis"

goodFood.logsService -> goodFood.messageBroker "Souscrit logs" "AMQP"
