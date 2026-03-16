# 1. Architecture microservices pour Good Food 3.0

## Status
Accepted

## Context
Good Food refond sa plateforme de commande en ligne. Le contexte impose :
- forte croissance et pics de charge (80% du CA en ligne, 1M de repas livrés en 2023),
- application legacy obsolète, peu maintenable et non documentée,
- besoin d’une application mobile et d’une interface franchisés,
- exigences d’intégration avec d’autres systèmes (comptabilité, logistique, ERP),
- disponibilité élevée lors des pics de commandes,
- migration des données sans impact production,
- recommandations d’ouvrir l’architecture à des technologies open source,
- organisation évolutive avec un nouveau pôle informatique interne.

## Decision
Adopter une architecture microservices avec :
- API Gateway comme point d’entrée unique (sécurité, routage, gouvernance),
- services métiers découplés (commande, paiement, livraison, catalogue, communication, notification, etc.),
- communication asynchrone via message broker pour les événements métier,
- service discovery pour localiser dynamiquement les services,
- bases de données séparées par service (ownership clair).

## Consequences
- Scalabilité et disponibilité améliorées (montée en charge sur les services critiques).
- Meilleure maintenabilité : chaque domaine évolue indépendamment.
- Intégration facilitée avec l’écosystème existant (ERP, compta, paiement, logistique).
- Coûts et complexité opérationnelle plus élevés (observabilité, orchestration, CI/CD).
- Nécessité d’une gouvernance stricte (contrats d’API, versioning, monitoring).

## Alternatives considérées
- Monolithe : simple à déployer mais peu évolutif et difficile à maintenir à long terme.
- Monolithe modulaire : meilleure organisation interne mais moins flexible pour la scalabilité ciblée.
- Microservices (choisi) : répond aux exigences de disponibilité, évolutivité et intégration.
