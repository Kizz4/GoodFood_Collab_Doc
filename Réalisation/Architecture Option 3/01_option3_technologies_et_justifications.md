# Option 3 - Technologies retenues et justifications

## 1. Principe directeur
L'option 3 ne cherche pas a imposer un full microservices des le premier lot. La trajectoire retenue reste progressive :
- un coeur modernise en modulith bien decoupe ;
- des services extraits seulement quand la pression metier ou technique le justifie ;
- une couche d'integration anti-corruption pour absorber le SI existant et le nouveau systeme de caisse ;
- une heterogeneite technique volontaire mais limitee : `ASP.NET Core` pour le coeur et la majorite des services, `Node.js + MongoDB` pour la livraison.

Cette derniere exception est assumee. Elle se justifie par la nature du domaine livraison :
- beaucoup d'I/O et d'evenements ;
- suivi quasi temps reel ;
- donnees de tracking, ETA et preuve de livraison plus variables que les donnees coeur ;
- interaction forte avec l'application mobile livreur.

## 2. Criteres de decision rappeles par le contexte
Les choix technologiques ne sont pas arbitraires. Ils doivent repondre aux demandes du client et aux faiblesses du SI actuel.

| Critere | Pourquoi il compte pour GoodFood | Faiblesse ou demande client associee |
|---|---|---|
| Disponibilite et tenue aux pics | 80 % du CA passe par la vente en ligne | pics de charge mal absorbes, perte de CA si indisponibilite |
| Migration progressive sans rupture | la prod doit continuer pendant la refonte | legacy obsolet, dependances prestataires, conservation totale des donnees |
| Ouverture et interoperabilite | la cible doit s'ouvrir a d'autres solutions | integration Dynamics 365, Sage, M365, BNB, POS, autres SI |
| Mobile et accessibilite | le sujet demande une app mobile et une experience plus moderne | absence mobile, UX insuffisante |
| Adaptation aux franchises | les besoins des franchises varient | demandes parfois contradictoires, besoin de variantes locales maitrisees |
| Reprise en main par GoodFood | l'entreprise veut internaliser progressivement | equipe interne plutot support N1, faible capacite d'evolution au depart |
| Preference open source | l'audit recommande de sortir de la dependance Microsoft legacy | legacy Windows/SQL Server hors support, besoin d'ouverture techno |
| Industrialisation du run | la cible doit etre exploitable et observable | faible visibilite sur l'exploitation, deployements risques |

