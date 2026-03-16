customerService = container "Service Compte Client" "Compte client" "ASP.NET Core" {
    tags "Microservice" "Phase1" "DbPostgreSQL"
    customerApi = component "API Layer" "API compte client"
    customerDomain = component "Customer Domain" "Profil, adresses, préférences"
    customerRepo = component "Repository" "Accès données client"
}

catalogueService = container "Service Catalogue" "Menus et disponibilités" "ASP.NET Core" {
    tags "Microservice" "Phase1" "DbPostgreSQL"
    catalogueApi = component "API Layer" "API catalogue"
    catalogueDomain = component "Catalogue Domain" "Menus, produits, disponibilités"
    catalogueRepo = component "Repository" "Accès données catalogue"
}

orderService = container "Service Commande" "Panier et commande" "ASP.NET Core" {
    tags "Microservice" "Phase1" "DbPostgreSQL" "CircuitBreaker"
    orderApi = component "API Layer" "API commande"
    orderDomain = component "Order Domain" "Panier, commande, promotions, statuts"
    outboxPublisher = component "Outbox Publisher" "Publication fiable des événements métier"
    orderRepo = component "Repository" "Accès données commande"
}

complaintService = container "Service Réclamations" "Avis et incidents" "ASP.NET Core" {
    tags "Microservice" "Phase2" "DbPostgreSQL"
    complaintApi = component "API Layer" "API réclamations"
    complaintDomain = component "Complaint Domain" "Réclamations, avis, workflow"
    complaintRepo = component "Repository" "Accès données réclamations"
}

franchiseService = container "Service Franchise" "Ops franchisé" "ASP.NET Core" {
    tags "Microservice" "Phase2" "DbPostgreSQL"
    franchiseApi = component "API Layer" "API franchise"
    franchiseDomain = component "Franchise Domain" "Promotions, fournisseurs, préparation"
    franchiseRepo = component "Repository" "Accès données franchise"
}

paymentService = container "Service Paiement" "Paiement" "ASP.NET Core" {
    tags "Microservice" "Phase3" "DbPostgreSQL" "CircuitBreaker"
    paymentApi = component "API Layer" "API paiement"
    paymentDomain = component "Payment Domain" "Payment intent, validation, remboursement"
    paymentProviderAdapter = component "Payment Provider Adapter" "Adaptateur vers BNB / PSP"
    paymentRepo = component "Repository" "Accès données paiement"
}

deliveryService = container "Service Livraison" "Affectation et suivi" "Node.js / TypeScript" {
    tags "Microservice" "Phase3" "DbMongoDB" "CircuitBreaker"
    deliveryApi = component "API Layer" "API livraison"
    deliveryDomain = component "Delivery Domain" "Affectation, suivi, incidents, ETA"
    mapsAdapter = component "Maps Adapter" "Intégration Google Maps"
    deliveryRepo = component "Repository" "Accès données livraison"
}

notificationService = container "Service Notification" "Email, SMS, push" "ASP.NET Core Worker/API" {
    tags "Microservice" "Notification" "Phase3" "DbPostgreSQL" "CircuitBreaker"
    notificationApi = component "API Layer" "Endpoints et administration"
    notificationDomain = component "Notification Domain" "Templates, préférences, routage"
    notificationRepo = component "Repository" "Accès données notification"
    emailAdapter = component "Email Adapter" "Envoi SendGrid"
    smsAdapter = component "SMS Adapter" "Envoi Twilio"
    pushAdapter = component "Push Adapter" "Envoi Firebase"
}

integrationHub = container "Integration Hub / ACL" "Intégrations SI" "ASP.NET Core Worker" {
    tags "Microservice" "Integration" "Phase3" "DbPostgreSQL" "CircuitBreaker"
    integrationApi = component "API Layer" "Administration technique et replay"
    eventConsumers = component "Event Consumers" "Consomme les événements métier"
    integrationRepo = component "Repository" "Traces techniques et outbox d'intégration"
    dynamicsAdapter = component "Dynamics Adapter" "Synchronisation ERP"
    sageAdapter = component "Sage Adapter" "Journal et trésorerie"
    mailboxAdapter = component "Mailbox Adapter" "Messagerie et boîtes partagées"
    posAdapter = component "POS Adapter" "Nouveau système de caisse et TPE"
    financeAdapter = component "Banking Adapter" "BNB / EBICS"
}

sagaOrchestrator = container "Orchestrateur Saga" "Coordination distribuée" "MassTransit StateMachine" {
    tags "Microservice" "Orchestration" "Phase4" "DbPostgreSQL"
    sagaApi = component "API Layer" "Suivi et pilotage technique"
    sagaManager = component "Saga Manager" "Machine d'états et compensations"
    sagaRepo = component "Repository" "Persistance des états de saga"
}
