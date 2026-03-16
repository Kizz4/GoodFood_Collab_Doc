# Vue d'ensemble – Good Food 3.0

## Contexte
Good Food est une franchise de restauration créée en 1992, présente en France, Belgique et Luxembourg, avec environ 150 restaurants. La vente en ligne représente une part majeure du chiffre d’affaires et la plateforme historique est devenue obsolète, peu maintenable et insuffisante pour absorber la croissance et les pics de charge.

## Enjeux de la refonte
- Moderniser une application legacy (infrastructure et code obsolètes, documentation insuffisante).
- Offrir une expérience Web et Mobile fluide et accessible.
- Assurer la haute disponibilité lors des pics de commandes.
- Permettre l’intégration avec les systèmes tiers (comptabilité, ERP, logistique, paiement).
- Garantir la migration des données sans impact sur la production.
- Aligner l’architecture avec une démarche de durabilité et une ouverture technologique (open source).

## Périmètre fonctionnel cible
La nouvelle solution couvre notamment :
- gestion des comptes clients et authentification,
- catalogue et menus,
- commande et panier,
- paiement en ligne,
- livraison (incluant planification),
- gestion des franchisés (promotions, fournisseurs, suivi),
- gestion des avis/réclamations,
- notifications (email, SMS, push),
- option d’aide à la décision.

## Principes d’architecture retenus
- Architecture en microservices pour découpler les domaines métier.
- API Gateway comme point d’entrée unique.
- Communication asynchrone via message broker pour les événements métier.
- Isolation des données par service.
- Observabilité centralisée (logs, supervision).
- Intégrations facilitées avec les systèmes externes.

## Parties prenantes principales
- Clients finaux,
- Restaurateurs / franchisés,
- Livreurs,
- Services Back‑Office (Comptabilité, Communication, Informatique),
- Prestataires externes (paiement, cartographie, notification, etc.).