## 3. Referentiel des choix
| Domaine | Technologie retenue | Interet recherche | Faiblesse ou demande couverte | Point de vigilance |
|---|---|---|---|---|
| Cloud principal | `Microsoft Azure` | rester coherent avec Dynamics 365, Microsoft 365 et les services geres utiles | migration progressive, alignement avec l'existant, reduction du risque d'integration | ne pas se verrouiller inutilement sur des services trop specifiques si une option open source suffit |
| Deploiement runtime | `AKS` pour staging/prod | orchestrer plusieurs conteneurs, autoscaler, isoler les services critiques | pics de charge, haute disponibilite, industrialisation du run | a introduire apres stabilisation du socle, pas des le premier lot |
| Developpement local | `Docker Compose` | lancer vite l'ensemble local avec broker, cache, bases et services | montee en competence progressive, vitesse de livraison | ecart possible avec la prod Kubernetes, a compenser par CI/CD et environnements intermediaires |
| Front web | `React` | produire des interfaces riches et decouplees du back-end | mobile/accessibilite, besoin d'ouverture via APIs, lot DIW | discipline UX, design system et gestion de la dette front |
| Mobile | `React Native` | couvrir client mobile et livreur avec une logique front proche du web | exigence mobile explicite, time-to-market | certains besoins natifs peuvent demander du code specifique |
| API Gateway | `YARP` | point d'entree unique, routage, controle d'acces et gouvernance d'API | accessibilite depuis d'autres solutions, securite, separation des acces | la configuration doit etre versionnee et bien testee |
| IAM | `Keycloak` | centraliser authentification, roles et tokens | separation des acces entre clients, livreurs, franchises et back-office | administration IAM a cadrer serieusement |
| Discovery / health | `Endpoints health + probes Kubernetes`, `Consul` seulement si besoin ulterieur | garder la solution simple au debut tout en laissant une porte d'extension | manque de visibilite exploitation, croissance de la distribution | ne pas introduire `Consul` trop tot si `AKS` couvre deja le besoin |
| Messaging | `RabbitMQ` | decoupler les flux et absorber les variations de charge | dependances externes lentes, besoin de resilence, extraction progressive | gouvernance des contrats evenements indispensable |
| Framework de messaging | `MassTransit` cote `.NET` et client `AMQP` cote `Node.js` | accelerer la fiabilite des flux .NET sans bloquer le service livraison sur la meme pile | coordonner sagas, evenements metier et polyglot maitrise | garder des contrats `AsyncAPI` ou equivalents pour eviter la divergence |
| Observabilite | `ELK` | centraliser les logs et accelerer l'investigation | faible visibilite run, coexistence ancien/nouveau SI | cout de retention et bruit si pas de discipline de logs |
| Cache | `Redis` | accelerer lectures chaudes et limiter la charge sur le coeur | pics de charge, latence UX | invalidation et coherence cache a traiter proprement |
| Coeur applicatif | `ASP.NET Core` | capitaliser sur l'existant .NET tout en modernisant fortement | migration progressive, reprise en main, compatibilite legacy | attention a ne pas refaire un monolithe spaghetti |
| Style du coeur | `Modular Monolith` | structurer d'abord le coeur sans eclater trop tot | besoin de stabilite, faible maturite d'exploitation distribuee | scalabilite moins fine qu'un systeme full microservices |
| Services extraits sensibles | `ASP.NET Core` pour paiement, notification, integration | garder l'homogeneite sur les flux transactionnels et les integrations lourdes | paiement critique, integration ERP/compta/POS, montee en competence equipe | coexistence avec `Node.js` a documenter |
| Service livraison | `Node.js` avec `TypeScript` | mieux traiter l'I/O, le temps reel et le tracking | app livreur, suivi de livraison, ETA, variabilite metier | heterogeneite technique et besoin de standards de code |
| Donnees coeur | `PostgreSQL` | forte integrite transactionnelle et requetage relationnel riche | conservation des donnees, commande, franchise, profils | schemas et migrations a gouverner proprement |
| Donnees paiement | `PostgreSQL` | robustesse transactionnelle et auditabilite | integrite paiement/remboursement/compta | ne pas melanger les flux livraison avec les flux financiers |
| Donnees saga / integration | `PostgreSQL` | stocker etats, outbox et traces de maniere fiable | orchestration distribuee, reprise sur incident | volumetrie technique a surveiller |
| Donnees livraison | `MongoDB` | modele souple pour missions, positions, ETA, preuves de livraison et historique d'etats | besoin de tracking flexible, donnees geographiques et evenements nombreux | reporting transverse et transactions multi-documents moins naturels que sur PostgreSQL |
| Cartographie | `Google Maps` | ETA, geolocalisation, itineraire | qualite du service de livraison | cout API et dependance fournisseur |
| Email transactionnel | `SendGrid` | emails fiables et industrialises | confirmations, incidents, reinitialisation mot de passe | gestion des templates et de la reputation domaine |
| SMS | `Twilio` | canal d'alerte simple et mondial | notifications critiques livreur/client | cout unitaire et gouvernance des messages |
| Push | `Firebase Cloud Messaging` | notifications mobiles legeres et rapides | notifications client/livreur, app mobile | dependance a l'ecosysteme mobile et gestion du consentement |
| ERP | `Microsoft Dynamics 365` | reutiliser le socle transverse deja deployee | ne pas reconstruire l'ERP, conserver l'existant utile | isoler le couplage via ACL |
| Tresorerie | `Sage Tresorerie` | conserver un composant deja operationnel | limiter la transformation finance | integration et traçabilite plus que refonte |
| Messagerie metier | `Microsoft 365` | capitaliser sur un outillage deja deploye | support, reclamations, communication interne | ne pas le transformer en bus d'integration |
| Paiement en ligne | `Payment Provider Adapter BNB / PSP` | ne pas figer la cible sur un seul prestataire | prestataire paiement lent, incertitude contractuelle | bien isoler le contrat et prevoir sandbox/simulateur |
| Caisse / terrain | `TP System / nouveau POS` via ACL | absorber la contrainte du nouveau POS sans bloquer le reste | nouveau systeme de caisse, integration parallelisee | forte dependance de planning et de contrat d'interface |

## 4. Justification detaillee par couche

### 4.1 Canaux utilisateurs
#### Application web - `React`
Interet pour GoodFood :
- construire des interfaces riches pour le parcours client, le back-office et le service franchises ;
- travailler proprement avec des APIs decouplees ;
- faciliter le partage de conventions avec le lot mobile porte par DIW.

Faiblesse ou demande client couverte :
- absence d'application moderne cote utilisateur ;
- besoin d'accessibilite et de mobile first ;
- exigence d'ouverture vers d'autres solutions via APIs.

Pourquoi cette techno :
- `React` est tres adapte aux frontends decouples et aux interfaces qui evoluent vite ;
- l'ecosysteme UI, tests et accessibilite est tres mature ;
- le choix est coherent avec `React Native`, ce qui reduit la dispersion des usages front.

