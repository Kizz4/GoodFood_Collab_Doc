dynamic goodFood.catalogueService "C3_Option3_CatalogBrowse" {
    title "C3 - Catalog Browse"
    customer -> goodFood.webApp "Browses store menus, local prices, and active promotions"
    goodFood.webApp -> goodFood.apiGateway "GET /catalog, /menus, /stores"
    goodFood.apiGateway -> goodFood.authPlatform "Validates token when signed in"
    goodFood.apiGateway -> goodFood.catalogueService.catalogueApi "Routes browse request"
    goodFood.catalogueService.catalogueApi -> goodFood.catalogueService.catalogueDomain "Loads resolved store catalog"
    goodFood.catalogueService.catalogueDomain -> goodFood.cacheRedis "Reads resolved store catalog view"
    goodFood.catalogueService.catalogueDomain -> goodFood.catalogueService.catalogueRepo "Loads resolved store view on cache miss"
    goodFood.catalogueService.catalogueRepo -> goodFood.catalogueDb "Reads resolved products, prices, promotions, and availability"
    autoLayout lr
}

dynamic goodFood.orderService "C3_Option3_CheckoutPayment" {
    title "C3 - Checkout to Online Payment Request"
    customer -> goodFood.webApp "Confirms cart and chooses online payment"
    goodFood.webApp -> goodFood.apiGateway "POST /orders"
    goodFood.apiGateway -> goodFood.authPlatform "Validates identity and roles"
    goodFood.apiGateway -> goodFood.orderService.orderApi "Routes order creation"
    goodFood.orderService.orderApi -> goodFood.orderService.orderDomain "Checks cart against the local checkout snapshot, slot, and payment mode"
    goodFood.orderService.orderDomain -> goodFood.orderService.orderRepo "Loads checkout reference data and creates the order"
    goodFood.orderService.orderRepo -> goodFood.orderDb "Stores the commercial snapshot and the order"
    goodFood.orderService.orderDomain -> goodFood.messageBroker "Publishes OrderPlaced"
    goodFood.sagaOrchestrator -> goodFood.messageBroker "Consumes OrderPlaced and starts coordination"
    goodFood.sagaOrchestrator -> goodFood.sagaDb "Stores saga state"
    goodFood.sagaOrchestrator -> goodFood.messageBroker "Publishes InitiatePayment"
    autoLayout lr
}

dynamic goodFood.orderService "C3_Option3_CheckoutInStorePayment" {
    title "C3 - Checkout and In-Store Payment"
    customer -> goodFood.webApp "Confirms cart and chooses pay in restaurant"
    goodFood.webApp -> goodFood.apiGateway "POST /orders"
    goodFood.apiGateway -> goodFood.authPlatform "Validates identity and roles"
    goodFood.apiGateway -> goodFood.orderService.orderApi "Routes order creation"
    goodFood.orderService.orderApi -> goodFood.orderService.orderDomain "Checks cart against the local checkout snapshot, slot, and payment mode"
    goodFood.orderService.orderDomain -> goodFood.orderService.orderRepo "Creates order pending in-store payment from local reference data"
    goodFood.orderService.orderRepo -> goodFood.orderDb "Stores order, snapshot, and pending payment status"
    goodFood.orderService.orderDomain -> goodFood.messageBroker "Publishes OrderPlacedForInStorePayment"
    goodFood.integrationHub -> goodFood.messageBroker "Consumes store payment sync request"
    goodFood.integrationHub -> goodFood.integrationDb "Stores TPE sync state"
    goodFood.integrationHub -> tpSystem "Synchronizes TPE payment status"
    goodFood.integrationHub -> goodFood.messageBroker "Publishes InStorePaymentAuthorized or InStorePaymentFailed"
    goodFood.orderService.orderDomain -> goodFood.messageBroker "Consumes in-store payment result"
    goodFood.orderService.orderDomain -> goodFood.orderService.orderRepo "Updates order payment status"
    goodFood.orderService.orderRepo -> goodFood.orderDb "Stores updated payment status"
    autoLayout lr
}

