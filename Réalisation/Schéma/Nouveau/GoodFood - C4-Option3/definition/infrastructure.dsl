apiGateway = container "API Gateway" "Entry, routing, resilience" "YARP Reverse Proxy" {
    tags "Gateway" "CircuitBreaker" "TechYarp"
}

serviceDiscovery = container "Service Discovery" "Registry and health checks" "Kubernetes DNS + probes" {
    tags "Infra"
}

authPlatform = container "IAM Platform" "IAM and JWT" "Keycloak (OIDC/OAuth2)" {
    tags "Infra" "Security" "TechKeycloakPostgreSQL"
}

messageBroker = container "Message Broker" "Business events" "RabbitMQ" {
    tags "Infra" "Messaging" "TechRabbitMQ"
}

cacheRedis = container "Distributed Cache" "Read cache" "Redis" {
    tags "Infra" "Cache" "TechRedis"
}

logsService = container "Observability" "Logs and monitoring" "ELK Stack" {
    tags "Infra" "Logging" "TechELK"
}
