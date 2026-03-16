# Analyse consolidée GoodFood : contexte AS-IS, couverture des attentes client, points faibles, forces réutilisables et options d'architecture

## 1. Objet du document
Ce document consolide :
- l'analyse initiale du contexte GoodFood et des options d'architecture ;
- les retours du rapport critique de couverture.

L'objectif est d'obtenir un document unique qui :
- reprend le fond du premier travail ;
- corrige les angles morts identifiés dans le second ;
- démontre explicitement que les demandes client sont couvertes ou indique clairement ce qui reste partiel ;
- relie les faiblesses observées aux réponses architecturales proposées ;
- identifie aussi les forces du SI existant afin de les réutiliser au maximum.

## 2. Sources prises en compte
- `GoodFood/Consignes/contexte goodfood.pdf`
- `GoodFood/Consignes/Consignes Projet collaboratif Architecture logicielle_v2.pdf`
- `GoodFood/Consignes/Livrables.pdf`
- `GoodFood/Réalisation/Analyse/01_analyse_contexte_goodfood_asis_et_options.md`
- `GoodFood/Réalisation/Analyse/02_audit_critique_couverture_analyse_goodfood.md`
- `GoodFood/Réalisation/Rapport/Cadrage/Latex/mainmatter/note_de_cadrage.tex`
- `GoodFood/Réalisation/Details Technique/Plan_GoodFood_3.0.pdf`
- `GoodFood/Réalisation/Details Technique/Justification de l'architecture2.pdf`
- `GoodFood/Réalisation/Schéma/Actuel/GoodFood - C4-ASIS/*`
- `GoodFood/Réalisation/Schéma/Nouveau/GoodFood - C4/*`
- `Cours/Audit/4-SIEtArchitectureDuSI-etudiant-20260106.pdf`
- `Cours/Audit/7-AuditArchitectureApplicativeSI-etudiant-20260106.pdf`
- `Cours/Architecture Logiciel/Architectures logicielles et mise à l'échelle.pdf`

## 3. Synthèse du contexte et du périmètre
Good Food est une franchise de restauration de 150 restaurants répartis en France, Belgique et Luxembourg. La vente en ligne représente 80 % du chiffre d'affaires. Cela signifie que l'application de commande n'est pas un outil secondaire : c'est le coeur économique de l'entreprise.

Le SI existant est historiquement sous-traité et repose sur :
- une application de commande ASP.NET/C# legacy ;
- un hébergement PWI sur Windows Server 2008 R2 ;
- une base SQL Server 2008 propre à l'application ;
- une synchronisation quotidienne vers Dynamics 365 via une application C# WCF hébergée par WIM ;
- Microsoft 365 pour la messagerie du siège et des franchisés ;
- Sage sur site pour la trésorerie ;
- BNB, EBICS, TP System et les TPE pour les paiements et les flux financiers ;
- un site vitrine institutionnel Apache 2.2 / PHP / MySQL peu maintenu.

Le contexte impose simultanément :
- une forte disponibilité lors des pics de charge ;
- une migration sans rupture de production ;
- la conservation totale des données ;
- une meilleure maintenabilité ;
- une ouverture de l'architecture à d'autres solutions ;
- une reprise en main progressive par un futur pôle informatique interne ;
- une prise en compte du mobile, de l'accessibilité et du développement durable.

## 4. Ce que le client attend explicitement
Les attentes ne sont pas toutes de même nature. Certaines sont des objectifs de produit, d'autres des contraintes de transformation, d'autres encore des contraintes d'organisation.

### 4.1 Recommandations de l'audit DIW
- refondre intégralement l'application ;
- privilégier des technologies open source plutôt que de prolonger les solutions Microsoft legacy ;
- proposer une application mobile avec prise en compte de l'accessibilité ;
- refondre l'hébergement pour absorber les pics de charge ;
- fournir un service aux franchises et groupements pour commandes, préparations, fournisseurs et livraisons ;
- envisager un système d'aide à la décision.

