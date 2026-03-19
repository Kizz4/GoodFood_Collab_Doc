# Schéma physique cible Option 3

## Intention graphique
- composition rapprochee du drawio AS-IS : zones bien decoupees, legende explicite et hierarchie de lecture identique ;
- fond noir conserve pour rester coherent avec les autres schemas cibles ;
- le blanc est reintroduit sur les legendes, notes, badges et pictos pour redonner du contraste ;
- les cartes metier principales restent sombres pour garder un coeur visuel noir ;
- services compacts avec badge base de donnees integre pour alleger les relations evidentes.

## Organisation
- gauche : canaux exposes et populations utilisatrices ;
- haut centre : edge Azure, gateway, IAM, service discovery ;
- centre : runtime AKS final avec services metier ;
- bas centre : broker, cache, observabilite et IAM data ;
- droite : SI externe, partenaires et legende.

## Simplifications volontairees
- les bases metier ne sont plus sorties en blocs separes : elles sont signalees directement dans les cartes de service ;
- seules les integrations et dependances critiques sont reliees ;
- les personas restent contextuels et ne surchargent plus la lecture avec des flux secondaires ;
- les appels synchrones transverses entre services metier sont retires du schema principal ; `Order` ne pointe plus vers `Catalog` et la coordination `Saga` ne pointe pas vers les autres services.

## Code couleur des etapes
- orange : noyau critique du premier modulith (`Customer`, `Catalog`, `Order`) ;
- vert : domaines ajoutes pour obtenir le modulith complet (`Complaint`, `Local Assortment`, `Supplier`, `Preparation`) ;
- bleu : services extraits en priorite (`Payment`, `Delivery`, `Notification`, `Integration Hub / ACL`) ;
- violet : distribution finale et orchestration (`Saga Orchestrator`).

## Signaux visuels
- bordure pointillee : circuit breaker / resilience ;
- badge `PG` ou `Mongo` : type de stockage principal du service ;
- zones colorees : meme logique de regroupement visuel que le drawio AS-IS ;
- flux bleus : API et appels HTTP ;
- flux orange : evenements asynchrones via RabbitMQ ;
- flux verts : integrations SI ;
- flux rouges : paiement ;
- flux violets : notifications et canaux sortants.
