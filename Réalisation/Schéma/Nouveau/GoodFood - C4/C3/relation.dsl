goodFood.commandeService.commandeController -> goodFood.commandeService.commandeDomain "Utilise" "In-process"
goodFood.commandeService.commandeDomain -> goodFood.commandeService.commandeRepo "Persiste" "In-process"

goodFood.catalogueService.catalogueController -> goodFood.catalogueService.catalogueDomain "Utilise" "In-process"
goodFood.catalogueService.catalogueDomain -> goodFood.catalogueService.catalogueRepo "Persiste" "In-process"

goodFood.paiementService.paiementController -> goodFood.paiementService.paiementDomain "Utilise" "In-process"
goodFood.paiementService.paiementDomain -> goodFood.paiementService.stripeAdapter "Appelle" "In-process"
goodFood.paiementService.stripeAdapter -> stripeApi "Appels paiement" "HTTPS"

goodFood.livraisonService.livraisonController -> goodFood.livraisonService.livraisonDomain "Utilise" "In-process"
goodFood.livraisonService.livraisonDomain -> goodFood.livraisonService.livraisonRepo "Persiste" "In-process"
goodFood.livraisonService.livraisonDomain -> goodFood.livraisonService.mapsAdapter "Appelle" "In-process"
goodFood.livraisonService.mapsAdapter -> googleMapsApi "Appels API" "HTTPS"

goodFood.communicationService.communicationController -> goodFood.communicationService.communicationDomain "Utilise" "In-process"
goodFood.communicationService.communicationDomain -> goodFood.communicationService.communicationRepo "Persiste" "In-process"

goodFood.comptabiliteService.comptabiliteController -> goodFood.comptabiliteService.comptabiliteDomain "Utilise" "In-process"
goodFood.comptabiliteService.comptabiliteDomain -> goodFood.comptabiliteService.comptabiliteRepo "Persiste" "In-process"
goodFood.comptabiliteService.comptabiliteDomain -> goodFood.comptabiliteService.sageAdapter "Appelle" "In-process"
goodFood.comptabiliteService.sageAdapter -> sageErp "Appels API" "HTTPS"

goodFood.notificationService.notificationController -> goodFood.notificationService.notificationDomain "Utilise" "In-process"
goodFood.notificationService.notificationDomain -> goodFood.notificationService.notificationRepo "Persiste" "In-process"
goodFood.notificationService.notificationDomain -> goodFood.notificationService.emailAdapter "Appelle" "In-process"
goodFood.notificationService.notificationDomain -> goodFood.notificationService.smsAdapter "Appelle" "In-process"
goodFood.notificationService.notificationDomain -> goodFood.notificationService.pushAdapter "Appelle" "In-process"
goodFood.notificationService.emailAdapter -> sendGridApi "SMTP/API" "HTTPS"
goodFood.notificationService.smsAdapter -> twilioApi "SMS API" "HTTPS"
goodFood.notificationService.pushAdapter -> firebaseFcm "Push API" "HTTPS"

goodFood.orchestrateurService.orchestrateurController -> goodFood.orchestrateurService.sagaOrchestrator "Orchestre" "In-process"
goodFood.orchestrateurService.sagaOrchestrator -> goodFood.orchestrateurService.commandeSaga "Exécute" "In-process"
goodFood.orchestrateurService.sagaOrchestrator -> goodFood.orchestrateurService.sagaRepo "Persiste" "In-process"