dynamic goodFood.paymentService "C3_Option3_PaymentExecution" {
    title "C3 - Online Payment Execution"
    goodFood.sagaOrchestrator -> goodFood.messageBroker "Publishes InitiatePayment"
    goodFood.paymentService.paymentEventConsumer -> goodFood.messageBroker "Consumes InitiatePayment"
    goodFood.paymentService.paymentEventConsumer -> goodFood.paymentService.paymentDomain "Starts payment processing"
    goodFood.paymentService.paymentDomain -> goodFood.paymentService.paymentProviderAdapter "Calls the PSP"
    goodFood.paymentService.paymentProviderAdapter -> bnbPayment "Authorizes or rejects payment"
    goodFood.paymentService.paymentDomain -> goodFood.paymentService.paymentRepo "Records the result"
    goodFood.paymentService.paymentRepo -> goodFood.paymentDb "Stores authorization"
    goodFood.paymentService.paymentDomain -> goodFood.messageBroker "Publishes PaymentAuthorized or PaymentFailed"
    autoLayout lr
}

dynamic goodFood.deliveryService "C3_Option3_PreparationDelivery" {
    title "C3 - Prep, Dispatch, and Launch"
    franchiseManager -> goodFood.webApp "Accepts the order and starts preparation"
    goodFood.webApp -> goodFood.apiGateway "PATCH /preparation/orders/{id}"
    goodFood.apiGateway -> goodFood.preparationService.preparationApi "Routes preparation update"
    goodFood.preparationService.preparationApi -> goodFood.preparationService.preparationDomain "Updates accepted, preparing, or ready status"
    goodFood.preparationService.preparationDomain -> goodFood.preparationService.preparationRepo "Persists preparation workflow"
    goodFood.preparationService.preparationRepo -> goodFood.preparationDb "Stores preparation state"
    goodFood.preparationService.preparationDomain -> goodFood.messageBroker "Publishes OrderReadyForDelivery"
    goodFood.deliveryService.deliveryEventConsumer -> goodFood.messageBroker "Consumes OrderReadyForDelivery"
    goodFood.deliveryService.deliveryEventConsumer -> goodFood.deliveryService.deliveryDomain "Calculates assignment and slot"
    goodFood.deliveryService.deliveryDomain -> goodFood.deliveryService.mapsAdapter "Calculates ETA and route"
    goodFood.deliveryService.mapsAdapter -> googleMapsApi "Gets distance and ETA"
    goodFood.deliveryService.deliveryDomain -> goodFood.deliveryService.deliveryRepo "Creates delivery mission"
    goodFood.deliveryService.deliveryRepo -> goodFood.deliveryDb "Stores route and tracking"
    goodFood.deliveryService.deliveryDomain -> goodFood.messageBroker "Publishes DeliveryPlanned"
    goodFood.notificationService -> goodFood.messageBroker "Consumes DeliveryPlanned"
    goodFood.notificationService -> firebaseFcm "Pushes updates to customer and courier"
    autoLayout lr
}

dynamic goodFood.deliveryService "C3_Option3_DeliveryTracking" {
    title "C3 - Delivery Tracking"
    courier -> goodFood.mobileCourierApp "Updates status, position, and proof of delivery"
    goodFood.mobileCourierApp -> goodFood.apiGateway "PATCH /delivery/{id}/status"
    goodFood.apiGateway -> goodFood.authPlatform "Validates courier token"
    goodFood.apiGateway -> goodFood.deliveryService.deliveryApi "Routes field update"
    goodFood.deliveryService.deliveryApi -> goodFood.deliveryService.deliveryDomain "Processes delivery event"
    goodFood.deliveryService.deliveryDomain -> goodFood.deliveryService.deliveryRepo "Stores position, status, and proof"
    goodFood.deliveryService.deliveryRepo -> goodFood.deliveryDb "Stores tracking and proof"
    goodFood.deliveryService.deliveryDomain -> goodFood.deliveryService.mapsAdapter "Recalculates ETA when needed"
    goodFood.deliveryService.mapsAdapter -> googleMapsApi "Gets updated ETA"
    goodFood.deliveryService.deliveryDomain -> goodFood.messageBroker "Publishes DeliveryUpdated or Delivered"
    goodFood.notificationService -> goodFood.messageBroker "Consumes DeliveryUpdated or Delivered"
    goodFood.notificationService -> firebaseFcm "Sends push update"
    customer -> goodFood.mobileClientApp "Views tracking and ETA"
    goodFood.mobileClientApp -> goodFood.apiGateway "GET /delivery/{id}"
    goodFood.apiGateway -> goodFood.deliveryService.deliveryApi "Routes tracking read"
    goodFood.deliveryService.deliveryApi -> goodFood.deliveryService.deliveryDomain "Loads current state"
    goodFood.deliveryService.deliveryDomain -> goodFood.deliveryService.deliveryRepo "Reads mission and ETA"
    autoLayout lr
}