Avantages :
- forte disponibilite de composants, bibliotheques et profils ;
- facilite la collaboration avec un design system ;
- bon alignement avec une architecture `API Gateway + APIs metier`.

Inconvenients / garde-fous :
- framework peu prescriptif, donc risque de dette si les conventions sont faibles ;
- necessite une gouvernance front claire sur le routage, l'etat et les composants ;
- la performance percue depend autant de l'architecture API que du choix du framework.

#### Applications mobiles - `React Native`
Interet pour GoodFood :
- couvrir l'application client et l'application livreur ;
- accelerer le delivery mobile sans deux equipes natives distinctes ;
- rester coherent avec `React` cote web.

Faiblesse ou demande client couverte :
- le contexte demande explicitement une application mobile ;
- les livreurs ont besoin d'un canal mobile pour missions, suivi, preuve de livraison ;
- l'experience client actuelle est insuffisante sur mobile.

Pourquoi cette techno :
- bonne mutualisation de patterns avec `React` ;
- time-to-market favorable ;
- ecosysteme suffisant pour geolocalisation, notifications et authentification mobile.

Avantages :
- acceleration de la mise en oeuvre ;
- partage de pratiques front avec le web ;
- bon compromis cout / couverture fonctionnelle.

Inconvenients / garde-fous :
- certaines fonctions natives avancees restent plus simples en natif pur ;
- la qualite finale depend d'une vraie discipline UX et accessibilite ;
- il faut prevoir des tests sur appareils reels, surtout cote livreur.

### 4.2 Edge, securite et exposition
#### API Gateway - `YARP`
Interet pour GoodFood :
- unifier l'entree des appels web, mobile et partenaires ;
- centraliser routage, authentification, rate limiting et journalisation ;
- masquer la decomposition interne de l'option 3.

Faiblesse ou demande client couverte :
- besoin d'accessibilite depuis d'autres solutions ;
- securite et separation des acces ;
- coexistence de plusieurs composants pendant la migration.

Pourquoi cette techno :
- tres bon alignement avec une pile `.NET` ;
- simple a industrialiser sans introduire une plateforme gateway trop lourde ;
- suffisant pour une trajectoire progressive modulith puis microservices cibles.

Avantages :
- bonne maitrise du routage et des politiques d'entree ;
- faible cout de complexite par rapport a une gateway tres riche ;
- facilite la publication d'une facade stable.

Inconvenients / garde-fous :
- moins complet nativement qu'une plateforme de type `Kong` ou `Apigee` ;
- la gouvernance d'API reste a construire autour ;
- il faut documenter et tester fortement la configuration.

#### IAM - `Keycloak`
Interet pour GoodFood :
- gerer clients, livreurs, franchises, support et back-office dans un point central ;
- porter RBAC, SSO, federation et emission de tokens.

Faiblesse ou demande client couverte :
- separation des acces / securite fonctionnelle ;
- besoin multi-profils ;
- limitation de la logique de securite dispersee dans tous les services.

Pourquoi cette techno :
- open source, mature, riche fonctionnellement ;
- plus defensable qu'un IAM fait maison ;
- compatible avec le besoin d'ouverture et la trajectoire multi-applications.

Avantages :
- gestion centralisee des identites ;
- prise en charge standard d'`OIDC` et `OAuth2` ;
- bon compromis entre ouverture, cout et couverture fonctionnelle.

Inconvenients / garde-fous :
- mise en place et exploitation IAM demandent de la rigueur ;
- une mauvaise modelisation des roles peut vite devenir confuse ;
- il faut traiter serieusement secrets, federation et rotation des certificats.

#### Discovery / health
Interet pour GoodFood :
- prioriser la simplicite tant que l'architecture reste partiellement centralisee ;
- garder une trajectoire claire pour l'observabilite et la disponibilite.

Faiblesse ou demande client couverte :
- manque de visibilite run ;
- besoin de sante technique et d'auto-remediation.

Pourquoi ce choix :
- les `health endpoints` et les `probes Kubernetes` couvrent le besoin immediat ;
- `Consul` reste une option si le nombre de services et les besoins de discovery/config centralisee augmentent vraiment.

Avantages :
- evite d'introduire un composant de plus trop tot ;
- colle a la trajectoire progressive.

Inconvenients / garde-fous :
- il faut bien distinguer sante technique et sante metier ;
- si la distribution augmente fortement, la strategie de discovery devra etre revalidee.

