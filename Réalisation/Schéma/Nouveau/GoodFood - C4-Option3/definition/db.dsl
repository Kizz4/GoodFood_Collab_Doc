customerDb = container "Customer DB" "Profiles" "PostgreSQL" "Database" {
    tags "Phase1" "DbPostgreSQL"
}

catalogueDb = container "Catalog DB" "Resolved store catalog" "PostgreSQL" "Database" {
    tags "Phase1" "DbPostgreSQL"
}

orderDb = container "Order DB" "Orders" "PostgreSQL" "Database" {
    tags "Phase1" "DbPostgreSQL"
}

complaintDb = container "Complaint DB" "Complaints" "PostgreSQL" "Database" {
    tags "Phase2" "DbPostgreSQL"
}

localAssortmentDb = container "Local Assortment DB" "Store menu, stock, price, and promotion rules" "PostgreSQL" "Database" {
    tags "Phase2" "DbPostgreSQL"
}

supplierDb = container "Supplier DB" "Suppliers and sourcing" "PostgreSQL" "Database" {
    tags "Phase2" "DbPostgreSQL"
}

preparationDb = container "Preparation DB" "Kitchen workflow and readiness" "PostgreSQL" "Database" {
    tags "Phase2" "DbPostgreSQL"
}

paymentDb = container "Payment DB" "Payments" "PostgreSQL" "Database" {
    tags "Phase3" "DbPostgreSQL"
}

deliveryDb = container "Delivery DB" "Tracking" "MongoDB" "Database" {
    tags "Phase3" "DbMongoDB"
}

notificationDb = container "Notify DB" "Templates" "PostgreSQL" "Database" {
    tags "Phase3" "DbPostgreSQL"
}

integrationDb = container "Integ. DB" "Integration state" "PostgreSQL" "Database" {
    tags "Phase3" "DbPostgreSQL"
}

authDb = container "IAM DB" "Identities" "PostgreSQL" "Database" {
    tags "DbPostgreSQL"
}

sagaDb = container "Saga DB" "Saga state" "PostgreSQL" "Database" {
    tags "Phase4" "DbPostgreSQL"
}
