# Analyse du contexte GoodFood (AS-IS), points faibles et options d'architecture

## 1. Sources prises en compte
- `GoodFood/Consignes/contexte goodfood.pdf`
- `GoodFood/Consignes/Consignes Projet collaboratif Architecture logicielle_v2.pdf`
- `GoodFood/Consignes/Livrables.pdf`
- `GoodFood/Réalisation/Rapport/Cadrage/rapport.pdf`
- `GoodFood/Réalisation/Rapport/Cadrage/Latex/mainmatter/note_de_cadrage.tex`
- `GoodFood/Réalisation/Details Technique/Plan_GoodFood_3.0.pdf`
- `GoodFood/Réalisation/Details Technique/Justification de l'architecture2.pdf`
- `GoodFood/Réalisation/Details Technique/k8s.docx`
- `GoodFood/Réalisation/GoodFood - C4/*` (travail équipe sur la cible microservices)
- `Cours/Audit/4-SIEtArchitectureDuSI-etudiant-20260106.pdf`
- `Cours/Audit/7-AuditArchitectureApplicativeSI-etudiant-20260106.pdf`
- `Cours/Architecture Logiciel/Architectures logicielles et mise à l'échelle.pdf`

## 2. Synthèse contexte et périmètre
Good Food est une franchise (150 restaurants, 80% du CA en ligne) avec un SI historiquement sous-traité.

Le système actuel de commande en ligne repose sur:
- un monolithe ASP.NET/C# historique,
- un hébergement vieillissant (Windows Server 2008 R2),
- une base SQL Server 2008,
- une synchronisation quotidienne ERP via application C# WCF hébergée chez WIM,
- des flux bancaires BNB/EBICS vers Sage,
- des réclamations gérées via formulaire, email Microsoft 365 et suivi ERP.

Contrainte structurante:
- forte criticité business (vente en ligne dominante),
- équipe IT interne réduite et orientée support,
- dépendance marquée aux prestataires externes,
- besoins de montée en charge, maintenabilité, ouverture, interopérabilité et migration sans interruption.

## 3. Livrables d'architecture produits dans ce repo
### 3.1 C4 de l'application actuelle (AS-IS)
Workspace créé: `GoodFood/Réalisation/GoodFood - C4-ASIS`

Contenu:
- `workspace.dsl`
- vues C1/C2/C3
- styles et ADR AS-IS
- script `run.sh` (Structurizr Lite sur port 8082)

### 3.2 Schéma SI physique (unités de déploiement et interactions)
Fichier créé:
- `GoodFood/Réalisation/contexte_goodfood_si_physique_asis.drawio`

Le schéma représente:
- zone Internet/utilisateurs,
- mini datacenter PWI (reverse proxy/IIS, app ASP.NET, SQL Server 2008, site vitrine Apache/PHP/MySQL),
- hébergement WIM (sync WCF),
- cloud Microsoft (Dynamics 365 + Microsoft 365),
- siège Good Food (Sage trésorerie + équipes internes),
- partenaires paiement (BNB, TP System/TPE) et flux EBICS.

## 4. Analyse des points faibles et axes d'amélioration
Méthode utilisée (alignée cours Audit):
- constat factuel,
- impact métier/technique,
- criticité,
- recommandation court terme (0-3 mois),
- recommandation moyen terme (3-12 mois).

### 4.1 Gouvernance et organisation
| Constat | Impact | Criticité | Axe court terme | Axe moyen terme |
|---|---|---|---|---|
| Dépendance aux prestataires historiques (PWI, WIM) | Perte de maîtrise des priorités et du rythme de livraison | Élevée | Cartographier qui maintient quoi (RACI clair) | Internaliser progressivement les domaines critiques |
| Équipe IT interne principalement support N1 | Faible capacité d'évolution applicative | Élevée | Plan de montée en compétences ciblé (API, cloud, CI/CD) | Construire un pôle produit/plateforme stable |
| Documentation existant incomplète | Allongement incidents et évolutions | Élevée | Baseline documentaire AS-IS versionnée | Documentation as code + ADR systématiques |
| Contradictions entre demandes franchisés et cahier des charges | Instabilité du backlog, dette fonctionnelle | Moyenne | Mettre en place governance produit (PO + comité arbitrage) | Processus de gestion des variations franchise |