### 4.2 Exigences explicites de Good Food
- conserver la totalité des données ;
- migrer sans impact sur la production ;
- documenter le code ;
- faire évoluer la solution en parallèle du déploiement d'un nouveau système de caisse ;
- rendre la nouvelle application accessible depuis d'autres solutions ;
- respecter le cahier des charges fonctionnel ;
- tenir compte du fait que DIW fera le design graphique et le développement mobile ;
- rester compatible avec l'engagement de développement durable.

### 4.3 Contraintes d'organisation et de transformation
- aucune compétence de développement interne au départ ;
- ancien prestataire obstructif et informations partielles ;
- prestataire paiement lent à répondre ;
- demandes des franchisés parfois contradictoires avec le cadre établi par le SI ;
- volonté de créer un vrai pôle informatique interne.

## 5. Matrice de traçabilité des attentes client
Cette section manquait dans l'analyse initiale. Elle sert à démontrer que les attentes ont bien été prises en compte.

Légende :
- `Oui` = couvert explicitement
- `Partiel` = traité mais pas encore complètement démontré
- `Non` = absent ou insuffisamment explicite

| Attente / contrainte | Faiblesse ou risque associé | Réponse architecturale attendue | Couverture dans ce document |
|---|---|---|---|
| Refonte complète | legacy non maintenable | refonte réelle, pas simple upgrade | Oui |
| Open source | obsolescence et verrouillage techno | stack moderne ouverte côté coeur applicatif | Oui |
| Mobile + accessibilité | absence mobile, UX insuffisante | API réutilisables, frontend/mobile découplés, design system accessible | Oui |
| Tenue aux pics de charge | perte de CA, lenteurs | hébergement scalable, découplage, observabilité | Oui |
| Service franchisé | demandes hétérogènes et variantes locales | domaine ou modules dédiés franchisés | Oui |
| Aide à la décision | faible capacité d'analyse | service analytique différable, intégré proprement plus tard | Oui |
| Conservation totale des données | perte de valeur et rupture métier | stratégie de migration progressive et reprise contrôlée | Oui |
| Migration sans impact prod | rupture d'activité | trajectoire incrémentale, strangler pattern, coexistence | Oui |
| Code documenté | dépendance humaine et dette de savoir | ADR, doc API, doc d'exploitation, ownership | Oui |
| Nouveau système de caisse | dépendance forte de planning et d'intégration | architecture d'intégration découplée et lot de transition dédié | Oui |
| Accessibilité depuis d'autres solutions | cloisonnement SI | API et contrats d'intégration | Oui |
| Conformité au cahier des charges fonctionnel | décalage entre architecture et besoin réel | cartographie fonctionnelle explicite et couverture par domaines | Oui |
| Rôle de DIW | dépendance fournisseur mal gouvernée | découpage clair des responsabilités et interfaces | Oui |
| Développement durable | architecture surdimensionnée ou gaspillage | sobriété, mutualisation, observabilité utile, éco-conception | Oui |
| Pas d'équipe dev interne au départ | incapacité à exploiter la cible | trajectoire progressive et montée en compétences | Oui |
| Prestataire obstructif | manque de connaissance legacy | reverse engineering et sécurisation documentaire | Oui |
| Prestataire paiement lent | blocage projet et risque d'intégration | contrats d'interface, simulateurs, anticipation du lot paiement | Oui |
| Contradictions franchisés / SI | backlog instable | gouvernance produit + architecture gérant les variantes | Oui |
| Reprise en main du SI | dépendance durable aux prestataires | architecture documentée, pilotable, progressive | Oui |

## 6. Forces du SI existant à réutiliser au maximum
L'analyse initiale était très forte sur les faiblesses, mais trop faible sur les forces. Or une bonne trajectoire d'architecture réutilise ce qui a déjà de la valeur.