### 4.3 Socle applicatif
#### Coeur modernise - `ASP.NET Core Modular Monolith`
Interet pour GoodFood :
- moderniser vite le coeur commande/catalogue/compte/reclamations/franchise ;
- capitaliser sur l'existant `.NET` et les habitudes techniques deja presentes ;
- reduire le risque d'un big bang microservices.

Faiblesse ou demande client couverte :
- legacy monolithique peu maintenable ;
- migration sans rupture ;
- besoin de reprise en main par une equipe interne encore en construction.

Pourquoi cette techno et ce style :
- `.NET` reste coherent avec l'historique GoodFood et avec les integrations existantes ;
- le `modular monolith` force un meilleur decoupage sans exploser d'emblee la complexite d'exploitation ;
- c'est le meilleur compromis entre vitesse de structuration et controle du risque.

Avantages :
- une seule unite de deploiement au debut ;
- decoupage metier plus lisible qu'un monolithe legacy ;
- extraction ulterieure des services critiques plus simple si les frontieres sont propres.

Inconvenients / garde-fous :
- si les modules ne sont pas vraiment isoles, on recree de la dette ;
- la scalabilite reste plus grossiere que sur des microservices purs ;
- la discipline d'architecture interne est non negociable.

#### Services extraits sensibles - `ASP.NET Core`
Perimetre :
- `Paiement`,
- `Notification`,
- `Integration Hub / ACL`,
- eventuellement `Saga / orchestration`.

Interet pour GoodFood :
- garder une forte coherence sur les domaines transactionnels et d'integration ;
- limiter la dispersion de competences la ou la lisibilite et l'auditabilite comptent beaucoup.

Faiblesse ou demande client couverte :
- integrite des flux paiement/compta ;
- absorption du nouveau POS ;
- dependances externes lentes ou heterogenes.

Pourquoi cette techno :
- les equipes et l'existant sont plus proches de `.NET` que d'autres piles ;
- les services transactionnels y restent tres confortables ;
- cela laisse l'exception polyglotte a un seul domaine vraiment justifie : la livraison.

Avantages :
- meilleure coherence globale ;
- reduction du cout d'apprentissage ;
- facilitation du support et de la documentation.

Inconvenients / garde-fous :
- peut sembler moins "uniforme" avec le service livraison en `Node.js` ;
- impose une gouvernance claire des contrats inter-services.

#### Service livraison - `Node.js` avec `TypeScript`
Interet pour GoodFood :
- traiter les evenements de suivi, les changements d'etat, les interactions mobile et les integrations cartographiques avec une pile tres a l'aise sur l'I/O ;
- isoler un domaine a forte variabilite metier sans contaminer tout le SI ;
- mieux accompagner les besoins de tracking et de remontes quasi temps reel.

Faiblesse ou demande client couverte :
- application livreur et suivi de livraison ;
- besoin d'ETA, d'affectation, de preuve de livraison et d'incidents ;
- pics d'activite et nombreuses interactions courtes.

Pourquoi cette techno :
- `Node.js` est efficace sur les services majoritairement I/O-bound ;
- son ecosysteme se prete bien aux integrations evenementeelles, websockets et APIs legeres ;
- `TypeScript` reduit le risque de derive de maintenabilite en apportant du typage.

Avantages :
- bonne reactivite pour un service de tracking ;
- productivite elevee sur un domaine avec beaucoup d'appels reseau et de statuts ;
- bonne synergie avec des clients web/mobile JavaScript.

Inconvenients / garde-fous :
- heterogeneite technique supplementaire ;
- il faut imposer `TypeScript`, linting, tests et contrats d'API/evenements ;
- ne pas etendre `Node.js` a d'autres domaines sans nouvelle justification.

### 4.4 Donnees
#### Base relationnelle coeur / paiement / saga - `PostgreSQL`
Interet pour GoodFood :
- securiser les domaines ou l'integrite transactionnelle est prioritaire ;
- garder un moteur robuste, open source et polyvalent.

Faiblesse ou demande client couverte :
- conservation des donnees ;
- coherence commande/paiement/remboursement ;
- auditabilite sur les flux metier et techniques.

Pourquoi cette techno :
- tres bon compromis entre robustesse, cout et ouverture ;
- excellent support SQL, transactions, indexation et outillage ;
- plus simple a justifier que des bases relationnelles plus lourdes ou plus couteuses.

Avantages :
- forte maturite ;
- facilite rapports, jointures et integrite ;
- bon alignement avec les domaines coeur et financiers.

Inconvenients / garde-fous :
- moins naturel pour des structures documentaires tres variables ;
- les evolutions de schema doivent etre pilotees proprement.

#### Base livraison - `MongoDB`
Interet pour GoodFood :
- stocker des aggregates de livraison plus flexibles : mission, etapes, positions, ETA, preuve de livraison, incidents, timeline d'etats ;
- accepter plus facilement l'evolution du modele quand le processus livraison change.

