# Vue d'ensemble - Good Food AS-IS

## Objectif
Ce workspace documente l'architecture actuelle de l'application Good Food avant refonte.

## Caractéristiques principales de l'existant
- Monolithe web ASP.NET (C#) heberge sur Windows Server 2008 R2.
- Base de donnees unique SQL Server 2008.
- Synchronisation ERP par application C# WCF, executee quotidiennement a 05:00.
- Flux de tresorerie relies a BNB (paiement virtuel + EBICS vers Sage).
- Traitement des reclamations via formulaire web + email Microsoft 365.

## Points d'attention
- Obsolescence technique (OS, stack applicative, SGBD).
- Couplage fort et flux batch quotidiens non temps reel.
- Dependance aux prestataires (PWI/WIM) pour l'exploitation et certaines integrations.

## Vues disponibles
1. `ASIS_C1_Contexte`
2. `ASIS_C2_Containers`
3. `ASIS_C2_CommandePaiement`
4. `ASIS_C2_IntegrationERP`
5. `ASIS_C2_ComptaReclamations`
6. `ASIS_C3_WebMonolithe`
7. `ASIS_C3_WcfSync`
