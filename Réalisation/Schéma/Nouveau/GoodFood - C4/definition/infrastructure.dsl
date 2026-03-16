apiGateway = container "API Gateway" "Point d'entrée unique" "YARP" {
    tags "Gateway"
}

serviceDiscovery = container "Service Discovery" "Registre des services" "Consul" {
    tags "Infra"
}

authService = container "Auth Service" "Authentification JWT" "Keycloak" {
    tags "Infra" "Security"
}

logsService = container "Logs (ELK)" "Logs centralisés" "Elasticsearch + Kibana" {
    tags "Infra" "Logging"
}

messageBroker = container "Message Broker" "Communication async" "RabbitMQ" {
    tags "Infra" "Messaging"
}

cacheRedis = container "Cache" "Cache distribué" "Redis" {
    tags "Infra" "Cache"
}