| Force existante | Valeur actuelle | Réutilisation cible recommandée |
|---|---|---|
| Microsoft 365 déjà utilisé par le siège et les franchisés | outillage déjà connu et largement déployé | conserver comme socle de messagerie, support, notifications internes et conduite du changement |
| Dynamics 365 déjà déployé sur finance, RH, clients, stocks | référentiel et ERP déjà implantés | conserver comme système coeur de gestion transverse, éviter de refaire ce qui existe déjà |
| Sage + EBICS déjà en place | chaîne de trésorerie déjà opérationnelle | conserver l'existant trésorerie et intégrer proprement la nouvelle solution au lieu de refondre toute la finance |
| Réseau TPE déjà déployé via TP System | chaîne terrain déjà industrialisée | capitaliser sur ce réseau et limiter le changement au strict nécessaire côté intégration |
| Données historiques existantes | patrimoine métier majeur | utiliser comme base de migration, de reprise et de qualité de données |
| Habitudes numériques déjà présentes dans le réseau | réduit l'effort d'adoption | s'appuyer sur les usages existants pour l'onboarding de la cible |
| Prestataires déjà en place | continuité court terme | les utiliser comme filet de continuité pendant la transition, sans maintenir une dépendance forte à long terme |

## 7. Faiblesses et axes d'amélioration du SI existant

### 7.1 Gouvernance et organisation
| Constat | Impact | Criticité | Réponse attendue |
|---|---|---|---|
| Dépendance forte à PWI, WIM, TP System, BNB | faible maîtrise des priorités et de la connaissance | Élevée | reprendre la gouvernance, contractualiser les interfaces, documenter les périmètres |
| Équipe IT interne orientée support N1 | faible capacité d'évolution | Élevée | trajectoire progressive et montée en compétence structurée |
| Ancien prestataire obstructif et informations incomplètes | risque majeur d'erreur pendant la migration | Élevée | reverse engineering, cartographie, tests de caractérisation, documentation de reprise |
| Demandes franchisés contradictoires | backlog instable, dette fonctionnelle | Moyenne | gouvernance produit, variantes maîtrisées, arbitrage métier |
| Rôle de DIW et dépendances externes peu intégrés à la réflexion initiale | risque de trou de gouvernance | Moyenne | clarifier responsabilités, interfaces et points de passage |

### 7.2 Architecture applicative et technique
| Constat | Impact | Criticité | Réponse attendue |
|---|---|---|---|
| Monolithe legacy difficile à faire évoluer | coût de changement élevé, régressions | Élevée | modularisation forte ou extraction progressive des domaines |
| Windows Server 2008 R2 hors support | risque sécurité et support éditeur | Critique | sortie de la stack legacy |
| SQL Server 2008 | risque de support, dette data | Critique | stratégie de migration et découpage progressif |
| Synchronisation WCF quotidienne à 5h | latence et incohérences temporaires | Élevée | intégration progressive plus fréquente puis event-driven ou API |
| Site vitrine Apache 2.2 / PHP / MySQL peu maintenu | exposition sécurité et image | Élevée | remédiation ou retrait de ce composant de la zone de fragilité |
| Absence de mobile | expérience utilisateur insuffisante | Moyenne | app mobile ou PWA avancée, API stables |

### 7.3 Données, intégrations et qualité
| Constat | Impact | Criticité | Réponse attendue |
|---|---|---|---|
| Base unique SQL Server pour plusieurs préoccupations | couplage fort et migration délicate | Élevée | identifier les domaines de données et leur ownership |
| Franchisés utilisant tableurs et outils locaux | qualité de données hétérogène | Élevée | règles de complétude, gouvernance data, interfaces plus propres |
| Réclamations multi-canaux | vision client fragmentée | Moyenne | workflow unifié et traçage dans le SI cible |
| Chaînes BNB / EBICS / Sage / groupements | flux critiques et hétérogènes | Élevée | journalisation bout en bout, contrats d'échange et supervision métier |
| Nouveau système de caisse déployé en parallèle | risque de dépendance planning et de couplage | Élevée | lot d'intégration spécifique, interfaces stables, séquencement maîtrisé |

### 7.4 Sécurité, exploitation et fiabilité
| Constat | Impact | Criticité | Réponse attendue |
|---|---|---|---|
| Pics de charge mal absorbés | perte de CA, mauvaise UX | Critique | architecture scalable et observabilité |
| Faible visibilité interne sur l'exploitation | incidents mal compris et peu pilotés | Élevée | observabilité et SLI/SLO pilotés par GoodFood |
| Contrôle d'accès transversal peu explicite | risque d'accès non maîtrisé | Élevée | IAM, RBAC, séparation claire des rôles |
| Déploiements risqués | incidents de mise en prod | Élevée | CI/CD, préproduction, déploiements progressifs |