Faiblesse ou demande client couverte :
- besoin de suivi de livraison plus riche ;
- variabilite des donnees livreur et terrain ;
- integration avec mobile et cartographie.

Pourquoi cette techno :
- modele document pertinent pour un aggregate de livraison ;
- souplesse utile pour les payloads de tracking et de geolocalisation ;
- bon fit pour un service isole, non financier, a evolution rapide.

Avantages :
- grande souplesse de schema ;
- bonne adequation a un domaine evenementiel et geospatial ;
- reduction de certains couts de mapping objet/relationnel.

Inconvenients / garde-fous :
- moins naturel pour reporting transverse et requetes relationnelles complexes ;
- moins confortable que `PostgreSQL` pour les exigences transactionnelles multi-entites ;
- la gouvernance de la structure des documents reste necessaire meme en `NoSQL`.

#### Cache - `Redis`
Interet pour GoodFood :
- accelerer les lectures frequentes sans surcharger les bases ;
- absorber des pointes sur catalogue, session technique ou donnees temporaires.

Faiblesse ou demande client couverte :
- pics de charge ;
- temps de reponse utilisateur.

Pourquoi cette techno :
- simple, rapide et bien comprise ;
- tres adaptee a des cas de cache et de donnees temporaires.

Avantages :
- gain rapide sur les lectures repetitives ;
- integration facile.

Inconvenients / garde-fous :
- risque classique d'invalidation et d'incoherence si mal pilote ;
- ne pas y stocker du metier critique par confort.

### 4.5 Integration asynchrone et orchestration
#### Broker - `RabbitMQ`
Interet pour GoodFood :
- decoupler commande, paiement, livraison, notification et integration ;
- lisser les dependances lentes ou indisponibles ;
- fiabiliser les flux sans bloquer l'utilisateur a chaque etape.

Faiblesse ou demande client couverte :
- dependances externes heterogenes ;
- besoin de resilence ;
- extraction progressive des domaines critiques.

Pourquoi cette techno :
- plus simple a introduire qu'un `Kafka` dans ce contexte ;
- largement suffisant pour les evenements metier et workflows asynchrones de GoodFood ;
- bon compromis entre puissance et cout d'exploitation.

Avantages :
- mise en place relativement rapide ;
- modeles `queue`, `pub/sub`, retries et dead-letter bien connus ;
- parfaitement adapte aux besoins de decouplage de l'option 3.

Inconvenients / garde-fous :
- necessite une vraie gouvernance des messages et des idempotences ;
- ne remplace pas une conception metier correcte des flux.

#### Framework de messaging - `MassTransit` cote `.NET`, `AMQP` natif cote `Node.js`
Interet pour GoodFood :
- garder de la productivite et de la fiabilite sur les services `.NET` ;
- ne pas imposer au service livraison une pile qui n'est pas la sienne ;
- conserver un broker commun et des contrats homogenes.

Faiblesse ou demande client couverte :
- complexite des flux distribues ;
- besoin de compensation et de reprise sur erreur.

Pourquoi ce choix :
- `MassTransit` simplifie beaucoup les consommateurs, retries et sagas cote `.NET` ;
- le service livraison `Node.js` parle au meme `RabbitMQ` via `AMQP`, ce qui garde l'interoperabilite sans forcer l'uniformite d'implementation.

Avantages :
- bonne productivite cote `.NET` ;
- polyglot reste controle par le protocole et les contrats.

Inconvenients / garde-fous :
- les schemas de messages doivent etre contract-first ;
- il faut documenter les evenements et versionner les contrats.

#### ACL et integration hub - `ASP.NET Core`
Interet pour GoodFood :
- isoler le legacy et les partenaires du coeur metier ;
- absorber Dynamics, Sage, POS, banque et messagerie dans une couche dediee.

Faiblesse ou demande client couverte :
- nouveau POS en parallele ;
- dependances prestataires ;
- interopabilite avec le SI existant.

Pourquoi cette techno :
- bon alignement avec les integrations existantes de l'ecosysteme GoodFood ;
- facilite le decouplage progressif du legacy.

Avantages :
- evite de polluer le coeur metier avec des details d'integration ;
- meilleure testabilite des flux externes.

Inconvenients / garde-fous :
- si tout y est verse sans limite, cette couche peut devenir un nouveau monolithe d'integration ;
- les contrats externes doivent etre traces et testes.

### 4.6 Observabilite et exploitation
#### Logs centralises - `ELK`
Interet pour GoodFood :
- suivre les incidents sur un SI hybride ancien/nouveau ;
- accelerer l'investigation quand un flux commande -> paiement -> livraison echoue.

