customerService = container "Service Compte Client" "Profils, adresses, préférences et données client. Domaine du noyau critique, d'abord porté dans le modulith initial puis extrait dans la cible finale." "ASP.NET Core" {
    tags "Microservice" "Phase1"
    customerApi = component "API Layer" "API compte client"
    customerDomain = component "Customer Domain" "Profil, adresses, préférences"
    customerRepo = component "Repository" "Accès données client"
}

catalogueService = container "Service Catalogue" "Menus, produits, disponibilités et horaires. Domaine du noyau critique, ensuite extrait en service autonome." "ASP.NET Core" {
    tags "Microservice" "Phase1"
    catalogueApi = component "API Layer" "API catalogue"
    catalogueDomain = component "Catalogue Domain" "Menus, produits, disponibilités"
    catalogueRepo = component "Repository" "Accès données catalogue"
}

orderService = container "Service Commande" "Panier, commande, promotions et statuts. Domaine du noyau critique, conçu tôt puis extrait dans la cible finale." "ASP.NET Core" {
    tags "Microservice" "Phase1"
    orderApi = component "API Layer" "API commande"
    orderDomain = component "Order Domain" "Panier, commande, promotions, statuts"
    outboxPublisher = component "Outbox Publisher" "Publication fiable des événements métier"
    orderRepo = component "Repository" "Accès données commande"
}

complaintService = container "Service Réclamations" "Avis, réclamations et workflow de traitement. Domaine ajouté pour obtenir un modulith complet avant séparation finale." "ASP.NET Core" {
    tags "Microservice" "Phase2"
    complaintApi = component "API Layer" "API réclamations"
    complaintDomain = component "Complaint Domain" "Réclamations, avis, workflow"
    complaintRepo = component "Repository" "Accès données réclamations"
}

franchiseService = container "Service Franchise" "Promotions locales, fournisseurs, préparation et opérations réseau. Domaine ajouté pour compléter le modulith avant séparation." "ASP.NET Core" {
    tags "Microservice" "Phase2"
    franchiseApi = component "API Layer" "API franchise"
    franchiseDomain = component "Franchise Domain" "Promotions, fournisseurs, préparation"
    franchiseRepo = component "Repository" "Accès données franchise"
}

paymentService = container "Service Paiement" "Premier service extrait pour isoler les flux sensibles de paiement pendant la transition." "ASP.NET Core" {
    tags "Microservice" "Phase3"
    paymentApi = component "API Layer" "API paiement"
    paymentDomain = component "Payment Domain" "Payment intent, validation, remboursement"
    paymentProviderAdapter = component "Payment Provider Adapter" "Adaptateur vers BNB / PSP"
    paymentRepo = component "Repository" "Accès données paiement"
}

deliveryService = container "Service Livraison" "Service extrait pour affectation, suivi, ETA et preuve de livraison pendant la transition vers le distribué." "Node.js / TypeScript" {
    tags "Microservice" "Phase3"
    deliveryApi = component "API Layer" "API livraison"
    deliveryDomain = component "Delivery Domain" "Affectation, suivi, incidents, ETA"
    mapsAdapter = component "Maps Adapter" "Intégration Google Maps"
    deliveryRepo = component "Repository" "Accès données livraison"
}

notificationService = container "Service Notification" "Notifications email, SMS et push déclenchées par événements" "ASP.NET Core Worker/API" {
    tags "Microservice" "Notification" "Phase3"
    notificationApi = component "API Layer" "Endpoints et administration"
    notificationDomain = component "Notification Domain" "Templates, préférences, routage"
    notificationRepo = component "Repository" "Accès données notification"
    emailAdapter = component "Email Adapter" "Envoi SendGrid"
    smsAdapter = component "SMS Adapter" "Envoi Twilio"
    pushAdapter = component "Push Adapter" "Envoi Firebase"
}

integrationHub = container "Integration Hub / ACL" "Couche anti-corruption pour ERP, trésorerie, messagerie, caisse et flux partenaires" "ASP.NET Core Worker" {
    tags "Microservice" "Integration" "Phase3"
    integrationApi = component "API Layer" "Administration technique et replay"
    eventConsumers = component "Event Consumers" "Consomme les événements métier"
    integrationRepo = component "Repository" "Traces techniques et outbox d'intégration"
    dynamicsAdapter = component "Dynamics Adapter" "Synchronisation ERP"
    sageAdapter = component "Sage Adapter" "Journal et trésorerie"
    mailboxAdapter = component "Mailbox Adapter" "Messagerie et boîtes partagées"
    posAdapter = component "POS Adapter" "Nouveau système de caisse et TPE"
    financeAdapter = component "Banking Adapter" "BNB / EBICS"
}

sagaOrchestrator = container "Orchestrateur Saga" "Brique d'orchestration finale quand la plateforme atteint son niveau microservices complet" "MassTransit StateMachine" {
    tags "Microservice" "Orchestration" "Phase4"
    sagaApi = component "API Layer" "Suivi et pilotage technique"
    sagaManager = component "Saga Manager" "Machine d'états et compensations"
    sagaRepo = component "Repository" "Persistance des états de saga"
}