### 4.2 Architecture applicative
| Constat | Impact | Criticité | Axe court terme | Axe moyen terme |
|---|---|---|---|---|
| Monolithe legacy difficile à faire évoluer | Coût de changement élevé, régressions fréquentes | Élevée | Geler les changements risqués non prioritaires | Extraire domaines critiques ou modulariser fortement |
| Stack obsolète (Windows 2008 R2, SQL Server 2008) | Risque sécurité, support éditeur, disponibilité | Critique | Plan de remédiation sécurité + isolation réseau stricte | Migration applicative et data vers stack supportée |
| Synchronisation ERP batch 1 fois/jour (05:00) | Latence opérationnelle, incohérences transitoires | Élevée | Supervision stricte du batch + reprise sur erreur | Passage progressif vers intégration API/event-driven |
| Absence d'application mobile client native | Expérience utilisateur incomplète | Moyenne | Web responsive renforcé + optimisation UX | App mobile dédiée (ou PWA avancée) |

### 4.3 Données et intégrations
| Constat | Impact | Criticité | Axe court terme | Axe moyen terme |
|---|---|---|---|---|
| Base SQL Server unique pour plusieurs préoccupations | Couplage fort, migration risquée | Élevée | Identifier domaines de données et propriétaires | Découpage logique puis physique des données |
| Flux comptables dépendants de chaînes externes BNB/EBICS/Sage | Risque de délais et trous de traçabilité | Élevée | Mettre en place journalisation bout en bout des flux | Standardiser les contrats d'échange et le monitoring métier |
| Franchisés n'alimentent pas tous l'ERP de manière homogène | Qualité de données hétérogène | Élevée | Règles de complétude et alertes qualité data | Gouvernance data + processus d'onboarding franchise |
| Réclamations multi-canaux (email/téléphone/formulaire) | Vision client fragmentée | Moyenne | Normaliser un workflow ticket unique | Service de relation client unifié |

### 4.4 Sécurité et conformité
| Constat | Impact | Criticité | Axe court terme | Axe moyen terme |
|---|---|---|---|---|
| SI critique basé sur composants hors support | Exposition aux vulnérabilités | Critique | Durcissement immédiat (segmentation, WAF, sauvegardes testées) | Replatforming sur socle sécurisé et maintenu |
| Contrôle d'accès transversal peu explicité | Risque d'accès non maîtrisé | Élevée | Revue des droits par rôle (RBAC minimal) | IAM centralisé et auditable |
| Traçabilité sécurité hétérogène (prestataires + systèmes variés) | Difficile d'investiguer rapidement | Élevée | Collecte centralisée de logs critiques | SOC/SIEM léger + procédures incident |

### 4.5 Exploitation, performance et fiabilité
| Constat | Impact | Criticité | Axe court terme | Axe moyen terme |
|---|---|---|---|---|
| Pics de charge mal absorbés par l'existant | Dégradation UX, perte de CA | Critique | Profilage, cache ciblé, optimisation points chauds | Architecture scalable (horizontal + découplage) |
| Supervision dépendante de prestataires externes | Visibilité limitée côté Good Food | Élevée | Dashboard partagé + SLI/SLO minimaux | Observabilité interne industrialisée |
| Déploiements/évolutions potentiellement risqués | Incidents de mise en production | Élevée | Environnement de préproduction obligatoire | CI/CD complet + stratégies de déploiement progressif |

## 5. Axes d'amélioration priorisés
### Priorité 1 (immédiat: 0-3 mois)
- Sécuriser l'existant: patching compensatoire, segmentation réseau, sauvegardes/restauration testées.
- Instrumenter l'existant: logs applicatifs/techniques consolidés, alerting sur paiement/sync ERP/EBICS.
- Rendre la chaîne de livraison fiable: repo Git central, branches protégées, pipeline build/test minimal.
- Introduire une discipline anti-régression: TDD sur les règles métier critiques + tests d'intégration sur les flux sensibles.
- Réduire le risque organisationnel: RACI prestataires, gouvernance backlog, comité architecture.

### Priorité 2 (court/moyen terme: 3-9 mois)
- Définir des contrats d'intégration stables (ERP, banque, compta, réclamations).
- Introduire un anti-corruption layer autour des intégrations legacy.
- Isoler les domaines métier sensibles (commande, paiement, livraison, relation client).
- Préparer la migration data incrémentale (mapping, qualité, reprise sur erreur).

### Priorité 3 (moyen terme: 9-18 mois)
- Industrialiser l'architecture cible (observabilité, sécurité, IaC, autoscaling).
- Déployer mobile + portail franchisé robuste.
- Ouvrir des capacités analytiques temps quasi-réel.

## 6. Options architecturales comparées
Les 3 options ci-dessous sont réalistes dans le contexte Good Food. L'option 2 reflète votre proposition actuelle (microservices event-driven).

### Option 1 - Monolithe modulaire modernisé
Description:
- Replatforming du monolithe actuel vers stack moderne supportée.
- Découpage interne en modules clairs (commande, paiement, livraison, communication, comptabilité).
- API unique avec contrats stables.