Faiblesse ou demande client couverte :
- faible visibilite d'exploitation ;
- multiplicite des composants et prestataires.

Pourquoi cette techno :
- solution open source connue ;
- suffisamment puissante pour centraliser, rechercher et corriger.

Avantages :
- facilite corrélation et diagnostic ;
- utile pendant la migration et apres.

Inconvenients / garde-fous :
- volumetrie et retention a maitriser ;
- sans discipline de logs, on obtient beaucoup de bruit et peu de valeur.

#### `Docker Compose` en developpement
Interet pour GoodFood :
- demarrer vite un environnement local avec toutes les dependances utiles ;
- garder une entree accessible pour une equipe qui monte en competence.

Faiblesse ou demande client couverte :
- besoin de livraison rapide ;
- faible maturite initiale sur l'exploitation distribuee.

Pourquoi cette techno :
- beaucoup plus legere qu'un cluster Kubernetes local permanent ;
- suffisante pour les boucles de dev et de test d'integration precoces.

Avantages :
- simplicite ;
- onboarding rapide ;
- cout cognitif faible.

Inconvenients / garde-fous :
- ne reproduit pas completement les comportements de prod ;
- il faut compenser avec une CI/CD et des environnements de validation proches d'`AKS`.

#### `AKS` en staging / production
Interet pour GoodFood :
- executer proprement le modulith, les services extraits, le broker, le cache et les composants de support ;
- beneficier d'`autoscaling`, de rolling updates, de self-healing et d'isolement.

Faiblesse ou demande client couverte :
- pics de charge ;
- disponibilite ;
- industrialisation du run et reduction des risques de mise en production.

Pourquoi cette techno :
- `AKS` est le service `Azure Kubernetes Service` ;
- il permet d'avoir du `Kubernetes` managé dans le cloud deja retenu ;
- il repond mieux qu'un simple hebergement PaaS si GoodFood veut un runtime multi-services coherent.

Avantages :
- forte capacite d'evolution ;
- standardisation runtime pour les conteneurs ;
- bon alignement avec `HPA`, `KEDA`, ingress et observabilite.

Inconvenients / garde-fous :
- cout de complexite reel ;
- demande une maturite plateforme, securite et exploitation ;
- a introduire apres la stabilisation du socle, pas avant.

## 5. Matrices de choix comparatives
Les scores ci-dessous sont des scores d'aide a la decision. Ils ne pretendent pas etre universels. Ils sont calibres pour le contexte GoodFood.

### 5.1 Front web
| Critere | Poids | `React` | `Angular` | `Blazor` |
|---|---:|---:|---:|---:|
| Vitesse de livraison UI riches | 5 | 5 | 4 | 3 |
| Alignement avec DIW et l'ecosysteme front | 4 | 5 | 4 | 2 |
| Accessibilite et bibliotheques UI | 4 | 5 | 4 | 3 |
| Recrutement et disponibilite de profils | 3 | 5 | 4 | 2 |
| Integration avec une API decouplee | 4 | 5 | 4 | 4 |
| Cout de gouvernance initial | 2 | 3 | 4 | 3 |
| Total pondere |  | 84 | 72 | 49 |

Explication des scores :
- `React` prend l'avantage sur la vitesse de livraison, l'ecosysteme UI et l'alignement avec `DIW`, car il colle mieux a un lot web/mobile decouple et a un design system evolutif.
- `Angular` reste credible et mieux cadre nativement, ce qui explique son score correct sur la gouvernance, mais il est legerement moins favorable pour la vitesse et la souplesse produit attendues ici.
- `Blazor` perd surtout sur l'alignement de contexte : il est moins coherent avec le choix `React Native`, moins naturel pour un lot confie a `DIW`, et moins defendable dans une logique d'ouverture front deja amorcee.

Conclusion :
- `React` est retenu car il maximise l'agilite produit, la coherence avec le mobile et l'ouverture API.

### 5.2 Mobile
| Critere | Poids | `React Native` | `Flutter` | `PWA` |
|---|---:|---:|---:|---:|
| Couverture besoin app client + livreur | 5 | 5 | 5 | 3 |
| Vitesse de mise en oeuvre | 4 | 5 | 4 | 4 |
| Synergie avec le front web | 4 | 5 | 3 | 5 |
| Acces aux fonctions mobiles terrain | 4 | 4 | 5 | 2 |
| Cout de maintenance cible | 3 | 4 | 4 | 4 |
| Total pondere |  | 82 | 74 | 57 |

