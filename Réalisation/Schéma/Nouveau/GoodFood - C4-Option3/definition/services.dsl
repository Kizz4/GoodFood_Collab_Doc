customerService = container "Customer Service" "Profiles" "ASP.NET Core API" {
    tags "Microservice" "Phase1" "TechDotNet"
    customerApi = component "Controller" "HTTP endpoints"
    customerDomain = component "Domain" "Business rules"
    customerRepo = component "Repository" "Data access"
}

catalogueService = container "Catalog Service" "Resolved store catalog" "ASP.NET Core API" {
    tags "Microservice" "Phase1" "TechDotNet"
    catalogueApi = component "Controller" "HTTP endpoints"
    catalogueEventConsumer = component "Consumer" "Product, override, and promotion events"
    catalogueDomain = component "Domain" "Resolved sellable views"
    catalogueRepo = component "Repository" "Read model data access"
}

orderService = container "Order Service" "Orders" "ASP.NET Core API" {
    tags "Microservice" "Phase1" "CircuitBreaker" "TechDotNet"
    orderApi = component "Controller" "HTTP endpoints"
    orderEventConsumer = component "Consumer" "Catalog snapshot, preparation, and payment events"
    orderDomain = component "Domain" "Business rules and checkout validation"
    orderRepo = component "Repository" "Orders and checkout reference data"
}

complaintService = container "Complaint Service" "Complaints" "ASP.NET Core API" {
    tags "Microservice" "Phase2" "TechDotNet"
    complaintApi = component "Controller" "HTTP endpoints"
    complaintDomain = component "Domain" "Business rules"
    complaintRepo = component "Repository" "Data access"
}

localAssortmentService = container "Local Assortment Service" "Store menu, stock, price, and promotion rules" "ASP.NET Core API" {
    tags "Microservice" "Phase2" "TechDotNet"
    localAssortmentApi = component "Controller" "HTTP endpoints"
    localAssortmentDomain = component "Domain" "Store rules and local assortment policies"
    localAssortmentRepo = component "Repository" "Local assortment data access"
}

supplierService = container "Supplier Service" "Supplier sourcing and restaurant replenishment" "ASP.NET Core API" {
    tags "Microservice" "Phase2" "TechDotNet"
    supplierApi = component "Controller" "HTTP endpoints"
    supplierDomain = component "Domain" "Supplier rules and sourcing workflows"
    supplierRepo = component "Repository" "Supplier data access"
}

preparationService = container "Preparation Service" "Kitchen preparation workflow" "ASP.NET Core API" {
    tags "Microservice" "Phase2" "CircuitBreaker" "TechDotNet"
    preparationApi = component "Controller" "HTTP endpoints"
    preparationEventConsumer = component "Consumer" "Order and payment lifecycle events"
    preparationDomain = component "Domain" "Preparation workflow and store readiness"
    preparationRepo = component "Repository" "Preparation state data access"
}

paymentService = container "Payment Service" "Payments" "ASP.NET Core API" {
    tags "Microservice" "Phase3" "CircuitBreaker" "TechDotNet"
    paymentApi = component "Controller" "HTTP endpoints"
    paymentEventConsumer = component "Consumer" "Payment commands"
    paymentDomain = component "Domain" "Online payment business rules"
    paymentProviderAdapter = component "Online Adapter" "BNB / PSP integration"
    paymentRepo = component "Repository" "Data access"
}

deliveryService = container "Delivery Service" "Delivery" "Node.js + TS API" {
    tags "Microservice" "Phase3" "CircuitBreaker" "TechNodeTs"
    deliveryApi = component "Controller" "HTTP endpoints"
    deliveryEventConsumer = component "Consumer" "Delivery commands"
    deliveryDomain = component "Domain" "Business rules"
    mapsAdapter = component "Adapter" "Routing integration"
    deliveryRepo = component "Repository" "Data access"
}

notificationService = container "Notification Service" "Notifications" "ASP.NET Core Worker/API" {
    tags "Microservice" "Notification" "Phase3" "CircuitBreaker" "TechDotNet"
    notificationApi = component "Controller" "HTTP endpoints"
    notificationEventConsumer = component "Consumer" "Notification events"
    notificationDomain = component "Domain" "Templates and routing"
    notificationRepo = component "Repository" "Data access"
    emailAdapter = component "Adapter" "Outbound channels"
}

integrationHub = container "Integration Hub" "Integrations" "ASP.NET Core Worker/ACL" {
    tags "Microservice" "Integration" "Phase3" "CircuitBreaker" "TechDotNet"
    integrationApi = component "Controller" "Ops endpoints"
    eventConsumers = component "Consumers" "Event handlers"
    integrationRepo = component "Repository" "State and outbox"
    dynamicsAdapter = component "Adapter" "External integrations"
}

sagaOrchestrator = container "Saga Orchestrator" "Coordination" "MassTransit Saga" {
    tags "Microservice" "Orchestration" "Phase4" "TechDotNet"
    sagaApi = component "Controller" "Ops endpoints"
    sagaManager = component "Saga Manager" "State machine"
    sagaRepo = component "Repository" "State store"
}
