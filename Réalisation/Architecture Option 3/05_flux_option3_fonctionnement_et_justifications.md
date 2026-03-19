# Flux Option 3 - fonctionnement et justifications

## 1. Objet du document

Ce document explique l'ensemble des flux representes dans les schemas de l'option 3, principalement :
- la vue `C2` pour les relations entre conteneurs ;
- les vues dynamiques `C3` pour les parcours metier ;
- les vues `C4` pour l'organisation interne des services.

L'objectif est double :
- expliquer ce que fait chaque flux, et dans quel ordre ;
- justifier pourquoi le flux a ete modele de cette maniere.

## 2. Principes transverses qui structurent tous les flux

Avant de regarder les parcours un par un, il faut rappeler les regles de modelisation retenues.

### 2.1 Point d'entree unique

Tous les canaux (`Web App`, `Customer App`, `Courier App`) passent par `API Gateway`.

Pourquoi :
- centraliser le routage ;
- appliquer une politique homogene d'authentification et d'autorisation ;
- eviter d'exposer directement les services metier.

### 2.2 Services metier au meme niveau

Les services sont dessines sur la meme ligne logique : aucun service metier n'est presente comme "au-dessus" d'un autre.

Pourquoi :
- montrer un decouplage reel entre les capacites ;
- eviter de laisser croire que `Order`, `Catalog`, `Payment`, `Delivery` ou les services franchise sont dans une relation hierarchique ;
- rappeler que l'orchestration passe par des evenements et non par une chaine d'appels point a point.

### 2.3 Pas de relation synchrone `Order -> Catalog`

Le schema ne montre plus de dependance synchrone entre `Order Service` et `Catalog Service`.

Choix retenu :
- `Catalog Service` publie une vue commerciale resolue ;
- `Order Service` consomme cette information de facon asynchrone et maintient ses references locales de checkout ;
- au moment de la commande, `Order Service` valide contre sa copie locale.

Pourquoi :
- reduire le couplage temporel entre prise de commande et consultation du catalogue ;
- eviter qu'une indisponibilite de `Catalog Service` bloque le checkout ;
- garder une trace stable du contexte commercial au moment de la commande.

### 2.4 Pas de fleches `Saga -> services`

La saga reste reliee a `RabbitMQ` et a sa propre base, mais pas directement aux autres services.

Choix retenu :
- les services publient et consomment des evenements via le broker ;
- la saga ecoute les evenements utiles, garde son etat, puis republie des commandes ou evenements.

Pourquoi :
- conserver une lecture claire de l'orchestration ;
- eviter de redonner l'impression d'un pilotage synchrone central ;
- rester coherent avec la regle "service vers broker" deja appliquee ailleurs.

### 2.5 Domaine franchise decoupe

Le bloc `Franchise Service` a ete remplace par trois services distincts :
- `Local Assortment Service`
- `Supplier Service`
- `Preparation Service`

Pourquoi :
- le besoin franchise du contexte est large ;
- un service technique unique etait trop flou ;
- le decoupage par capacite metier est plus defendable qu'un service fourre-tout.

### 2.6 Structure interne des services

Les services suivent en general le meme schema interne :
- `Controller` pour l'entree HTTP ;
- `Consumer` pour l'entree asynchrone ;
- `Domain` pour les regles metier ;
- `Repository` pour la persistence ;
- `Adapter` quand il faut parler a un systeme externe.

Pourquoi :
- clarifier les responsabilites ;
- rendre la lecture `C4` homogene ;
- montrer ou se trouvent les points de couplage externe.

## 3. Flux 1 - Consultation du catalogue

Vue concernee :
- `C3_Option3_CatalogBrowse`

### Fonctionnement

1. Le client consulte le site ou l'application.
2. Le front appelle `API Gateway` avec une requete de lecture (`/catalog`, `/menus`, `/stores`).
3. `API Gateway` verifie eventuellement le token via `IAM`.
4. La requete est routee vers `Catalog Service`.
5. Le `Controller` delegue au `Domain`.
6. Le `Domain` essaie d'abord de lire la vue resolue en cache `Redis`.
7. En cas de cache miss, il charge la vue resolue depuis `Catalog DB`.
8. Le resultat renvoye au client est deja compose par magasin, prix, disponibilite et promotions applicables.