Explication des scores :
- `React Native` est premier parce qu'il combine une bonne couverture fonctionnelle mobile avec une forte synergie avec `React`, ce qui reduit la dispersion des pratiques front.
- `Flutter` reste solide, surtout sur le rendu et certaines integrations mobiles, mais il marque un peu moins de points car il introduit un ecosysteme moins aligne avec le web retenu.
- La `PWA` garde des points sur le cout et la rapidite, mais elle chute sur les usages terrain du livreur, les notifications et certaines fonctions mobiles plus sensibles.

Conclusion :
- `React Native` l'emporte par coherence globale avec `React` et par equilibre entre vitesse, cout et couverture.

### 5.3 Coeur applicatif
| Critere | Poids | `ASP.NET Core Modular Monolith` | `Spring Boot Modular Monolith` | `Node.js` full backend |
|---|---:|---:|---:|---:|
| Compatibilite avec l'existant GoodFood | 5 | 5 | 3 | 2 |
| Facilite de migration progressive | 5 | 5 | 4 | 3 |
| Maitrise equipe / reprise en main | 4 | 4 | 3 | 3 |
| Robustesse transactionnelle et integrative | 4 | 5 | 5 | 3 |
| Ouverture et modernisation | 3 | 4 | 4 | 4 |
| Cout d'adoption initial | 3 | 4 | 2 | 3 |
| Total pondere |  | 85 | 67 | 54 |

Explication des scores :
- `ASP.NET Core Modular Monolith` domine parce qu'il maximise la compatibilite avec l'existant, la migration progressive et la reprise en main par une equipe qui n'a pas encore une maturite forte sur le distribue.
- `Spring Boot` reste tres bon techniquement, surtout sur la robustesse applicative, mais il perd des points sur le cout d'adoption et sur l'alignement avec l'historique GoodFood.
- `Node.js` en backend coeur n'est pas elimine pour des raisons de mode, mais parce qu'il est moins naturel ici sur les sujets transactionnels, integratifs et de migration depuis le legacy .NET.

Conclusion :
- `ASP.NET Core` reste le meilleur choix pour le coeur, non parce qu'il est le plus "tendance", mais parce qu'il reduit le risque de transformation.

### 5.4 Service livraison
| Critere | Poids | `Node.js + MongoDB` | `ASP.NET Core + PostgreSQL` | `Spring Boot + MongoDB` |
|---|---:|---:|---:|---:|
| Adequation au temps reel et a l'I/O | 5 | 5 | 4 | 4 |
| Souplesse du modele livraison | 5 | 5 | 3 | 5 |
| Synergie avec web/mobile JavaScript | 4 | 5 | 3 | 3 |
| Geolocalisation et tracking evolutifs | 4 | 5 | 3 | 4 |
| Coherence avec le SI global | 3 | 3 | 5 | 2 |
| Cout d'exploitation et de gouvernance | 3 | 3 | 4 | 2 |
| Total pondere |  | 87 | 70 | 67 |

Explication des scores :
- `Node.js + MongoDB` obtient les meilleurs scores sur le temps reel, le tracking evolutif et la synergie web/mobile, qui sont les points les plus differenciants pour la livraison.
- `ASP.NET Core + PostgreSQL` reste meilleur sur la coherence globale du SI et sur la simplicite de gouvernance, mais il est penalise car son modele est moins souple pour un domaine de suivi tres variable.
- `Spring Boot + MongoDB` est techniquement valable, mais il combine deux couts d'adoption pour GoodFood : nouvelle pile applicative et heterogeneite supplementaire, sans avantage suffisant par rapport a `Node.js`.

Conclusion :
- `Node.js + MongoDB` est retenu pour la livraison parce que le domaine supporte mieux une pile orientee I/O et documents evolutifs.
- Le cout de cette decision est l'heterogeneite. Il est accepte car il reste cantonne a un seul domaine extrait.

### 5.5 Broker de messages
| Critere | Poids | `RabbitMQ` | `Kafka` | `Azure Service Bus` |
|---|---:|---:|---:|---:|
| Simplicite d'adoption | 5 | 5 | 2 | 4 |
| Adequation aux workflows metier asynchrones | 4 | 5 | 4 | 4 |
| Cout d'exploitation dans ce contexte | 4 | 4 | 3 | 3 |
| Compatibilite polyglotte | 3 | 5 | 5 | 4 |
| Besoin de streaming massif | 2 | 2 | 5 | 2 |
| Total pondere |  | 76 | 53 | 59 |

Explication des scores :
- `RabbitMQ` est favorise car GoodFood a surtout besoin de files de travail, d'evenements metier et de resilence applicative, pas d'une plateforme de streaming massif.
- `Kafka` prend naturellement un bon score sur le streaming, mais il est penalise sur la simplicite et le cout d'introduction car son niveau de sophistication depasse le besoin actuel.
- `Azure Service Bus` reste une option defendable, mais il est un peu moins bien note a cause du verrouillage cloud plus fort et d'un benefice fonctionnel moindre face a `RabbitMQ` dans ce cas.

