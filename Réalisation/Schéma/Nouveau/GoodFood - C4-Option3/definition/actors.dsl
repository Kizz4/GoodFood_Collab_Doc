client = person "Customer" "Orders, payments, tracking and complaints" {
    tags "Utilisateur"
}

franchise = person "Franchise Manager / Restaurant" "Manages menus, promotions, preparation and local operations" {
    tags "Utilisateur"
}

livreur = person "Courier" "Checks assignments and confirms deliveries" {
    tags "Utilisateur"
}

serviceComptabilite = person "Accounting" "Tracks ledgers, reconciliations and financial flows" {
    tags "BackOffice"
}

serviceCommunication = person "Customer Care" "Handles reviews, complaints and inbound messages" {
    tags "BackOffice"
}

serviceInformatique = person "IT Support" "Level 1 functional and technical support" {
    tags "BackOffice"
}

microsoft365 = softwareSystem "Microsoft 365" "Mailboxes, shared inboxes and collaboration" {
    tags "Externe"
}

dynamics365 = softwareSystem "Microsoft Dynamics 365" "Finance, HR, CRM and stock ERP" {
    tags "Externe"
}

sageTreasury = softwareSystem "Sage Treasury" "Treasury and reconciliations" {
    tags "Externe"
}

bnbPayment = softwareSystem "BNB / PSP" "Online payment and EBICS banking flows" {
    tags "Externe"
}

tpSystem = softwareSystem "TP System / New POS" "Payment terminal, POS and in-store checkout" {
    tags "Externe"
}

googleMapsApi = softwareSystem "Google Maps" "Routing and ETA" {
    tags "Externe"
}

sendGridApi = softwareSystem "SendGrid" "Transactional email delivery" {
    tags "Externe"
}

twilioApi = softwareSystem "Twilio" "SMS delivery" {
    tags "Externe"
}

firebaseFcm = softwareSystem "Firebase Cloud Messaging" "Push notifications" {
    tags "Externe"
}