### Justification

Ce flux est volontairement optimise pour la lecture.

Pourquoi :
- la consultation catalogue est frequente et sensible a la latence ;
- il vaut mieux servir une vue deja resolue qu'executer des recompositions complexes a chaque lecture ;
- les regles locales et promotions doivent impacter le catalogue visible sans multiplier les appels synchrones pendant la navigation.

## 4. Flux 2 - Synchronisation assortiment local et promotions

Vue concernee :
- `C3_Option3_LocalAssortmentSync`

### Fonctionnement

1. Le responsable restaurant modifie un menu local, un stock, un prix ou une promotion.
2. Le front appelle `API Gateway`.
3. `API Gateway` route la requete vers `Local Assortment Service`.
4. Le `Domain` valide le scope, la priorite, les dates d'effet et les regles locales.
5. Les regles sont enregistrees dans `Local Assortment DB`.
6. Le service publie l'evenement `LocalAssortmentChanged` avec le payload utile pour identifier le magasin, l'element impacte, le type de changement et les bornes temporelles de validite.
7. `Catalog Service` consomme cet evenement et recalcule uniquement les projections impactees.
8. `Catalog Service` met a jour dans `Catalog DB` une vue resolue par restaurant, typiquement dans une table dediee du type `resolved_store_catalog` ou `store_product_view`.
9. Cette vue resolue ne cree pas un nouveau produit metier : elle materialise une projection commerciale du couple `restaurant + produit`, avec par exemple `base_price`, `local_price_override`, `effective_price`, `promotion_id`, `availability`, `valid_from`, `valid_to`.
10. En cas de fin de promotion, `Catalog Service` ne cree pas une nouvelle vue historique : il recalcule la projection courante et ecrase la ligne concernee pour faire revenir le prix effectif a la bonne valeur.
11. `Catalog Service` invalide ensuite `Redis`, republie `ResolvedCatalogChanged`, puis `Order Service` consomme cette mise a jour pour rafraichir ses references locales de checkout.
12. `Integration Hub` consomme aussi ces evenements pour synchroniser les SI externes utiles.

### Point d'attention important

Dans ce flux, il faut bien distinguer trois niveaux de donnees :
- `Local Assortment DB` contient la verite des regles locales, promotions et surcharges ;
- `Catalog DB` contient la projection resolue lue par le client ;
- `Order DB` contient la copie locale minimale utile au checkout.

Cela signifie que la duplication existe, mais sous forme de projection et non de duplication metier du produit.
Le produit de base reste conceptuellement unique.
En revanche, sa vue commerciale peut varier d'un restaurant a l'autre et doit donc etre materialisee par restaurant pour garantir :
- des lectures rapides ;
- l'absence d'appel synchrone `Order -> Catalog` au moment critique ;
- un comportement stable quand une promotion commence ou se termine.

### Justification

Ce flux est central car il remplace l'ancien reflexe "appeler le domaine franchise en direct depuis le catalogue ou la commande".

Pourquoi :
- les franchises impactent bien le catalogue, mais plutot en amont par publication d'evenements ;
- `Catalog Service` reste proprietaire de la vue exposee au client et la persiste comme read model resolu ;
- `Order Service` reste autonome au moment du checkout grace a sa copie locale ;
- la projection par restaurant assume une denormalisation technique maitrisee pour servir des prix et promotions differents selon le point de vente ;
- la synchronisation externe est isolee dans `Integration Hub` pour ne pas polluer le service metier.

## 5. Flux 3 - Synchronisation fournisseurs et approvisionnement

Vue concernee :
- `C3_Option3_SupplierSync`

### Fonctionnement

1. Le responsable restaurant met a jour un fournisseur, une contrainte d'approvisionnement ou une regle de sourcing.
2. Le front appelle `API Gateway`.
3. La requete est routee vers `Supplier Service`.
4. Le `Domain` verifie le perimetre, les delais et les contraintes locales.
5. Les donnees sont stockees dans `Supplier DB`.
6. Le service publie `SupplierRuleChanged`.
7. `Integration Hub` consomme l'evenement et propage l'information vers `Dynamics 365` et les canaux de notification internes utiles.