Conclusion :
- `RabbitMQ` couvre le besoin reel de GoodFood sans surdimensionner l'architecture.

### 5.6 Runtime de production
| Critere | Poids | `AKS` | `Azure App Service + jobs` | `VMs` |
|---|---:|---:|---:|---:|
| Capacite a heberger plusieurs services de facon coherente | 5 | 5 | 3 | 2 |
| Autoscaling et resilience | 5 | 5 | 3 | 2 |
| Standardisation du deploiement conteneur | 4 | 5 | 3 | 2 |
| Cout de complexite initial | 3 | 2 | 4 | 3 |
| Evolution long terme vers plus de distribution | 4 | 5 | 3 | 2 |
| Total pondere |  | 79 | 56 | 39 |

Explication des scores :
- `AKS` prend la tete parce qu'il repond le mieux a la cible multi-services, a l'autoscaling et a la resilence attendue en staging et production.
- `Azure App Service + jobs` est mieux note sur la simplicite initiale, mais il devient moins convaincant quand on veut faire cohabiter proprement plusieurs services, workers et patterns de deploiement.
- Les `VMs` gardent un petit score sur le cout de complexite percu a court terme, mais elles perdent massivement sur la standardisation, l'evolutivite et la tenue du run.

Conclusion :
- `AKS` est la meilleure cible runtime pour staging/prod.
- `Docker Compose` reste toutefois la bonne reponse en developpement local pour ne pas surcharger les equipes trop tot.

## 6. Repartition recommandee par phase
### Phase A - Fondations
- `React`,
- `React Native`,
- `YARP`,
- `Keycloak`,
- `Docker Compose`,
- `RabbitMQ`,
- `Redis`,
- `PostgreSQL`,
- `ELK`,
- conventions `OpenAPI` et `AsyncAPI`.

### Phase B - Coeur modernise
- `ASP.NET Core Modular Monolith`,
- `Integration Hub / ACL`,
- APIs vers `Dynamics`, `Sage`, `M365`, `BNB / PSP`, `POS`.

### Phase C - Extractions ciblees
- `Payment Service` en `ASP.NET Core`,
- `Delivery Service` en `Node.js + MongoDB`,
- `Notification Service` en `ASP.NET Core`,
- orchestration de saga si le niveau de distribution l'exige.

### Phase D - Industrialisation runtime
- `AKS`,
- `HPA`,
- `KEDA`,
- ingress `TLS`,
- observabilite renforcee,
- politiques de deploiement progressif.

## 7. Regles de gouvernance a poser
L'option 3 reste defendable seulement si la gouvernance technique suit.

Regles a poser explicitement :
- `TypeScript` obligatoire sur le service livraison ;
- contrats `OpenAPI` pour les APIs synchrones ;
- contrats `AsyncAPI` ou schemas de messages versionnes pour les evenements ;
- observabilite homogène quelle que soit la pile (`.NET` ou `Node.js`) ;
- ownership explicite par domaine et par base de donnees ;
- interdiction d'etendre la polyglotte a d'autres services sans nouvelle justification.

## 8. Decisions a revalider explicitement
Certaines decisions demandent encore un cadrage explicite.

### 8.1 Fournisseur de paiement en ligne
Le plan mentionnait `Stripe`, alors que le contexte historique est centré sur `BNB`.

Decision d'architecture retenue :
- ne pas figer l'architecture sur un fournisseur unique ;
- modeliser un `Payment Provider Adapter` ;
- valider ensuite contractuellement si le fournisseur reste `BNB`, devient `Stripe`, ou doit supporter les deux.

### 8.2 Stack livraison
Decision retenue pour cette version :
- `Node.js` avec `TypeScript` pour le service livraison ;
- `MongoDB` pour les donnees de livraison ;
- communication evenementielle via `RabbitMQ` en `AMQP` ;
- exposition via l'`API Gateway`.

Conditions de reussite :
- limiter ce choix au domaine livraison ;
- documenter les contrats de messages et d'API ;
- surveiller le cout reel de l'heterogeneite sur l'equipe.

### 8.3 Calendrier d'introduction de Kubernetes
`AKS` est bien la cible de runtime pour staging et production, mais ce n'est pas la premiere etape du projet.

Decision retenue :
- `Docker Compose` en local et pour les premiers lots techniques ;
- `AKS` quand le modulith et les premiers services extraits sont stabilises ;
- industrialisation progressive du run plutot qu'introduction immediate de `Kubernetes`.
