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

    element "Database" {
        shape Cylinder
        background #1b2a38
        color #ffffff
    }

    element "Component" {
        background #355d82
        color #ffffff
    }

    element "Infra" {
        background #4f3568
        color #ffffff
    }

    element "Integration" {
        shape Hexagon
        background #9b4e1c
        color #ffffff
    }

    element "Legacy" {
        background #7a2c24
        color #ffffff
    }

    element "Risk" {
        stroke #ef9a9a
        strokeWidth 4
    }

    element "Weakness" {
        background #8e2a22
        color #ffffff
        stroke #ffd0cc
    }

    element "Strength" {
        background #1e6b43
        color #ffffff
        stroke #b7f3cf
    }

    element "ToRefactor" {
        background #8a5c11
        color #ffffff
        stroke #f6ddb0
    }

    element "ToReplace" {
        background #5a1f18
        color #ffffff
        stroke #ffd0cc
        border Dashed
        strokeWidth 4
    }
}
