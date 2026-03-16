erpSyncWcf = container "Synchronisation ERP quotidienne" "Synchronise clients/ventes vers Dynamics 365 (batch quotidien a 05:00)" "Application C# WCF (hebergee chez WIM)" {
    tags "Integration" "Legacy" "Risk" "Weakness" "ToRefactor"

    scheduler5am = component "Scheduler 05:00" "Declenche l'export journalier"
    syncEngine = component "Sync Engine" "Coordonne l'extraction et la publication"
    sourceReader = component "Source Reader" "Lit les donnees SQL Server"
    mappingService = component "Mapping Service" "Transforme les donnees vers le modele ERP"
    dynamicsAdapter = component "Dynamics Adapter" "Publie vers Dynamics 365"
}

!element legacyWebApp {
    storefrontController = component "Storefront Controller" "Endpoints pages/commandes"
    orderService = component "Order Service" "Logique de commande/panier"
    promotionEngine = component "Promotion Engine" "Gestion des codes promo (zone de bugs recurrente)"
    paymentAdapter = component "BNB Payment Adapter" "Connexion a la solution de paiement virtuel"
    complaintForm = component "Complaint Form" "Formulaire de reclamation"
    emailConnector = component "Email Connector" "Transmet les reclamations vers le relais SMTP"
    legacySqlRepository = component "Legacy SQL Repository" "Acces direct SQL Server"
    erpExportPublisher = component "ERP Export Publisher" "Declenche la synchro WCF"
}
