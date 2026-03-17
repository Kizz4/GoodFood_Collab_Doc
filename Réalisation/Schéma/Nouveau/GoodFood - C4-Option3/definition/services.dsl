customerService = container "Customer Service" "Profiles" "ASP.NET Core Web API" {
    tags "Microservice" "Phase1" "TechDotNet"
    customerApi = component "API Layer" "HTTP endpoints"
    customerDomain = component "Customer Domain" "Business rules"
    customerRepo = component "Repository" "Data access"
}

catalogueService = container "Catalog Service" "Menus" "ASP.NET Core Web API" {
    tags "Microservice" "Phase1" "TechDotNet"
    catalogueApi = component "API Layer" "HTTP endpoints"
    catalogueDomain = component "Catalog Domain" "Business rules"
    catalogueRepo = component "Repository" "Data access"
}

orderService = container "Order Service" "Checkout" "ASP.NET Core Web API" {
    tags "Microservice" "Phase1" "CircuitBreaker" "TechDotNet"
    orderApi = component "API Layer" "HTTP endpoints"
    orderDomain = component "Order Domain" "Business rules"
    outboxPublisher = component "Outbox Publisher" "Event outbox"
    orderRepo = component "Repository" "Data access"
}

complaintService = container "Complaint Service" "Complaints" "ASP.NET Core Web API" {
    tags "Microservice" "Phase2" "TechDotNet"
    complaintApi = component "API Layer" "HTTP endpoints"
    complaintDomain = component "Complaint Domain" "Business rules"
    complaintRepo = component "Repository" "Data access"
}

franchiseService = container "Franchise Service" "Store ops" "ASP.NET Core Web API" {
    tags "Microservice" "Phase2" "TechDotNet"
    franchiseApi = component "API Layer" "HTTP endpoints"
    franchiseDomain = component "Franchise Domain" "Business rules"
    franchiseRepo = component "Repository" "Data access"
}

paymentService = container "Payment Service" "Payments" "ASP.NET Core Web API" {
    tags "Microservice" "Phase3" "CircuitBreaker" "TechDotNet"
    paymentApi = component "API Layer" "HTTP endpoints"
    paymentDomain = component "Payment Domain" "Business rules"
    paymentProviderAdapter = component "Payment Provider Adapter" "PSP adapter"
    paymentRepo = component "Repository" "Data access"
}

deliveryService = container "Delivery Service" "Dispatch" "Node.js + TypeScript API" {
    tags "Microservice" "Phase3" "CircuitBreaker" "TechNodeTs"
    deliveryApi = component "API Layer" "HTTP endpoints"
    deliveryDomain = component "Delivery Domain" "Business rules"
    mapsAdapter = component "Maps Adapter" "Maps adapter"
    deliveryRepo = component "Repository" "Data access"
}

notificationService = container "Notification Service" "Notifications" "ASP.NET Core Worker + API" {
    tags "Microservice" "Notification" "Phase3" "CircuitBreaker" "TechDotNet"
    notificationApi = component "API Layer" "HTTP endpoints"
    notificationDomain = component "Notification Domain" "Templates and routing"
    notificationRepo = component "Repository" "Data access"
    emailAdapter = component "Email Adapter" "Email adapter"
    smsAdapter = component "SMS Adapter" "SMS adapter"
    pushAdapter = component "Push Adapter" "Push adapter"
}

integrationHub = container "Integration Hub / ACL" "Integrations" "ASP.NET Core Worker / ACL" {
    tags "Microservice" "Integration" "Phase3" "CircuitBreaker" "TechDotNet"
    integrationApi = component "API Layer" "Ops endpoints"
    eventConsumers = component "Event Consumers" "Event handlers"
    integrationRepo = component "Repository" "State and outbox"
    dynamicsAdapter = component "Dynamics Adapter" "ERP adapter"
    sageAdapter = component "Sage Adapter" "Treasury adapter"
    mailboxAdapter = component "Mailbox Adapter" "Mailbox adapter"
    posAdapter = component "POS Adapter" "POS adapter"
    financeAdapter = component "Banking Adapter" "Banking adapter"
}

sagaOrchestrator = container "Saga Orchestrator" "Coordination" "MassTransit Saga State Machine" {
    tags "Microservice" "Orchestration" "Phase4" "TechDotNet"
    sagaApi = component "API Layer" "Ops endpoints"
    sagaManager = component "Saga Manager" "State machine"
    sagaRepo = component "Repository" "State store"
}
