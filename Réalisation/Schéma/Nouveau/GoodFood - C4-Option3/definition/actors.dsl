customer = person "Customer" "Orders food" {
    tags "User"
}

franchiseManager = person "Restaurant" "Runs store operations" {
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

dynamics365 = softwareSystem "Dynamics 365" "ERP and CRM" {
    tags "External"
}

sageTreasury = softwareSystem "Sage" "Treasury" {
    tags "External"
}

bnbPayment = softwareSystem "BNB / PSP" "Payments" {
    tags "External"
}

tpSystem = softwareSystem "TP System / TPE" "Payment terminals" {
    tags "External"
}

googleMapsApi = softwareSystem "Google Maps" "ETA and routing" {
    tags "External"
}

sendGridApi = softwareSystem "SendGrid" "Email" {
    tags "External"
}

twilioApi = softwareSystem "Twilio" "SMS" {
    tags "External"
}

firebaseFcm = softwareSystem "Firebase FCM" "Push" {
    tags "External"
}
