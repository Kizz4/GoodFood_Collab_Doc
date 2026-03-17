customerService = container "Customer Service" "Profiles and addresses" "ASP.NET Core Web API" {
    tags "Microservice" "Phase1" "TechDotNet"
    customerApi = component "API Layer" "Customer API"
    customerDomain = component "Customer Domain" "Profiles, addresses, preferences"
    customerRepo = component "Repository" "Customer data access"
}

catalogueService = container "Catalog Service" "Menus and availability" "ASP.NET Core Web API" {
    tags "Microservice" "Phase1" "TechDotNet"
    catalogueApi = component "API Layer" "Catalog API"
    catalogueDomain = component "Catalog Domain" "Menus, products, availability"
    catalogueRepo = component "Repository" "Catalog data access"
}

orderService = container "Order Service" "Cart and checkout" "ASP.NET Core Web API" {
    tags "Microservice" "Phase1" "CircuitBreaker" "TechDotNet"
    orderApi = component "API Layer" "Order API"
    orderDomain = component "Order Domain" "Cart, order, promotions, status"
    outboxPublisher = component "Outbox Publisher" "Reliable business event publishing"
    orderRepo = component "Repository" "Order data access"
}

complaintService = container "Complaint Service" "Incidents and reviews" "ASP.NET Core Web API" {
    tags "Microservice" "Phase2" "TechDotNet"
    complaintApi = component "API Layer" "Complaint API"
    complaintDomain = component "Complaint Domain" "Incidents, reviews, workflow"
    complaintRepo = component "Repository" "Complaint data access"
}

franchiseService = container "Franchise Service" "Franchise ops" "ASP.NET Core Web API" {
    tags "Microservice" "Phase2" "TechDotNet"
    franchiseApi = component "API Layer" "Franchise API"
    franchiseDomain = component "Franchise Domain" "Promotions, suppliers, preparation"
    franchiseRepo = component "Repository" "Franchise data access"
}

paymentService = container "Payment Service" "Payments" "ASP.NET Core Web API" {
    tags "Microservice" "Phase3" "CircuitBreaker" "TechDotNet"
    paymentApi = component "API Layer" "Payment API"
    paymentDomain = component "Payment Domain" "Payment intent, validation, refund"
    paymentProviderAdapter = component "Payment Provider Adapter" "Adapter to BNB / PSP"
    paymentRepo = component "Repository" "Payment data access"
}

deliveryService = container "Delivery Service" "Dispatch and tracking" "Node.js + TypeScript API" {
    tags "Microservice" "Phase3" "CircuitBreaker" "TechNodeTs"
    deliveryApi = component "API Layer" "Delivery API"
    deliveryDomain = component "Delivery Domain" "Dispatch, tracking, incidents, ETA"
    mapsAdapter = component "Maps Adapter" "Google Maps integration"
    deliveryRepo = component "Repository" "Delivery data access"
}

notificationService = container "Notification Service" "Email, SMS, push" "ASP.NET Core Worker + API" {
    tags "Microservice" "Notification" "Phase3" "CircuitBreaker" "TechDotNet"
    notificationApi = component "API Layer" "Endpoints and admin"
    notificationDomain = component "Notification Domain" "Templates, preferences, routing"
    notificationRepo = component "Repository" "Notification data access"
    emailAdapter = component "Email Adapter" "SendGrid delivery"
    smsAdapter = component "SMS Adapter" "Twilio delivery"
    pushAdapter = component "Push Adapter" "Firebase delivery"
}

integrationHub = container "Integration Hub / ACL" "Back-office integrations" "ASP.NET Core Worker / ACL" {
    tags "Microservice" "Integration" "Phase3" "CircuitBreaker" "TechDotNet"
    integrationApi = component "API Layer" "Ops admin and replay"
    eventConsumers = component "Event Consumers" "Consume business events"
    integrationRepo = component "Repository" "Integration traces and outbox"
    dynamicsAdapter = component "Dynamics Adapter" "ERP sync"
    sageAdapter = component "Sage Adapter" "Treasury journal sync"
    mailboxAdapter = component "Mailbox Adapter" "Shared mailbox sync"
    posAdapter = component "POS Adapter" "POS and payment terminal sync"
    financeAdapter = component "Banking Adapter" "BNB / EBICS integration"
}

sagaOrchestrator = container "Saga Orchestrator" "Distributed coordination" "MassTransit Saga State Machine" {
    tags "Microservice" "Orchestration" "Phase4" "TechMassTransit"
    sagaApi = component "API Layer" "Monitoring and ops"
    sagaManager = component "Saga Manager" "State machine and compensations"
    sagaRepo = component "Repository" "Saga state persistence"
}
