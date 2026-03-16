apiGateway = container "API Gateway" "Point d'entrée unique, routage, rate limiting, contrôle d'accès" "YARP" {
    tags "Gateway"
}

serviceDiscovery = container "Service Discovery" "Registre des services et health checks" "Consul" {
    tags "Infra"
}

authPlatform = container "Plateforme IAM" "Authentification, rôles et JWT" "Keycloak" {
    tags "Infra" "Security"
}

messageBroker = container "Message Broker" "Communication asynchrone et événements métier" "RabbitMQ + MassTransit" {
    tags "Infra" "Messaging"
}

cacheRedis = container "Cache Distribué" "Cache applicatif et accélération des lectures chaudes" "Redis" {
    tags "Infra" "Cache"
}

logsService = container "Observabilité" "Logs centralisés et supervision applicative" "ELK" {
    tags "Infra" "Logging"
}