### Justification

Ce flux existe pour sortir la gestion fournisseurs du faux bloc franchise unique.

Pourquoi :
- les fournisseurs n'ont pas la meme logique que le catalogue client ;
- ce sujet est davantage lie a l'exploitation magasin et aux integrations ERP ;
- le decoupage facilite une evolution future sans toucher `Catalog Service` ni `Order Service`.

## 6. Flux 4 - Checkout avec paiement en ligne

Vue concernee :
- `C3_Option3_CheckoutPayment`

### Fonctionnement

1. Le client confirme son panier et choisit le paiement en ligne.
2. Le front appelle `API Gateway` avec `POST /orders`.
3. `API Gateway` verifie l'identite et les roles via `IAM`.
4. La requete est routee vers `Order Service`.
5. Le `Domain` verifie le panier, le slot et le mode de paiement contre la reference commerciale locale.
6. Le `Repository` stocke la commande et le snapshot commercial associe dans `Order DB`.
7. `Order Service` publie `OrderPlaced`.
8. `Saga Orchestrator` consomme l'evenement, stocke son etat dans `Saga DB`, puis publie `InitiatePayment` avec le canal `online`.

### Justification

Ce flux porte l'un des arbitrages les plus importants du schema.

Pourquoi :
- la commande doit pouvoir etre enregistree sans dependre d'un aller-retour synchrone vers `Catalog Service` ;
- le snapshot commercial permet de tracer exactement ce qui a ete valide ;
- la saga orchestree est utile car plusieurs etapes asynchrones peuvent suivre : paiement, preparation, livraison, notifications.

## 7. Flux 5 - Execution du paiement

Vue concernee :
- `C3_Option3_PaymentExecution`

### Fonctionnement

1. `Payment Service` consomme `InitiatePayment` depuis le broker.
2. Son `Consumer` declenche la logique metier de paiement.
3. Le `Domain` appelle l'adapter de paiement en ligne.
4. L'adapter dialogue avec `BNB / PSP`.
5. Le resultat est persiste dans `Payment DB`.
6. Le service publie `PaymentAuthorized` ou `PaymentFailed`.

### Justification

Le paiement en ligne reste un domaine isole.

Pourquoi :
- c'est un flux critique, sensible et auditable ;
- il depend d'un prestataire externe avec ses propres contraintes ;
- il faut separer clairement les flux financiers du reste des traitements metier.

## 8. Flux 6 - Preparation, dispatch et lancement de la livraison

Vue concernee :
- `C3_Option3_PreparationDelivery`

### Fonctionnement

1. Le responsable restaurant accepte la commande et fait avancer la preparation.
2. Le front appelle `API Gateway` sur le perimetre preparation.
3. `Preparation Service` met a jour l'etat de preparation dans `Preparation DB`.
4. Quand la commande est prete, le service publie `OrderReadyForDelivery`.
5. `Delivery Service` consomme l'evenement.
6. Il calcule l'affectation, le slot, l'ETA et l'itineraire en s'appuyant sur `Google Maps`.
7. La mission de livraison est stockee dans `Delivery DB`.
8. Le service publie `DeliveryPlanned`.
9. `Notification Service` consomme l'evenement et envoie les notifications utiles.

### Justification

Ce flux justifie directement le decoupage du domaine franchise.

Pourquoi :
- la preparation est une capacite magasin a part entiere ;
- elle ne doit pas etre confondue avec la prise de commande ni avec la livraison ;
- `Delivery Service` ne commence son travail qu'une fois la commande prete ;
- la livraison garde ainsi un perimetre centre sur la mission terrain, le tracking et l'ETA.

## 9. Flux 7 - Suivi de livraison

Vue concernee :
- `C3_Option3_DeliveryTracking`

### Fonctionnement

