    commandeService = container "Service Commande" "Gestion des commandes" "ASP.NET Core" {
        tags "Microservice"
        commandeController = component "Controller" "API REST"
        commandeDomain = component "Domain" "Logique métier"
        commandeRepo = component "Repository" "Accès données"
    }

    catalogueService = container "Service Catalogue" "Produits & Stock" "ASP.NET Core" {
        tags "Microservice"
        catalogueController = component "Controller" "API REST"
        catalogueDomain = component "Domain" "Logique métier"
        catalogueRepo = component "Repository" "Accès données"
    }

    paiementService = container "Service Paiement" "Transactions" "ASP.NET Core" {
        tags "Microservice"
        paiementController = component "Controller" "API REST"
        paiementDomain = component "Domain" "Logique métier"
        stripeAdapter = component "Stripe Adapter" "Intégration Stripe"
    }

    livraisonService = container "Service Livraison" "Préparation & Livraison" "ASP.NET Core" {
        tags "Microservice"
        livraisonController = component "Controller" "API REST"
        livraisonDomain = component "Domain" "Logique métier"
        livraisonRepo = component "Repository" "Accès données"
        mapsAdapter = component "Maps Adapter" "Intégration Google Maps"
    }

    communicationService = container "Service Communication" "Avis & Réclamations" "ASP.NET Core" {
        tags "Microservice"
        communicationController = component "Controller" "API REST"
        communicationDomain = component "Domain" "Logique métier"
        communicationRepo = component "Repository" "Accès données"
    }

    comptabiliteService = container "Service Comptabilité" "Journaux comptables" "ASP.NET Core" {
        tags "Microservice"
        comptabiliteController = component "Controller" "API REST"
        comptabiliteDomain = component "Domain" "Logique métier"
        comptabiliteRepo = component "Repository" "Accès données"
        sageAdapter = component "Sage Adapter" "Intégration Sage ERP"
    }

    notificationService = container "Service Notification" "Push, Email, SMS" "ASP.NET Core" {
        tags "Microservice" "Notification"
        notificationController = component "Controller" "API REST"
        notificationDomain = component "Domain" "Logique métier"
        notificationRepo = component "Repository" "Accès données"
        emailAdapter = component "Email Adapter" "Envoi Email"
        smsAdapter = component "SMS Adapter" "Envoi SMS"
        pushAdapter = component "Push Adapter" "Envoi Push"
    }

    orchestrateurService = container "Orchestrateur Saga" "Transactions distribuées" "MassTransit" {
        tags "Microservice" "Orchestration"
        orchestrateurController = component "Controller" "API REST"
        sagaOrchestrator = component "Saga Manager" "Coordonne les sagas"
        commandeSaga = component "Commande Saga" "Flux Commande→Paiement→Livraison"
        sagaRepo = component "Repository" "État des sagas"
    }
