apiGateway = container "API Gateway" "Entrée, routage, résilience" "YARP" {
    tags "Gateway" "CircuitBreaker"
}

serviceDiscovery = container "Service Discovery" "Registre et health checks" "Consul" {
    tags "Infra"
}

authPlatform = container "Plateforme IAM" "IAM et JWT" "Keycloak" {
    tags "Infra" "Security" "DbPostgreSQL"
}

messageBroker = container "Message Broker" "Événements métier" "RabbitMQ + MassTransit" {
    tags "Infra" "Messaging"
}

cacheRedis = container "Cache Distribué" "Cache lecture" "Redis" {
    tags "Infra" "Cache"
}

logsService = container "Observabilité" "Logs et supervision" "ELK" {
    tags "Infra" "Logging"
}