## 8. Exigences non fonctionnelles de référence
Ces exigences servent à sélectionner le style d'architecture. Elles sont issues du contexte et consolidées par le rapport critique.

### 8.1 Continuité de service et expérience
- disponibilité de service ;
- scalabilité / tenue en charge ;
- support mobile et accessibilité ;
- adaptation aux franchises ;
- évolutivité fonctionnelle.

### 8.2 Construction logicielle et maîtrise technique
- maintenabilité de la solution ;
- modularité du découpage métier ;
- documentabilité / transférabilité ;
- réduction de dépendance technologique ;
- compatibilité avec la reprise en main du SI.

### 8.3 Données, intégration et migration
- interopérabilité / intégration SI ;
- compatibilité avec un SI hybride ;
- cohérence des flux inter-applicatifs ;
- gestion de la qualité de données ;
- maîtrise de la migration ;
- résilience aux dépendances externes.

### 8.4 Exploitation, sécurité, organisation et coût
- simplicité opérationnelle ;
- séparation des accès / sécurité fonctionnelle ;
- compatibilité avec l'organisation SI / prestataires ;
- sobriété / développement durable ;
- coût initial ;
- coût cumulé de transformation ;
- durée totale de transformation.

## 9. Contraintes éliminatoires ou quasi éliminatoires
Le retour critique a montré qu'il ne faut pas tout traiter comme un simple score de matrice. Certaines contraintes sont quasiment obligatoires.

### 9.1 Contraintes éliminatoires
- conservation totale des données ;
- migration sans impact production ;
- interopérabilité avec l'écosystème existant ;
- capacité à supporter les pics de charge ;
- possibilité réelle de reprise en main par GoodFood.

### 9.2 Contraintes quasi éliminatoires
- documentation sérieuse du code et de l'architecture ;
- intégration avec le nouveau système de caisse ;
- gouvernance claire avec DIW et les autres prestataires ;
- compatibilité avec le service franchisé ;
- sécurité et séparation des accès.

Une option qui échoue frontalement sur une contrainte éliminatoire ne doit pas seulement perdre quelques points : elle devient très difficile à retenir dans le contexte GoodFood.

## 10. Options d'architecture comparées

### 10.1 Option 1 - Monolithe modulaire modernisé
Description :
- refonte du monolithe actuel sur une stack moderne ;
- séparation interne stricte par modules métier ;
- API unique pour exposer les capacités aux autres systèmes.

Ce que cette option couvre bien :
- simplicité d'exploitation ;
- montée en compétence plus facile ;
- documentation plus simple si discipline stricte ;
- modernisation rapide du coeur ;
- prise en compte possible du mobile via une API unique.

Ce qu'elle couvre moins bien :
- variabilité franchise à long terme ;
- scalabilité fine par domaine ;
- forte croissance future ;
- analytique et domaines avancés plus difficiles à faire évoluer indépendamment.

Traitement des attentes client :
- données : Oui ;
- migration sans rupture : Partiel ;
- mobile : Oui ;
- service franchisé : Partiel ;
- nouveau système de caisse : Oui si API et découplage propres ;
- DIW : Oui mais sans avantage particulier ;
- développement durable : plutôt favorable grâce à une moindre complexité infra.

### 10.2 Option 2 - Microservices full event-driven
Description :
- services séparés par domaine ;
- API Gateway ;
- broker d'événements ;
- base par service ;
- orchestration distribuée.

Ce que cette option couvre bien :
- scalabilité ;
- découpage métier ;
- extension fonctionnelle ;
- service franchisé avancé ;
- analytique ultérieur ;
- résilience et intégration à terme.

Ce qu'elle couvre moins bien :
- migration sans rupture si prise comme première étape ;
- maturité d'exploitation ;
- capacité d'appropriation par une équipe encore peu expérimentée ;
- dépendances multiples avec prestataires pendant la transition.