dynamic goodFood.complaintService "C3_Option3_ComplaintSupport" {
    title "C3 - Complaint and Support"
    customer -> goodFood.webApp "Submits a complaint or order issue"
    goodFood.webApp -> goodFood.apiGateway "POST /complaints"
    goodFood.apiGateway -> goodFood.complaintService.complaintApi "Routes complaint creation"
    goodFood.complaintService.complaintApi -> goodFood.complaintService.complaintDomain "Qualifies the request"
    goodFood.complaintService.complaintDomain -> goodFood.complaintService.complaintRepo "Creates the case"
    goodFood.complaintService.complaintRepo -> goodFood.complaintDb "Stores the complaint"
    goodFood.complaintService.complaintDomain -> goodFood.messageBroker "Publishes ComplaintCreated"
    goodFood.notificationService -> goodFood.messageBroker "Consumes ComplaintCreated"
    goodFood.notificationService -> sendGridApi "Sends confirmation email"
    goodFood.integrationHub -> goodFood.messageBroker "Consumes ComplaintCreated"
    goodFood.integrationHub -> microsoft365 "Creates alert or ticket"
    customerCareTeam -> goodFood.webApp "Tracks and handles the case"
    goodFood.webApp -> goodFood.apiGateway "GET /complaints/{id}"
    goodFood.apiGateway -> goodFood.complaintService.complaintApi "Routes case lookup"
    autoLayout lr
}

dynamic goodFood.localAssortmentService "C3_Option3_LocalAssortmentSync" {
    title "C3 - Local Assortment and Promotion Sync"
    franchiseManager -> goodFood.webApp "Updates local menu, stock, price, or promotion rule"
    goodFood.webApp -> goodFood.apiGateway "PUT /stores/{id}/assortment"
    goodFood.apiGateway -> goodFood.localAssortmentService.localAssortmentApi "Routes local assortment update"
    goodFood.localAssortmentService.localAssortmentApi -> goodFood.localAssortmentService.localAssortmentDomain "Validates scope, priority, and validity dates"
    goodFood.localAssortmentService.localAssortmentDomain -> goodFood.localAssortmentService.localAssortmentRepo "Saves local assortment and promotion rules"
    goodFood.localAssortmentService.localAssortmentRepo -> goodFood.localAssortmentDb "Stores local assortment and promotion rules"
    goodFood.localAssortmentService.localAssortmentDomain -> goodFood.messageBroker "Publishes LocalAssortmentChanged"
    goodFood.catalogueService -> goodFood.messageBroker "Consumes product, override, and promotion events"
    goodFood.catalogueService -> goodFood.catalogueDb "Stores resolved store catalog views"
    goodFood.catalogueService -> goodFood.cacheRedis "Invalidates and reloads resolved store catalog cache"
    goodFood.catalogueService -> goodFood.messageBroker "Publishes ResolvedCatalogChanged"
    goodFood.orderService -> goodFood.messageBroker "Consumes ResolvedCatalogChanged"
    goodFood.orderService -> goodFood.orderDb "Stores updated checkout reference data"
    goodFood.integrationHub -> goodFood.messageBroker "Consumes local assortment sync events"
    goodFood.integrationHub -> dynamics365 "Syncs ERP / CRM"
    goodFood.integrationHub -> tpSystem "Syncs TPE / store side"
    autoLayout lr
}

dynamic goodFood.supplierService "C3_Option3_SupplierSync" {
    title "C3 - Supplier and Replenishment Sync"
    franchiseManager -> goodFood.webApp "Updates a supplier, sourcing rule, or replenishment constraint"
    goodFood.webApp -> goodFood.apiGateway "PUT /stores/{id}/suppliers"
    goodFood.apiGateway -> goodFood.supplierService.supplierApi "Routes supplier update"
    goodFood.supplierService.supplierApi -> goodFood.supplierService.supplierDomain "Validates sourcing scope, lead time, and local constraints"
    goodFood.supplierService.supplierDomain -> goodFood.supplierService.supplierRepo "Saves supplier and replenishment rules"
    goodFood.supplierService.supplierRepo -> goodFood.supplierDb "Stores suppliers and sourcing rules"
    goodFood.supplierService.supplierDomain -> goodFood.messageBroker "Publishes SupplierRuleChanged"
    goodFood.integrationHub -> goodFood.messageBroker "Consumes supplier sync events"
    goodFood.integrationHub -> dynamics365 "Syncs supplier master data"
    goodFood.integrationHub -> microsoft365 "Notifies store and purchasing teams"
    autoLayout lr
}
