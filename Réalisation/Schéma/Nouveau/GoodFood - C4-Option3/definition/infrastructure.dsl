apiGateway = container "API Gateway" "Routing" "YARP Reverse Proxy" {
    tags "Gateway" "CircuitBreaker" "TechYarp"
}

serviceDiscovery = container "Service Discovery" "Service registry" "Kubernetes DNS + probes" {
    tags "Infra" "TechKubernetes"
}

authPlatform = container "IAM Platform" "Identity" "Keycloak (OIDC/OAuth2)" {
    tags "Infra" "Security" "TechKeycloak"
}

messageBroker = container "Message Broker" "Events" "RabbitMQ" {
    tags "Infra" "Messaging" "TechRabbitMQ"
}

cacheRedis = container "Distributed Cache" "Cache" "Redis" {
    tags "Infra" "Cache" "TechRedis"
}

logsService = container "Observability" "Logs" "ELK Stack" {
    tags "Infra" "Logging" "TechELK"
}