Traitement des attentes client :
- données : Oui ;
- migration sans rupture : Faible si bascule directe ;
- mobile : Oui ;
- service franchisé : Oui ;
- nouveau système de caisse : Oui mais plus complexe à intégrer au départ ;
- DIW : Oui via contrats d'interface, mais gouvernance plus exigeante ;
- développement durable : risque de surdimensionnement si mal opéré.

### 10.3 Option 3 - Trajectoire hybride progressive
Description :
- construction d'un coeur modulaire moderne ;
- extraction progressive des domaines les plus sensibles ;
- strangler pattern ;
- coexistence maîtrisée avec le legacy et le SI hybride ;
- convergence vers une cible distribuée proche de l'option 2.

Ce que cette option couvre bien :
- migration sans rupture ;
- conservation des données ;
- intégration avec le SI existant ;
- montée en compétence progressive ;
- gestion réaliste des prestataires ;
- évolution vers un service franchisé robuste ;
- intégration progressive du mobile et du nouveau système de caisse.

Ce qu'elle couvre moins bien :
- coût cumulé de transformation ;
- durée totale de transformation ;
- complexité de coexistence pendant la transition.

Traitement des attentes client :
- données : Oui ;
- migration sans rupture : Oui ;
- mobile : Oui ;
- service franchisé : Oui ;
- nouveau système de caisse : Oui, c'est l'option la plus réaliste pour l'absorber ;
- DIW : Oui, car elle permet de séquencer clairement les responsabilités ;
- développement durable : moyen à bon si la trajectoire évite le double run trop long.

## 11. Matrices de choix d'architecture
Échelle de notation :
- 1 = très défavorable
- 2 = défavorable
- 3 = acceptable
- 4 = favorable
- 5 = très favorable

Rappel :
- `Option 1` = Monolithe modulaire modernisé
- `Option 2` = Microservices full event-driven
- `Option 3` = Trajectoire hybride progressive

### 11.1 Matrice A - Continuité de service et expérience utilisateur
| Critère | Poids | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|---:|
| Disponibilité de service | 5 | 3 | 5 | 5 |
| Scalabilité / tenue en charge | 5 | 2 | 5 | 5 |
| Support mobile et accessibilité | 4 | 4 | 5 | 5 |
| Adaptation aux franchises | 5 | 3 | 5 | 5 |
| Évolutivité fonctionnelle | 4 | 3 | 5 | 5 |
| Sous-total pondéré | - | 68 | 115 | 115 |

### 11.2 Matrice B - Construction logicielle et maîtrise technique
| Critère | Poids | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|---:|
| Maintenabilité de la solution | 5 | 4 | 4 | 5 |
| Modularité du découpage métier | 4 | 3 | 5 | 5 |
| Documentabilité / transférabilité | 4 | 4 | 4 | 4 |
| Réduction de dépendance technologique | 4 | 4 | 5 | 5 |
| Compatibilité avec la reprise en main du SI | 4 | 4 | 4 | 5 |
| Sous-total pondéré | - | 80 | 92 | 101 |

### 11.3 Matrice C - Données, intégration et migration
| Critère | Poids | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|---:|
| Interopérabilité / intégration SI | 5 | 4 | 5 | 5 |
| Compatibilité avec un SI hybride | 4 | 4 | 4 | 5 |
| Cohérence des flux inter-applicatifs | 4 | 4 | 3 | 4 |
| Gestion de la qualité de données | 4 | 3 | 4 | 5 |
| Maîtrise de la migration | 5 | 3 | 2 | 5 |
| Résilience aux dépendances externes | 4 | 3 | 5 | 5 |
| Sous-total pondéré | - | 91 | 99 | 126 |

### 11.4 Matrice D - Exploitation, sécurité, organisation et coût
| Critère | Poids | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|---:|
| Simplicité opérationnelle | 5 | 5 | 1 | 1 |
| Séparation des accès / sécurité fonctionnelle | 4 | 3 | 5 | 5 |
| Compatibilité avec l'organisation SI / prestataires | 4 | 4 | 2 | 4 |
| Sobriété / développement durable | 3 | 4 | 2 | 3 |
| Coût initial | 4 | 4 | 2 | 3 |
| Sous-total pondéré | - | 81 | 47 | 62 |

