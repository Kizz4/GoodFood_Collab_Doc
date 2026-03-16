legacyWebApp = container "Application web de commande" "Monolithe e-commerce (commande, panier, promotions, compte client)" "ASP.NET (C#) sur IIS - Windows Server 2008 R2" {
    tags "Legacy" "Risk" "Weakness" "ToReplace"
}

backOfficePortal = container "Portail back-office" "Interface interne pour support/compta/communication" "ASP.NET (C#)" {
    tags "Legacy" "Weakness" "ToRefactor"
}