Avantages:
- Délai de mise en production souvent plus court que microservices complets.
- Complexité opérationnelle réduite (moins d'artefacts, moins de déploiements multi-services).
- Plus accessible à une équipe interne en montée de compétences.

Inconvénients:
- Scalabilité moins fine (on scale l'application entière ou grands blocs).
- Couplage encore présent au runtime.
- Limite d'évolutivité à long terme si la croissance accélère fortement.

Impacts détaillés:
- Temps de développement: 6-10 mois pour une version robuste si périmètre maîtrisé.
- Financement: coût initial modéré, OPEX maîtrisé.
- Complexité: moyenne.
- Maintenabilité: bonne si discipline modulaire stricte.
- Risque migration: moyen.

### Option 2 - Microservices full event-driven
Description:
- Architecture distribuée complète avec API Gateway, broker d'événements, services par domaine, DB par service, orchestration de saga.
- Correspond à vos travaux actuels (`GoodFood - C4`, plan microservices, matrice cloud/broker).

Avantages:
- Scalabilité fine par domaine (commande/paiement/livraison).
- Découplage fort et alignement DDD.
- Résilience et évolutivité élevées si plateforme bien opérée.

Inconvénients:
- Complexité d'exploitation et de gouvernance très élevée (monitoring, contrats, versioning, sécurité inter-services).
- Coût de plateforme supérieur (CI/CD multi-services, observabilité, orchestrateur, SRE/DevOps).
- Risque de surdimensionnement pour une équipe interne encore peu mature en développement.

Impacts détaillés:
- Temps de développement: 10-18 mois pour socle + services critiques + stabilisation.
- Financement: CAPEX/OPEX élevés.
- Complexité: élevée à très élevée.
- Maintenabilité: excellente si gouvernance mature, faible sinon.
- Risque migration: élevé sans trajectoire progressive.

### Option 3 - Trajectoire hybride (modulith first -> microservices ciblés)
Description:
- Construire d'abord un cœur modulaire (modulith) sur stack moderne.
- Extraire ensuite seulement les domaines à forte pression (paiement, livraison, notification, analytics).
- Strangler pattern pour migration progressive sans big bang.

Avantages:
- Bon compromis risque/valeur.
- Permet d'obtenir vite de la stabilité puis de la scalabilité ciblée.
- Compatible avec une organisation mixte SI/prestataires et un pilotage progressif.

Inconvénients:
- Nécessite une discipline d'architecture forte dès le départ (frontières modulaires réelles).
- Coexistence temporaire de plusieurs modes d'intégration (interne + distribuée).
- Peut être plus long qu'un monolithe pur à court terme.

Impacts détaillés:
- Temps de développement: 8-14 mois pour socle + premières extractions.
- Financement: intermédiaire, lissé dans le temps.
- Complexité: moyenne à élevée (mais progressive).
- Maintenabilité: très bonne si règles de modularité respectées.
- Risque migration: moyen à faible (découpage par étapes).

## 7. Approche TDD pour éviter les régressions
### Pourquoi ajouter explicitement le TDD dans GoodFood
Le contexte GoodFood mentionne des bugs récurrents sur des zones métier sensibles comme les codes promotionnels et le panier, ainsi qu'une accumulation de correctifs successifs sans vision d'ensemble. Dans ce contexte, le TDD ne doit pas être présenté comme une pratique académique abstraite, mais comme un mécanisme de réduction du risque métier.

Le bénéfice attendu n'est pas seulement une meilleure couverture de tests. Le vrai apport est:
- figer le comportement métier attendu avant de modifier le code,
- éviter qu'un correctif local sur le panier, le calcul de remise ou le paiement casse un flux voisin,
- forcer un découpage plus testable des composants,
- réduire le coût des régressions sur une plateforme qui porte 80% du chiffre d'affaires.

### TDD recommandé pour GoodFood
Approche recommandée:
- TDD ciblé sur le domaine et les règles critiques, pas sur toutes les couches indistinctement.
- Complément par tests d'intégration, tests de contrat et tests end-to-end sur les parcours critiques.

Application concrète:
- `PromotionEngine`: règles de codes promo, cumuls, exclusions, plafonds, franchises spécifiques.
- `Order Service`: panier, calcul total, disponibilité, annulation, changements de statut.
- `Payment Service`: transitions métier autour du succès/échec/remboursement.
- `Saga / orchestration`: enchaînement commande -> paiement -> livraison avec cas de compensation.

Boucle de travail recommandée:
1. écrire un test exprimant une règle métier ou une anomalie reproduite,
2. faire échouer ce test,
3. écrire le minimum de code pour le faire passer,
4. refactorer sans casser le comportement garanti,
5. compléter avec un test d'intégration si le flux traverse DB, broker ou API externe.

### Limites à expliciter
Le TDD ne remplace pas:
- les tests d'intégration sur les échanges ERP, banque, SMTP ou broker,
- les tests de contrat entre services,
- les tests end-to-end sur les parcours de commande,
- l'observabilité en production.

Autrement dit, le TDD réduit fortement les régressions métier locales, mais il doit s'inscrire dans une pyramide de tests complète.

## 8. Critères détaillés de choix d'architecture
Important:
- cette liste est construite a partir du contexte GoodFood uniquement,
- les critères `time-to-market` et `TCO à 3/5 ans` sont volontairement exclus comme demandé,
- le critère `complexité pour une équipe de dev interne existante` n'est pas retenu tel quel, car le contexte ne décrit pas une équipe produit déjà constituée; a la place, on mesure la `compatibilité avec l'organisation SI / prestataires`,
- les critères sont expliqués de manière simple pour qu'on comprenne exactement ce qu'on mesure avant de noter.

### 8.1 Continuité de service et expérience utilisateur
#### Disponibilité de service
Explication simple:
- c'est la capacité de l'application a rester disponible quand les clients veulent commander,
- si le site tombe pendant le rush du midi, c'est comme si la caisse du restaurant s'éteignait d'un coup.

Pourquoi ce critère existe dans GoodFood:
- la vente en ligne représente 80% du chiffre d'affaires,
- le contexte demande explicitement une disponibilité sans faille lors des pics de commandes.

#### Scalabilité / tenue en charge
Explication simple:
- c'est la capacité de l'architecture a absorber plus de monde sans devenir lente ou se bloquer,
- si 10 personnes commandent, tout va bien; si 10 000 commandent en même temps, l'architecture doit encore tenir.

Pourquoi ce critère existe dans GoodFood:
- le groupe est en croissance,
- l'audit parle explicitement de pics de commandes,
- la plateforme actuelle plafonne malgré des optimisations.

#### Support mobile et accessibilité
Explication simple:
- cela mesure si l'architecture facilite la création d'une experience correcte sur mobile et pour des utilisateurs ayant des besoins d'accessibilité,
- ce n'est pas juste "avoir une app", c'est aussi pouvoir faire une interface simple, stable et reutilisable.

Pourquoi ce critère existe dans GoodFood:
- l'absence de solution mobile est identifiée comme un problème,
- l'audit demande une application mobile,
- il faut prendre en compte l'accessibilité.

#### Adaptation aux franchises
Explication simple:
- cela mesure si l'architecture peut accepter des différences locales sans casser tout le système,
- en version tres simple: chaque restaurant ne fait pas exactement la meme chose, mais la plateforme doit rester cohérente.

Pourquoi ce critère existe dans GoodFood:
- le contexte parle de prix spécifiques, remises spécifiques, plats spécifiques, fournisseurs spécifiques,
- les franchisés portent des demandes parfois contradictoires.

#### Évolutivité fonctionnelle
Explication simple:
- cela mesure la facilité a ajouter de nouvelles fonctions sans casser l'existant,
- si demain on ajoute réservations, aide à la décision ou nouvelles fonctions livreur, l'architecture doit pouvoir suivre.

Pourquoi ce critère existe dans GoodFood:
- le périmètre cible inclut clients, authentification, menus, commande, paiement, livraison, réservations, service franchisé et éventuellement analytique.

### 8.2 Construction logicielle et maîtrise technique
#### Maintenabilité de la solution
Explication simple:
- c'est la facilité a corriger, comprendre et faire évoluer le code sans provoquer un nouvel incident,
- en image: si chaque correction casse autre chose, la solution n'est pas maintenable.

Pourquoi ce critère existe dans GoodFood:
- le code actuel est obsolète,
- il y a des patchs sur patchs,
- le code est peu documenté,
- l'audit dit qu'une simple montée de version .NET n'est pas pérenne.

#### Modularité du découpage métier
Explication simple:
- cela mesure si l'application peut être découpée proprement en blocs ayant chacun un rôle clair,
- plus les blocs sont clairs, moins on mélange commande, paiement, livraison et réclamations dans le même endroit.

Pourquoi ce critère existe dans GoodFood:
- les fonctionnalités du sujet sont déjà naturellement séparables en grands domaines métier,
- le legacy actuel souffre justement d'un mélange peu maintenable.

#### Documentabilité / transférabilité
Explication simple:
- cela mesure si l'architecture est facile à documenter, expliquer et transmettre à quelqu'un d'autre,
- si seule une personne "sait comment ça marche", l'architecture est fragile.

Pourquoi ce critère existe dans GoodFood:
- le contexte dit que le code actuel n'est pas documenté,
- l'ancien prestataire transmet des informations partielles et incomplètes.

#### Réduction de dépendance technologique
Explication simple:
- cela mesure si la nouvelle architecture réduit l'enfermement dans une technologie vieillissante ou imposée,
- en très simple: si la maison repose sur une seule vieille pièce introuvable, on est coincé.

Pourquoi ce critère existe dans GoodFood:
- l'audit recommande explicitement les technologies open source à la place des solutions Microsoft historiques,
- l'existant repose sur Windows Server 2008 R2, ASP.NET legacy, SQL Server 2008.

#### Compatibilité avec la reprise en main du SI
Explication simple:
- cela mesure si l'architecture aide GoodFood à reprendre la maitrise de son SI au lieu de dépendre éternellement des prestataires,
- une architecture trop opaque ou trop complexe peut empêcher cette reprise en main.
- cela mesure aussi si l'équipe qui reprend le sujet peut apprendre étape par étape sans être noyée dès le début dans toute la complexité de la cible finale.

Pourquoi ce critère existe dans GoodFood:
- le contexte dit que GoodFood veut créer un vrai pôle informatique pour reprendre la main.
- dans une telle trajectoire, une équipe plus junior peut progresser beaucoup plus vite si elle commence par un niveau de complexité qu'elle peut réellement absorber.

### 8.3 Données, intégration et migration
#### Interopérabilité / intégration SI
Explication simple:
- cela mesure si l'architecture sait bien parler aux autres systèmes,
- si GoodFood commande ici, comptabilise là, suit les réclamations ailleurs et gère les TPE dans un autre outil, tout doit se parler correctement.

Pourquoi ce critère existe dans GoodFood:
- la future application doit être accessible depuis d'autres solutions,
- le SI actuel comporte Dynamics 365, Sage, BNB, TPE, Microsoft 365, logistique.

#### Compatibilité avec un SI hybride
Explication simple:
- cela mesure si l'architecture sait vivre dans un monde mélangé: un peu de SaaS, un peu de serveur sur site, un peu de legacy,
- ce n'est pas un projet "page blanche".

Pourquoi ce critère existe dans GoodFood:
- le contexte décrit un SI mixte SaaS Microsoft + Sage on-prem + SQL Server + WCF + TPE + EBICS.

#### Cohérence des flux inter-applicatifs
Explication simple:
- cela mesure si les échanges entre applications restent compréhensibles, fiables et suivables,
- si une commande devient un paiement puis une écriture comptable, on doit savoir où elle passe et pourquoi.

Pourquoi ce critère existe dans GoodFood:
- l'existant a une synchro quotidienne à 5h vers l'ERP,
- la banque alimente Sage via EBICS,
- les informations remontent ensuite dans Dynamics.

#### Gestion de la qualité de données
Explication simple:
- cela mesure si l'architecture aide à garder des données propres, complètes et cohérentes,
- si certains franchisés saisissent mal ou partiellement leurs données, le système doit au moins limiter le chaos.

Pourquoi ce critère existe dans GoodFood:
- le contexte dit que de nombreux franchisés utilisent encore des outils internes comme des tableurs,
- certaines données ne sont pas toujours intégrées correctement dans l'ERP.

#### Maîtrise de la migration
Explication simple:
- cela mesure si on peut passer de l'ancien système au nouveau sans perdre les données ni casser la production,
- c'est comme changer le moteur d'une voiture pendant qu'elle roule: il faut une méthode très sûre.

Pourquoi ce critère existe dans GoodFood:
- la totalité des données doit être conservée,
- la migration doit se faire sans impact sur la production.

#### Résilience aux dépendances externes
Explication simple:
- cela mesure si l'architecture continue à fonctionner ou à se dégrader proprement quand un partenaire répond lentement ou tombe,
- si la banque, l'ERP ou un prestataire prend du retard, on ne veut pas que toute la plateforme s'effondre.

Pourquoi ce critère existe dans GoodFood:
- PWI, WIM, TP System et BNB sont critiques,
- le prestataire paiement met parfois 2 à 4 semaines à répondre à des demandes d'information.

### 8.4 Exploitation, sécurité, organisation et coût
#### Simplicité opérationnelle
Explication simple:
- cela mesure si la solution est simple à faire tourner, surveiller, corriger et déployer au quotidien,
- si chaque incident demande 10 outils, 5 spécialistes et 3 prestataires, l'exploitation devient pénible et risquée.

Pourquoi ce critère existe dans GoodFood:
- le service informatique interne est petit,
- il fait surtout du support N1,
- l'exploitation dépend déjà beaucoup de tiers.

#### Séparation des accès / sécurité fonctionnelle
Explication simple:
- cela mesure si l'architecture facilite la séparation des rôles et des droits,
- un client, un restaurateur, un livreur, la comptabilité et la communication ne doivent pas voir ni faire la même chose.

Pourquoi ce critère existe dans GoodFood:
- le périmètre cible couvre plusieurs profils utilisateurs,
- le sujet inclut paiement, comptabilité, livraison, réclamations et franchisés.

#### Compatibilité avec l'organisation SI / prestataires
Explication simple:
- cela mesure si l'architecture peut être pilotée dans une organisation où une partie des compétences reste externalisée,
- il faut une solution que GoodFood puisse vraiment gouverner, même si tout n'est pas fait en interne au début.

Pourquoi ce critère existe dans GoodFood:
- le SI est historiquement sous-traité,
- l'équipe interne est faible en développement au départ.

#### Sobriété / développement durable
Explication simple:
- cela mesure si l'architecture peut répondre au besoin métier sans surconsommer inutilement des serveurs, des ressources et des composants,
- une bonne architecture n'est pas seulement puissante, elle évite aussi le gaspillage.

Pourquoi ce critère existe dans GoodFood:
- la nouvelle solution doit être compatible avec l'engagement de développement durable de l'entreprise.

#### Coût initial
Explication simple:
- cela mesure l'effort financier de départ pour construire et mettre en route la solution,
- plus l'architecture demande d'outils, de composants et de compétences rares, plus elle coûte cher au début.

Pourquoi ce critère existe dans GoodFood:
- même si aucun budget chiffré n'est donné, le contexte décrit une transformation large avec nombreux acteurs, refonte complète, nouvelle application mobile, nouvelle architecture et migration.

#### Coût cumulé de transformation
Explication simple:
- cela mesure tout l'argent qu'il faut dépenser pour arriver vraiment au résultat final, pas seulement pour démarrer,
- on peut l'imaginer comme un voyage: payer le premier ticket n'est pas pareil que payer tout le trajet, les changements de train, les hôtels et les détours.

Pourquoi ce critère existe dans ce choix d'architecture:
- il sert a départager deux options qui peuvent viser une cible proche a terme,
- dans GoodFood, une trajectoire progressive peut être plus sûre, mais elle peut aussi coûter plus cher au total parce qu'elle additionne plusieurs étapes successives,
- ce critère n'est pas un `TCO à 3/5 ans`: ici, on mesure le coût du chemin de transformation lui-même.

#### Durée totale de transformation
Explication simple:
- cela mesure le temps nécessaire pour arriver réellement au point d'arrivée voulu,
- si deux enfants veulent aller au meme parc, l'un peut prendre une route directe et l'autre passer par plusieurs rues plus sûres: au final ils arrivent au meme parc, mais pas en meme temps.

Pourquoi ce critère existe dans ce choix d'architecture:
- il permet de ne pas mélanger la qualité de la cible finale et la longueur du chemin pour l'atteindre,
- dans GoodFood, une trajectoire progressive peut être meilleure pour sécuriser la migration, mais elle prend souvent plus de temps avant d'atteindre une architecture complètement distribuée,
- ce critère n'est pas du `time-to-market`: ici, on mesure la durée globale de la transformation, pas la date de sortie d'une première version.

## 9. Matrices de choix d'architecture par catégories
Échelle de notation:
- 1 = très défavorable
- 2 = défavorable
- 3 = acceptable
- 4 = favorable
- 5 = très favorable

Rappel des options:
- `Option 1` Monolithe modulaire modernisé
- `Option 2` Microservices full event-driven
- `Option 3` Trajectoire hybride progressive

Règle de lecture importante:
- certaines notes évaluent la `cible finale` de l'architecture une fois stabilisée,
- d'autres notes évaluent le `chemin de transformation` pour y arriver,
- si `Option 3` vise a terme une cible distribuée très proche de `Option 2`, alors elle ne doit pas être pénalisée sur les bénéfices finaux de cette cible,
- la vraie faiblesse de `Option 3` doit surtout apparaître sur le `coût cumulé de transformation` et la `durée totale de transformation`,
- les écarts restants entre `Option 2` et `Option 3` hors de ces deux critères concernent les sujets où la trajectoire change réellement le résultat: migration, coexistence avec le SI hybride, gouvernance et reprise en main.

### 9.1 Matrice A - Continuité de service et expérience utilisateur
| Critère | Poids | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|---:|
| Disponibilité de service | 5 | 3 | 5 | 5 |
| Scalabilité / tenue en charge | 5 | 2 | 5 | 5 |
| Support mobile et accessibilité | 4 | 4 | 5 | 5 |
| Adaptation aux franchises | 5 | 3 | 5 | 5 |
| Évolutivité fonctionnelle | 4 | 3 | 5 | 5 |
| Sous-total pondéré | - | 68 | 115 | 115 |

### 9.2 Matrice B - Construction logicielle et maîtrise technique
| Critère | Poids | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|---:|
| Maintenabilité de la solution | 5 | 4 | 4 | 5 |
| Modularité du découpage métier | 4 | 3 | 5 | 5 |
| Documentabilité / transférabilité | 4 | 4 | 4 | 4 |
| Réduction de dépendance technologique | 4 | 4 | 5 | 5 |
| Compatibilité avec la reprise en main du SI | 4 | 4 | 4 | 5 |
| Sous-total pondéré | - | 80 | 92 | 101 |

### 9.3 Matrice C - Données, intégration et migration
| Critère | Poids | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|---:|
| Interopérabilité / intégration SI | 5 | 4 | 5 | 5 |
| Compatibilité avec un SI hybride | 4 | 4 | 4 | 5 |
| Cohérence des flux inter-applicatifs | 4 | 4 | 3 | 4 |
| Gestion de la qualité de données | 4 | 3 | 4 | 5 |
| Maîtrise de la migration | 5 | 3 | 2 | 5 |
| Résilience aux dépendances externes | 4 | 3 | 5 | 5 |
| Sous-total pondéré | - | 91 | 99 | 126 |

### 9.4 Matrice D - Exploitation, sécurité, organisation et coût
| Critère | Poids | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|---:|
| Simplicité opérationnelle | 5 | 5 | 1 | 1 |
| Séparation des accès / sécurité fonctionnelle | 4 | 3 | 5 | 5 |
| Compatibilité avec l'organisation SI / prestataires | 4 | 4 | 2 | 4 |
| Sobriété / développement durable | 3 | 4 | 2 | 2 |
| Coût initial | 4 | 4 | 2 | 3 |
| Sous-total pondéré | - | 81 | 47 | 59 |

### 9.5 Matrice E - Coûts et temps de la trajectoire de transformation
| Critère | Poids | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|---:|
| Coût cumulé de transformation | 4 | 4 | 2 | 1 |
| Durée totale de transformation | 4 | 4 | 3 | 1 |
| Sous-total pondéré | - | 32 | 20 | 8 |

## 10. Matrice de synthèse - total réel par catégorie
| Catégorie | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|
| A. Continuité de service et expérience utilisateur | 68 | 115 | 115 |
| B. Construction logicielle et maîtrise technique | 80 | 92 | 101 |
| C. Données, intégration et migration | 91 | 99 | 126 |
| D. Exploitation, sécurité, organisation et coût | 81 | 47 | 59 |
| E. Coûts et temps de la trajectoire de transformation | 32 | 20 | 8 |
| Total final pondéré | 352 | 373 | 409 |

Lecture:
- `Option 1` reste forte sur la simplicité d'exploitation, la lisibilité opérationnelle et le ticket d'entrée, mais elle perd des points dès qu'il faut absorber de gros pics, multiplier les variantes franchises ou étendre fortement le périmètre.
- `Option 2` et `Option 3` obtiennent désormais des notes très proches sur les bénéfices de la cible distribuée, ce qui est logique puisqu'a terme elles visent pratiquement la même famille d'architecture.
- la différence principale entre `Option 2` et `Option 3` n'est donc plus "la qualité finale de la cible", mais "la manière d'y arriver":
- `Option 2` est meilleure en durée totale et en coût cumulé de transformation que `Option 3`, car elle évite les étapes intermédiaires,
- `Option 3` reste meilleure sur la migration, la coexistence avec le SI hybride, la reprise en main et la gouvernance réelle dans le contexte GoodFood.
- `Option 3` apporte aussi un bénéfice humain important: elle permet a une équipe plus junior de monter en compétence progressivement, sans être submergée trop tôt par toute la complexité d'une exploitation microservices complète.

Conclusion de la matrice d'architecture:
- sur la base des critères tirés du contexte seul, l'`Option 3 - trajectoire hybride progressive` est la meilleure,
- il ne faut pas lire ce résultat comme "l'architecture cible de l'option 3 est meilleure que la cible microservices",
- il faut le lire comme "dans le contexte GoodFood, la trajectoire progressive vers cette cible est globalement plus adaptée qu'une bascule directe",
- son vrai défaut est bien celui que tu as pointé: elle coûte plus cher au total et prend plus de temps pour arriver au bout,
- malgré cela, elle reste devant parce que GoodFood donne beaucoup de poids a la migration sans rupture, a la compatibilité avec le SI existant et a la maîtrise du risque de transformation.

## 11. Matrice de choix - stratégie anti-régression
Objectif:
- choisir une stratégie de tests réaliste pour GoodFood afin de réduire les régressions sans bloquer le delivery.

Échelle de notation:
- 1 = faible / défavorable
- 5 = fort / favorable

Options comparées:
- `A` Tests en fin de développement: écriture des tests après implémentation, souvent partielle.
- `B` TDD ciblé domaine + intégration: TDD sur le métier critique, complété par tests d'intégration, de contrat et E2E.
- `C` TDD généralisé sur toutes les couches: TDD systématique du domaine jusqu'aux couches périphériques.

| Critère | Poids | A Tests en fin | B TDD ciblé + intégration | C TDD généralisé |
|---|---:|---:|---:|---:|
| Réduction des régressions métier | 5 | 2 | 5 | 4 |
| Vitesse d'adoption par l'organisation | 4 | 4 | 4 | 2 |
| Coût de mise en place initial | 3 | 4 | 3 | 1 |
| Maintenabilité du code | 4 | 2 | 5 | 4 |
| Pertinence pour les flux critiques GoodFood | 5 | 2 | 5 | 4 |
| Compatibilité avec architecture distribuée | 4 | 2 | 5 | 4 |
| Risque de surcoût méthodologique | 3 | 4 | 3 | 1 |
| Total cumulé | - | 20 | 30 | 20 |
| Total pondéré | - | 62 | 112 | 80 |

Conclusion de la matrice:
- l'option `B` est la plus adaptée au contexte GoodFood,
- elle réduit fortement les régressions sur le métier critique,
- elle reste adoptable dans une organisation mixte SI/prestataires,
- elle évite le surcoût d'un TDD dogmatique sur toutes les couches.

## 12. Recommandation pragmatique pour GoodFood
### Recommandation principale
Option 3 (hybride progressive) est la plus robuste dans le contexte réel Good Food.

Pourquoi:
- elle réduit le risque de rupture sur une plateforme représentant 80% du CA,
- elle conserve votre vision microservices comme cible,
- elle s'aligne avec les contraintes prestataires et un pilotage progressif de la transformation,
- elle permet un pilotage budgétaire progressif.
- elle permet aussi une montée en compétence progressive d'une équipe plus junior, qui peut apprendre le découpage métier, l'intégration, l'observabilité et l'automatisation par étapes au lieu de tout affronter d'un coup.

### Positionnement de votre travail actuel
Votre architecture microservices (Option 2) est pertinente comme cible stratégique.
Pour sécuriser l'exécution, il est recommandé de la transformer en trajectoire incrémentale:
- phase 1: stabiliser et modulariser,
- phase 2: extraire services à plus fort ROI technique/métier,
- phase 3: industrialiser exploitation distribuée (Kubernetes, SLO, FinOps).

### Recommandation qualité / anti-régression
La pratique à retenir n'est pas "plus de tests" au sens vague, mais:
- TDD ciblé sur les règles métier critiques,
- tests d'intégration sur DB, broker et intégrations externes,
- tests de contrat entre services,
- tests end-to-end sur les parcours `catalogue -> panier -> paiement -> livraison`.

Cette approche est celle qui offre le meilleur compromis entre réduction des régressions, coût d'adoption et vitesse de livraison.

## 13. Plan macro de transition proposé
### Phase A (0-3 mois): sécuriser et fiabiliser
- observabilité minimale,
- gouvernance technique,
- pipeline CI/CD de base,
- baseline de tests anti-régression sur promotions, panier, paiement,
- cartographie détaillée des flux legacy.

### Phase B (3-9 mois): moderniser le coeur
- socle applicatif modernisé,
- découpage modulaire clair,
- TDD ciblé sur les domaines `commande`, `promotion`, `paiement`,
- anti-corruption layer pour ERP/banque/compta,
- migration data progressive sur domaines prioritaires.

### Phase C (9-18 mois): distribuer sélectivement
- extraction paiement/livraison/notification,
- event backbone, idempotence, DLQ, contrats d'événements,
- tests de contrat et d'intégration distribuée,
- industrialisation K8s/IaC/sécurité runtime.

## 14. Risques de projet à piloter explicitement
- Sous-estimation de la migration de données historiques.
- Dette d'intégration bancaire/comptable (EBICS, périmètres TPE hétérogènes).
- Surcharge de complexité si microservices introduits trop tôt.
- Échec d'adoption du TDD si appliqué de manière dogmatique et non ciblée.
- Verrouillage prestataires si la maîtrise documentaire et contractuelle n'est pas renforcée.
- Écart entre architecture cible et capacité réelle d'exploitation (run, support, sécurité).