### 11.5 Matrice E - Coûts et temps de la trajectoire de transformation
| Critère | Poids | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|---:|
| Coût cumulé de transformation | 4 | 4 | 2 | 1 |
| Durée totale de transformation | 4 | 4 | 3 | 1 |
| Sous-total pondéré | - | 32 | 20 | 8 |

### 11.6 Matrice de synthèse
| Catégorie | Option 1 | Option 2 | Option 3 |
|---|---:|---:|---:|
| A. Continuité de service et expérience utilisateur | 68 | 115 | 115 |
| B. Construction logicielle et maîtrise technique | 80 | 92 | 101 |
| C. Données, intégration et migration | 91 | 99 | 126 |
| D. Exploitation, sécurité, organisation et coût | 81 | 47 | 62 |
| E. Coûts et temps de la trajectoire de transformation | 32 | 20 | 8 |
| Total final pondéré | 352 | 373 | 412 |

### 11.7 Lecture critique de la matrice
- l'option 1 est forte quand on cherche de la simplicité immédiate ;
- l'option 2 est excellente comme cible finale mais faible comme première trajectoire ;
- l'option 3 est la meilleure dans le contexte GoodFood parce qu'elle absorbe le risque de migration, le SI hybride, le manque de compétences initiales et la dépendance prestataire ;
- l'option 3 coûte plus cher au total et prend plus de temps, mais elle répond mieux aux contraintes éliminatoires.

## 12. Couverture détaillée des attentes client par l'option recommandée
Cette section répond explicitement au reproche principal du rapport critique : il faut montrer que l'option retenue couvre les attentes, pas seulement qu'elle obtient un meilleur score.

| Attente client | Réponse de l'option 3 | Niveau de couverture |
|---|---|---|
| Refonte intégrale | coeur modernisé puis extractions progressives | Oui |
| Open source | adoption sur le coeur cible, en conservant si nécessaire M365/Dynamics comme systèmes existants déjà déployés | Oui |
| Mobile + accessibilité | APIs réutilisables, découplage web/mobile, lot DIW dédié avec design system accessible | Oui |
| Pics de charge | services critiques extraits en priorité, scalabilité ciblée | Oui |
| Service franchisé | domaine ou module dédié, extractible si besoin | Oui |
| Aide à la décision | différée en service secondaire, non bloquante pour la première mise en valeur | Oui |
| Conservation des données | migration progressive domaine par domaine | Oui |
| Migration sans impact prod | strangler pattern, coexistence, bascules incrémentales | Oui |
| Code documenté | ADR, documentation as code, doc API, conventions, ownership | Oui |
| Nouveau système de caisse | lot d'intégration séparé, interfaces stables, absorption progressive | Oui |
| Accessibilité depuis d'autres solutions | API et contrats d'intégration | Oui |
| Cahier des charges fonctionnel | cartographie cible par domaines métier | Oui |
| Rôle de DIW | responsabilités explicites sur design et mobile, interfaces maîtrisées avec le coeur SI | Oui |
| Développement durable | trajectoire évitant le surdimensionnement initial, observabilité pour ajuster, découplage utile mais progressif | Oui |

## 13. Rôle explicite des partenaires et du programme de transformation
Cette section est ajoutée car elle manquait dans l'analyse initiale.

### 13.1 DIW
DIW n'est pas seulement un prestataire périphérique. Le contexte lui donne deux responsabilités fortes :
- conception graphique ;
- développement de l'application mobile.

Conséquences architecturales :
- l'architecture doit fournir des contrats d'API stables pour l'app mobile ;
- le design system et les règles d'accessibilité doivent être gouvernés ;
- la séparation des responsabilités doit être explicite entre coeur métier, UX et mobile ;
- le planning DIW doit être coordonné avec la stabilisation du backend.

### 13.2 Nouveau système de caisse
Le contexte impose une évolution concomitante avec un nouveau système de caisse.

