# Vue d'ensemble – Good Food 3.0 Option 3

## Positionnement
Cette variante C4 représente la cible microservices finale de l'option 3.
La trajectoire n'est plus montrée par un modulith central dans le diagramme, mais par un code couleur qui indique l'ordre de construction des domaines.

## Corrections de cohérence appliquées
Par rapport au C4 cible d'origine, cette variante corrige plusieurs écarts :
- `Blazor WASM` a été remplacé par `React` pour l'application web afin de s'aligner sur `Plan_GoodFood_3.0.pdf`.
- l'app mobile ne se limite plus au livreur : une `App Mobile Client` est ajoutée pour respecter l'exigence explicite de Good Food.
- `Stripe` n'est plus exposé comme vérité d'architecture. Le modèle utilise un `Payment Provider Adapter` vers `BNB / PSP` afin de rester cohérent avec le contexte métier et avec un éventuel changement de fournisseur.
- le modèle décrit maintenant la cible microservices finale de l'option 3, tandis que la trajectoire reste lisible grâce aux couleurs de phase.
- la vue `C4` vide a été laissée hors usage ; les vues utiles sont C1, C2 et C3.

## Technologies retenues dans le modèle
- Front : React, React Native
- Gateway : YARP
- IAM : Keycloak
- Discovery : Consul
- Messaging : RabbitMQ + MassTransit cote .NET + AMQP cote Node.js
- Cache : Redis
- Observabilité : ELK
- Services métier : ASP.NET Core sauf livraison en Node.js / TypeScript
- Données : PostgreSQL sauf livraison en MongoDB
- Notifications : SendGrid, Twilio, Firebase
- Cartographie : Google Maps

## Légende des couleurs de phase
### Étape 1
- orange : noyau critique initial, d'abord construit dans le premier modulith ;
- domaines concernés : `Compte Client`, `Catalogue`, `Commande`.

### Étape 2
- vert : extension au modulith complet avant séparation ;
- domaines concernés : `Réclamations`, `Franchise`.

### Étape 3
- bleu : services extraits en priorité pendant la transition ;
- domaines concernés : `Paiement`, `Livraison`, `Notification`, `Integration Hub / ACL`.

### Étape 4
- violet : briques de distribution finale ;
- domaines concernés : `Orchestrateur Saga` et cible runtime microservices complète.

## Lecture de la trajectoire
- le diagramme montre l'état final microservices ;
- les couleurs ne représentent pas des environnements différents, mais l'ordre de construction recommandé ;
- les services colorés `Étape 1` et `Étape 2` rappellent qu'ils proviennent du coeur d'abord construit en modulith avant extraction finale.
