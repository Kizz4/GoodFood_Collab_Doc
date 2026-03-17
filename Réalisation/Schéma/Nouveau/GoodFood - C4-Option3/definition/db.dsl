customerDb = container "Customer DB" "Customer profiles, addresses and preferences" "PostgreSQL" "Database" {
    tags "Phase1" "DbPostgreSQL"
}

catalogueDb = container "Catalog DB" "Menus, products, availability and opening hours" "PostgreSQL" "Database" {
    tags "Phase1" "DbPostgreSQL"
}

orderDb = container "Order DB" "Cart, orders, promotions and status" "PostgreSQL" "Database" {
    tags "Phase1" "DbPostgreSQL"
}

complaintDb = container "Complaint DB" "Reviews, incidents and handling workflow" "PostgreSQL" "Database" {
    tags "Phase2" "DbPostgreSQL"
}

franchiseDb = container "Franchise DB" "Local promotions, suppliers and network operations" "PostgreSQL" "Database" {
    tags "Phase2" "DbPostgreSQL"
}

paymentDb = container "Payment DB" "Payments, refunds and state" "PostgreSQL" "Database" {
    tags "Phase3" "DbPostgreSQL"
}

deliveryDb = container "Delivery DB" "Assignments, status, tracking, ETA and proof of delivery" "MongoDB" "Database" {
    tags "Phase3" "DbMongoDB"
}

notificationDb = container "Notification DB" "Preferences, templates and delivery history" "PostgreSQL" "Database" {
    tags "Phase3" "DbPostgreSQL"
}

integrationDb = container "Integration DB" "Outbox, technical logging and replay state" "PostgreSQL" "Database" {
    tags "Phase3" "DbPostgreSQL"
}

authDb = container "IAM DB" "Keycloak identities and configuration" "PostgreSQL" "Database" {
    tags "DbPostgreSQL"
}

sagaDb = container "Saga DB" "Saga state and distributed compensations" "PostgreSQL" "Database" {
    tags "Phase4" "DbPostgreSQL"
}