Conséquences architecturales :
- il faut un lot d'intégration spécifique ;
- il faut éviter que le projet de caisse bloque toute la transformation ;
- les interfaces commande/paiement/encaissement doivent être contractualisées ;
- ce sujet doit être traité comme dépendance de programme majeure, pas comme détail d'intégration.

### 13.3 Reverse engineering du legacy
Vu l'obstruction de l'ancien prestataire, il faut un chantier explicite de récupération de connaissance :
- cartographie des flux ;
- tests de caractérisation ;
- inventaire des règles métier cachées ;
- documentation de reprise ;
- stratégie de retrait progressif des zones les plus obscures.

## 14. Approche TDD et anti-régression
L'analyse initiale avait raison d'ajouter un axe TDD. Il reste pertinent dans la version consolidée.

### 14.1 Pourquoi c'est important ici
GoodFood a des bugs récurrents sur des zones directement liées au revenu :
- promotions ;
- panier ;
- paiement ;
- expérience client.

Le TDD ne résout pas tout, mais il aide à figer les règles métier avant modification.

### 14.2 Stratégie recommandée
- TDD ciblé sur les domaines critiques ;
- tests d'intégration sur DB, ERP, banque, caisse et événements ;
- tests de contrat entre services ;
- E2E sur les parcours critiques.

### 14.3 Matrice anti-régression
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

Conclusion :
- l'option `B TDD ciblé + intégration` reste la plus adaptée.

## 15. Recommandation finale
### 15.1 Option retenue
L'option à retenir est l'`Option 3 - trajectoire hybride progressive`.

### 15.2 Pourquoi cette option est la meilleure
- elle traite le principal risque de GoodFood : la migration sans rupture ;
- elle respecte le SI hybride existant ;
- elle permet de garder et réutiliser les forces du SI actuel ;
- elle laisse converger vers une vraie cible moderne ;
- elle permet à une équipe plus junior de progresser sans être noyée trop tôt dans toute la complexité d'une exploitation microservices complète ;
- elle absorbe mieux les dépendances DIW, caisse, paiement et legacy.

### 15.3 Ce qu'il faut éviter
- croire qu'un full microservices immédiat résoudra à lui seul les problèmes d'organisation ;
- sous-estimer le lot `nouveau système de caisse` ;
- oublier la récupération de connaissance legacy ;
- négliger le site vitrine parce qu'il n'est pas coeur métier ;
- traiter la documentation comme un effet secondaire et non comme un livrable d'architecture.

## 16. Plan de transition consolidé
### Phase 0 - Sécurisation et connaissance
- cartographier le legacy et les flux réels ;
- sécuriser l'existant ;
- documenter les interfaces ;
- cadrer DIW et le lot caisse ;
- mettre en place les tests de caractérisation.

### Phase 1 - Coeur modernisé
- construire le coeur modulaire ;
- exposer les APIs ;
- préparer mobile et service franchisé ;
- maintenir l'intégration avec ERP, BNB, Sage et TPE.

### Phase 2 - Migration progressive et montée en valeur
- migrer les données domaine par domaine ;
- introduire les premiers services à forte valeur ;
- traiter les pics de charge sur les zones critiques ;
- absorber le nouveau système de caisse sans big bang.

### Phase 3 - Distribution sélective
- extraire paiement, livraison, notification, éventuellement analytique ;
- renforcer observabilité, sécurité runtime et automatisation ;
- limiter progressivement la dépendance aux prestataires historiques.

## 17. Verdict final
Le premier document allait dans la bonne direction, mais il laissait plusieurs zones implicites. Le second document a bien révélé ces manques. La présente version consolidée permet maintenant de dire plus proprement que :
- les demandes client sont identifiées ;
- les faiblesses principales sont couvertes ;
- les forces du SI existant sont réutilisées ;
- l'option retenue est justifiée non seulement par un score, mais par sa capacité réelle à répondre au contexte GoodFood.

Position finale :
- `Option 2` reste une très bonne cible technique ;
- `Option 3` reste la meilleure réponse architecturale et organisationnelle dans le contexte réel GoodFood.
