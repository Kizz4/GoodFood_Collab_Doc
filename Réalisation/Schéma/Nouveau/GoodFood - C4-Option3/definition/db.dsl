customerDb = container "Customer DB" "Profiles" "PostgreSQL" "Database" {
    tags "Phase1" "DbPostgreSQL"
}

catalogueDb = container "Catalog DB" "Menus" "PostgreSQL" "Database" {
    tags "Phase1" "DbPostgreSQL"
}

orderDb = container "Order DB" "Orders" "PostgreSQL" "Database" {
    tags "Phase1" "DbPostgreSQL"
}

complaintDb = container "Complaint DB" "Complaints" "PostgreSQL" "Database" {
    tags "Phase2" "DbPostgreSQL"
}

franchiseDb = container "Franchise DB" "Store data" "PostgreSQL" "Database" {
    tags "Phase2" "DbPostgreSQL"
}

paymentDb = container "Payment DB" "Payments" "PostgreSQL" "Database" {
    tags "Phase3" "DbPostgreSQL"
}

deliveryDb = container "Delivery DB" "Tracking" "MongoDB" "Database" {
    tags "Phase3" "DbMongoDB"
}

notificationDb = container "Notification DB" "Templates" "PostgreSQL" "Database" {
    tags "Phase3" "DbPostgreSQL"
}

integrationDb = container "Integration DB" "Integration state" "PostgreSQL" "Database" {
    tags "Phase3" "DbPostgreSQL"
}

authDb = container "IAM DB" "Identity data" "PostgreSQL" "Database" {
    tags "DbPostgreSQL"
}

sagaDb = container "Saga DB" "Saga state" "PostgreSQL" "Database" {
    tags "Phase4" "DbPostgreSQL"
}
