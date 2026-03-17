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

    element "TechReact" {
        icon assets/react.png
        width 680
        height 440
    }

    element "TechReactNative" {
        icon assets/react-native.png
        width 680
        height 440
    }

    element "TechNodeTs" {
        icon assets/nodejs.png
        width 680
        height 440
    }

    element "TechYarp" {
        icon assets/yarp.png
        width 680
        height 440
    }

    element "TechAzureKubernetes" {
        icon assets/azure-kubernetes.png
        width 840
        height 520
    }

    element "TechDotNetPostgreSQL" {
        icon assets/dotnet-postgresql.png
        width 760
        height 460
    }

    element "TechNodeMongoDB" {
        icon assets/nodejs-mongodb.png
        width 760
        height 460
    }

    element "TechKeycloakPostgreSQL" {
        icon assets/keycloak-postgresql.png
        width 760
        height 460
    }

    element "TechKeycloak" {
        icon assets/keycloak.png
        width 680
        height 440
    }

    element "TechKubernetes" {
        icon assets/kubernetes.png
        width 680
        height 440
    }

    element "TechRabbitMQ" {
        icon assets/rabbitmq.png
        width 680
        height 440
    }

    element "TechRedis" {
        icon assets/redis.png
        width 680
        height 440
    }

    element "TechELK" {
        icon assets/elk.png
        width 680
        height 440
    }

    element "DbPostgreSQL" {
        icon assets/postgresql.png
        width 680
        height 440
    }

    element "DbMongoDB" {
        icon assets/mongodb.png
        width 680
        height 440
    }

    element "CircuitBreaker" {
        border Dashed
        stroke #ffd166
        strokeWidth 4
    }
}
