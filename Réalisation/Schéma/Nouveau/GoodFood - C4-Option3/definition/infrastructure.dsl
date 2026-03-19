apiGateway = container "API Gateway" "Routing" "YARP Reverse Proxy" {
    tags "Gateway" "CircuitBreaker" "TechYarp"
}

serviceDiscovery = container "Discovery" "Registry" "Kubernetes DNS + probes" {
    tags "Infra" "TechKubernetes"
}

authPlatform = container "IAM" "Identity" "Keycloak OIDC/OAuth2" {
    tags "Infra" "Security" "TechKeycloak"
}

messageBroker = container "Broker" "Events" "RabbitMQ" {
    tags "Infra" "Messaging" "TechRabbitMQ"
}

cacheRedis = container "Cache Redis" "Cache" "Redis" {
    tags "Infra" "Cache" "TechRedis"
}

logsService = container "Logs" "Observability" "ELK" {
    tags "Infra" "Logging" "TechELK"
}
