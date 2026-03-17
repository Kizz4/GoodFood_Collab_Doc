styles {
    element "Element" {
        fontSize 30
        strokeWidth 2
    }

    relationship "Relationship" {
        color #ffffff
        thickness 4
        fontSize 20
    }

    element "Person" {
        shape Person
        background #15344d
        color #ffffff
    }

    element "Utilisateur" {
        background #0f2d43
        color #ffffff
    }

    element "BackOffice" {
        background #2d4357
        color #ffffff
    }

    element "Software System" {
        background #1b557f
        color #ffffff
    }

    element "Externe" {
        background #3b4650
        color #ffffff
    }

    element "Container" {
        background #23608c
        color #ffffff
    }

    element "Web" {
        shape WebBrowser
    }

    element "Mobile" {
        shape MobileDevicePortrait
    }

    element "Gateway" {
        shape Hexagon
        background #1f7a5a
        color #ffffff
    }

    element "Modulith" {
        shape RoundedBox
        background #146c63
        color #ffffff
    }

    element "Microservice" {
        shape Hexagon
        background #2a6d95
        color #ffffff
    }

    element "Integration" {
        shape Hexagon
        background #1e6b62
        color #ffffff
    }

    element "Infra" {
        background #4f3568
        color #ffffff
    }

    element "Security" {
        background #1e6b43
        color #ffffff
    }

    element "Logging" {
        shape Cylinder
        background #5a3675
        color #ffffff
    }

    element "Messaging" {
        shape Pipe
        background #9b4e1c
        color #ffffff
    }

    element "Database" {
        shape Cylinder
        background #1b2a38
        color #ffffff
    }

    element "Cache" {
        shape Cylinder
        background #8a5c11
        color #ffffff
    }

    element "Notification" {
        background #b88d12
        color #ffffff
    }

    element "Orchestration" {
        background #8e2a22
        color #ffffff
    }

    element "Component" {
        background #355d82
        color #ffffff
    }

    element "Phase1" {
        background #8a4b12
        color #ffffff
        stroke #f6ddb0
        strokeWidth 4
    }

    element "Phase2" {
        background #14532d
        color #ffffff
        stroke #b7f3cf
        strokeWidth 4
    }

    element "Phase3" {
        background #0c4a6e
        color #ffffff
        stroke #b8e3ff
        strokeWidth 4
    }

    element "Phase4" {
        background #5b21b6
        color #ffffff
        stroke #ddd6fe
        strokeWidth 4
    }

    element "DbPostgreSQL" {
        icon assets/db-postgresql.svg
    }

    element "DbMongoDB" {
        icon assets/db-mongodb.svg
    }

    element "TechReact" {
        icon assets/react.png
    }

    element "TechReactNative" {
        icon assets/react-native.png
    }

    element "TechDotNet" {
        icon assets/dotnet.png
    }

    element "TechNodeTs" {
        icon assets/nodejs.png
    }

    element "TechYarp" {
        icon assets/yarp.png
    }

    element "TechKeycloak" {
        icon assets/keycloak.png
    }

    element "TechConsul" {
        icon assets/consul.png
    }

    element "TechRabbitMQ" {
        icon assets/rabbitmq.png
    }

    element "TechMassTransit" {
        icon assets/masstransit.png
    }

    element "TechRedis" {
        icon assets/redis.png
    }

    element "TechELK" {
        icon assets/elk.png
    }

    element "CircuitBreaker" {
        border Dashed
        stroke #ffd166
        strokeWidth 4
    }
}
