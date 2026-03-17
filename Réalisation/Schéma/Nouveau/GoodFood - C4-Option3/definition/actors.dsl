customer = person "Customer" "Orders food" {
    tags "User"
}

franchiseManager = person "Franchise Manager / Restaurant" "Runs store operations" {
    tags "User"
}

courier = person "Courier" "Delivers orders" {
    tags "User"
}

accountingTeam = person "Accounting" "Reviews finance" {
    tags "BackOffice"
}

customerCareTeam = person "Customer Care" "Handles complaints" {
    tags "BackOffice"
}

itSupportTeam = person "IT Support" "Supports operations" {
    tags "BackOffice"
}

microsoft365 = softwareSystem "Microsoft 365" "Mail and collaboration" {
    tags "External"
}

dynamics365 = softwareSystem "Microsoft Dynamics 365" "ERP and CRM" {
    tags "External"
}

sageTreasury = softwareSystem "Sage Treasury" "Treasury" {
    tags "External"
}

bnbPayment = softwareSystem "BNB / PSP" "Payments and banking" {
    tags "External"
}

tpSystem = softwareSystem "TP System / New POS" "POS and terminals" {
    tags "External"
}

googleMapsApi = softwareSystem "Google Maps" "Routing and ETA" {
    tags "External"
}

sendGridApi = softwareSystem "SendGrid" "Email delivery" {
    tags "External"
}

twilioApi = softwareSystem "Twilio" "SMS delivery" {
    tags "External"
}

firebaseFcm = softwareSystem "Firebase Cloud Messaging" "Push delivery" {
    tags "External"
}