1. Le livreur met a jour son statut, sa position ou la preuve de livraison depuis l'application mobile.
2. La requete passe par `API Gateway`, avec validation du token livreur.
3. `Delivery Service` traite l'evenement terrain.
4. Les donnees de tracking sont stockees dans `Delivery DB` (`MongoDB`).
5. Le service peut recalculer un ETA via `Google Maps`.
6. Il publie `DeliveryUpdated` ou `Delivered`.
7. `Notification Service` consomme ces evenements et pousse les mises a jour.
8. En parallele, le client peut lire l'etat courant de sa livraison via l'application.

### Justification

Le tracking est traite separement car c'est un domaine tres dynamique.

Pourquoi :
- il y a beaucoup d'ecritures courtes et frequentes ;
- la structure des donnees est plus souple qu'un flux transactionnel classique ;
- cela justifie le choix `Node.js + TypeScript + MongoDB` pour `Delivery Service`.

## 10. Flux 8 - Reclamations et support

Vue concernee :
- `C3_Option3_ComplaintSupport`

### Fonctionnement

1. Le client soumet une reclamation ou un incident.
2. `API Gateway` route la requete vers `Complaint Service`.
3. Le `Domain` qualifie la demande.
4. Le dossier est stocke dans `Complaint DB`.
5. Le service publie `ComplaintCreated`.
6. `Notification Service` consomme l'evenement pour envoyer un accuse ou une confirmation.
7. `Integration Hub` consomme aussi l'evenement pour ouvrir une alerte ou un ticket dans les outils externes.
8. Les equipes support consultent ensuite le dossier via le back-office.

### Justification

Ce flux montre comment une capacite metier reste autonome tout en declenchant des effets de bord.

Pourquoi :
- la reclamation a son propre cycle de vie ;
- les notifications et integrations ne doivent pas etre codees directement dans le service de plainte ;
- l'asynchrone permet de garder le service principal simple et robuste.

## 11. Place de la vue C2 dans la lecture des flux

La vue `C2` ne raconte pas les etapes detaillees. Elle montre plutot les dependances permanentes entre conteneurs.

Elle sert a rappeler :
- quels services sont exposes via `API Gateway` ;
- quels services parlent au broker ;
- quelles bases appartiennent a quels services ;
- quels services appellent des systemes externes ;
- que la saga reste connectee au broker et a `Saga DB`, sans relation point a point vers les autres services.

## 12. Place de la vue C4 dans la lecture des flux

La vue `C4` sert a expliquer comment chaque service implemente son role.

Elle permet de defendre :
- la separation entre entree HTTP et entree evenementielle ;
- la place exacte des regles metier ;
- l'isolement des adapters externes ;
- la maitrise de l'acces a la base de donnees propre a chaque service.

## 13. Synthese des justifications d'architecture

Les flux ont ete dessines ainsi pour respecter quelques choix forts.

### 13.1 Performance et disponibilite

- lecture catalogue optimisee par vues resolues et cache ;
- prise de commande independante d'un appel synchrone vers le catalogue ;
- livraison isolee sur une pile adaptee au temps reel.

### 13.2 Decouplage et resilence

- evenements via `RabbitMQ` plutot que chaines d'appels directes ;
- saga visible comme coordination asynchrone, pas comme super-service ;
- anti-corruption layer pour les SI externes et les paiements magasin.

### 13.3 Clarte metier

- domaine franchise decoupe en capacites lisibles ;
- `Catalog`, `Order`, `Preparation`, `Delivery`, `Payment` ont des responsabilites plus nettes ;
- les schemas racontent mieux le fonctionnement reel attendu.

### 13.4 Evolutivite

- chaque flux peut evoluer sans remettre en cause tout le parcours ;
- les services franchise pourront grandir independamment si la charge ou le perimetre augmente ;
- les integrations externes restent concentrees dans `Integration Hub`.

## 14. Conclusion

Le point central de cette refonte des flux est le suivant :
- les services metier sont au meme niveau ;
- la coordination passe majoritairement par des evenements ;
- `Order Service` n'est plus couple synchrone a `Catalog Service` ;
- le domaine franchise est enfin decoupe de facon defendable.

Le document peut donc servir a presenter les schemas, a justifier les fleches visibles, et a expliquer pourquoi certaines fleches ont volontairement disparu.
