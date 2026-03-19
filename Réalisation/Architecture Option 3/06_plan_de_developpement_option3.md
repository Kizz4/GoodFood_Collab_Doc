# Plan de developpement - Option 3

## 1. Objet du document

Ce document propose un plan de developpement pour GoodFood aligne sur l'`Option 3 - hybride progressive`.

L'objectif est de decouper la mise en oeuvre en phases principales :
- nommees de facon lisible ;
- bornees par des durees indicatives ;
- ordonnees selon les dependances reelles ;
- sous-decoupees en chantiers concrets ;
- pilotables avec des jalons et des criteres de passage.

Le principe directeur retenu reste :
- d'abord stabiliser et structurer ;
- ensuite mettre en place un coeur `modulith` propre ;
- organiser la coexistence et la transition des le debut ;
- basculer d'abord les parcours client et les services les plus critiques ;
- puis extraire progressivement le reste quand la valeur et le contexte le justifient.

## 2. Principes de pilotage

Le plan repose sur quelques regles simples.

- ne pas lancer trop tot une distribution complete tant que le coeur n'est pas stabilise ;
- traiter d'abord les risques de run, de qualite et de connaissance legacy ;
- prioriser les domaines a plus forte valeur metier et technique, en commencant par les parcours client ;
- garder la continuite de service comme contrainte non negociable ;
- faire commencer la transition des la mise en place du `modulith`, et non uniquement a la fin ;
- basculer progressivement flux, domaines et trafic au fur et a mesure des phases ;
- faire converger la documentation, les schemas, les contrats et le code a chaque phase.

## 3. Vue d'ensemble du phasage

Le planning ci-dessous est indicatif pour une trajectoire complete de l'ordre de `16 a 18 mois`.
Il suppose une equipe reduite a moyenne, une montee en competence progressive, et une cohabitation temporaire avec le legacy.

| Phase | Nom | Duree indicative | Finalite principale | Mouvement de transition |
|---|---|---|---|---|
| Phase 0 | Cadrer et securiser | `0-2 mois` | rendre l'existant pilotable et reduire le risque de transformation | aucune bascule fonctionnelle, uniquement preparation |
| Phase 1 | Construire le socle moderne | `2-4 mois` | mettre en place les fondations techniques et la structure du futur `modulith` | preparation de la coexistence et du strangler |
| Phase 2 | Mettre en service le coeur client modulithique | `4-8 mois` | livrer le noyau `Customer + Catalog + Order` et les premiers parcours client | premieres bascules progressives cote client |
| Phase 3 | Etendre le modulith et organiser la coexistence | `8-11 mois` | couvrir franchise, preparation, fournisseurs et reclamations | extension de la bascule domaine par domaine |
| Phase 4 | Extraire les microservices critiques prioritaires | `11-14 mois` | sortir les services a plus forte valeur client et technique | bascule des services critiques les uns apres les autres |
| Phase 5 | Industrialiser et etendre la distribution | `14-16 mois` | fiabiliser la plateforme distribuee et extraire le reste si utile | poursuite selective de la transition |
| Phase 6 | Finaliser la sortie du legacy | `16-18 mois` | reduire le residuel legacy, decommissionner et stabiliser | fermeture progressive des derniers flux historiques |

## 4. Logique de transition progressive

La transition n'est pas concentree dans une phase finale.
Avec l'`Option 3`, elle commence des que le `modulith` est assez propre pour porter une partie du trafic utile.

La logique recommandee est la suivante :
- `Phase 0` : on prepare, on cartographie et on securise ;
- `Phase 1` : on construit le socle et on prepare la coexistence technique ;
- `Phase 2` : on bascule progressivement les premiers parcours client sur le `modulith` ;
- `Phase 3` : on etend cette bascule aux capacites magasin et support les plus stables ;
- `Phase 4` : on extrait puis on bascule les services critiques un par un, en commencant par ceux qui ont le plus d'impact client ;
- `Phase 5` : on continue la distribution seulement la ou elle apporte un gain clair ;
- `Phase 6` : on retire ce qu'il reste du legacy devenu inutile.

## 5. Phase 0 - Cadrer et securiser

### 5.1 Objectif

Avant de construire, il faut reprendre la maitrise du terrain :
- comprendre les flux reels ;
- reduire les risques immediats ;
- poser la gouvernance projet et technique.

Duree indicative :
- `0 a 2 mois`

### 5.2 Sous-phases

#### 5.2.1 Gouvernance et cadrage produit

Travaux :
- clarifier les parties prenantes et les responsabilites ;
- construire un backlog priorise commun metier / technique ;
- definir les jalons, le perimetre MVP et les arbitres de decision ;
- figer les conventions documentaires et les ADR.

Livrables :
- gouvernance projet ;
- RACI ;
- backlog priorise ;
- feuille de route macro.

#### 5.2.2 Cartographie du legacy et des integrations

Travaux :
- documenter les flux reellement en production ;
- cartographier les dependances vers `Dynamics 365`, `Sage`, `BNB`, `TP System`, `M365` ;
- identifier les proprietaires de donnees et les points de couplage forts ;
- relever les zones les plus risquantes pour la migration.

Livrables :
- cartographie applicative et flux ;
- inventaire des interfaces ;
- registre des dependances critiques.

#### 5.2.3 Securisation et observabilite minimale

Travaux :
- renforcer les sauvegardes et les tests de restauration ;
- centraliser un socle minimal de logs et d'alertes ;
- mettre sous surveillance les flux critiques : commande, paiement, synchro ERP, reclamations ;
- definir les premiers indicateurs de sante.

Livrables :
- tableau de supervision minimum ;
- journalisation cible des flux critiques ;
- liste des alertes prioritaires.

#### 5.2.4 Socle qualite et anti-regression

Travaux :
- mettre en place le repository principal, la strategie de branches et les revues ;
- construire la pipeline CI/CD de base ;
- ecrire des tests de caracterisation sur promotions, panier, commande et paiement ;
- cadrer la pratique `TDD cible + tests d'integration`.

Livrables :
- pipeline CI/CD initiale ;
- socle de tests anti-regression ;
- conventions de qualite et definition of done.

### 5.3 Criteres de sortie

- l'existant est documente de facon exploitable ;
- les flux critiques sont visibles et surveilles ;
- le projet dispose d'un backlog priorise et d'un cadre de pilotage ;
- la base qualite permet de modifier le coeur sans aveuglement.

## 6. Phase 1 - Construire le socle moderne

### 6.1 Objectif

Mettre en place les fondations techniques de la cible, structurer le futur `modulith` et preparer la coexistence avec le legacy.

Duree indicative :
- `2 a 4 mois`

### 6.2 Sous-phases

#### 6.2.1 Socle d'architecture et conventions

Travaux :
- creer le squelette de la solution cible ;
- definir les frontieres modulaires internes ;
- standardiser les conventions d'API, d'erreurs, de logs, de correlation et de versioning ;
- preparer le modele de configuration par environnement.

Livrables :
- squelette applicatif ;
- conventions d'architecture ;
- premier ADR de structure du coeur.

#### 6.2.2 Edge et securite d'entree

Travaux :
- mettre en place `API Gateway` ;
- configurer `Keycloak` ;
- definir les roles et perimetres d'acces ;
- brancher les applications web et mobiles a l'entree unifiee.

Livrables :
- facade d'entree unique ;
- IAM operationnel ;
- modele RBAC initial.

#### 6.2.3 Environnements de developpement et d'integration

Travaux :
- fournir un `Docker Compose` local coherent ;
- preparer les environnements de dev / test ;
- poser les bases de `RabbitMQ`, `Redis`, `PostgreSQL`, observabilite et logs ;
- automatiser le provisioning minimum.

Livrables :
- environnement local reproductible ;
- environnement d'integration de base ;
- scripts de lancement et doc d'installation.

#### 6.2.4 Preparation de la transition technique

Travaux :
- definir la strategie de coexistence `legacy + modulith` ;
- preparer le routage progressif via `API Gateway` ;
- identifier les premiers flux et ecrans client a basculer ;
- cadrer les besoins de doubles lectures, synchros temporaires ou strangler.

Livrables :
- strategie de transition technique ;
- cartographie des premiers flux de bascule ;
- regles de coexistence temporaire.

### 6.3 Criteres de sortie

- les equipes peuvent developper et tester sur un socle commun ;
- l'entree `API Gateway + IAM` est utilisable ;
- les outils de base d'integration et d'infrastructure sont en place ;
- la methode de coexistence et de bascule initiale est definie.

## 7. Phase 2 - Mettre en service le coeur client modulithique

### 7.1 Objectif

Construire le noyau modulaire qui portera la valeur principale et commencer a basculer les parcours client prioritaires sur ce nouveau coeur.

Duree indicative :
- `4 a 8 mois`

Priorite metier :
- consultation catalogue ;
- panier ;
- commande ;
- paiement en ligne ;
- premiers parcours mobile client.

### 7.2 Sous-phases

#### 7.2.1 Module `Customer`

Travaux :
- gestion compte, profil et donnees d'identite utiles ;
- alignement avec `IAM` ;
- preparation des APIs web et mobile.

Livrables :
- module `Customer` stable ;
- APIs de profil et compte ;
- mapping identite / metier.

#### 7.2.2 Module `Catalog`

Travaux :
- modeliser le catalogue de base ;
- mettre en place la projection catalogue resolue par restaurant ;
- brancher `Redis` pour les lectures chaudes ;
- cadrer les evenements de mise a jour du catalogue.

Livrables :
- module `Catalog` ;
- `Catalog DB` avec vues resolues ;
- cache et strategie d'invalidation.

#### 7.2.3 Module `Order`

Travaux :
- gerer panier, commande et statuts principaux ;
- stocker le snapshot commercial de checkout ;
- supprimer la dependance synchrone `Order -> Catalog` dans le fonctionnement ;
- poser les premiers evenements de commande.

Livrables :
- module `Order` ;
- flux `catalogue -> commande` stabilise ;
- modele de statuts et evenements principaux.

#### 7.2.4 Front web et mobile sur le coeur

Travaux :
- livrer le parcours consultation catalogue ;
- livrer le panier et le checkout en ligne ;
- exposer les premiers parcours mobiles utiles ;
- assurer la coherence UX et l'accessibilite.

Livrables :
- premier parcours client bout en bout ;
- APIs front stabilisees ;
- base UI web/mobile.

#### 7.2.5 Premiere bascule progressive des parcours client

Travaux :
- faire passer progressivement les lectures catalogue vers le nouveau coeur ;
- basculer le panier et la commande en ligne par lots ou par flux ;
- surveiller les ecarts fonctionnels et les regressions ;
- conserver des mecanismes de repli si necessaire.

Livrables :
- premieres routes client basculees ;
- tableau de suivi de bascule ;
- plan de rollback par parcours critique.

### 7.3 Criteres de sortie

- le coeur `Customer + Catalog + Order` est exploitable ;
- la consultation et la commande en ligne fonctionnent sur le nouveau socle ;
- une premiere partie des parcours client est deja basculee ;
- les regles critiques de promotions, panier et commande sont couvertes par les tests.

## 8. Phase 3 - Etendre le modulith et organiser la coexistence

### 8.1 Objectif

Completer le `modulith` avec les capacites metier qui enrichissent l'exploitation franchise et le support, tout en poursuivant la transition domaine par domaine.

Duree indicative :
- `8 a 11 mois`

### 8.2 Sous-phases

#### 8.2.1 `Local Assortment Service`

Travaux :
- gerer prix locaux, promotions, stock et disponibilite par restaurant ;
- publier les evenements de mise a jour ;
- synchroniser la projection catalogue resolue.

Livrables :
- service d'assortiment local ;
- contrat d'evenements de mise a jour ;
- projection catalogue alimentee automatiquement.

#### 8.2.2 `Supplier Service`

Travaux :
- modeliser les fournisseurs et contraintes de sourcing ;
- definir les synchronisations utiles vers l'ERP ;
- preparer la gouvernance des donnees fournisseurs.

Livrables :
- service fournisseurs ;
- premiers flux de synchronisation ;
- modele de donnees de sourcing.

#### 8.2.3 `Preparation Service`

Travaux :
- gerer l'avancement preparation restaurant ;
- publier l'evenement `OrderReadyForDelivery` ;
- relier le rythme magasin a la suite du flux.

Livrables :
- service preparation ;
- workflow de preparation ;
- integration avec la suite du parcours commande.

#### 8.2.4 `Complaint Service`

Travaux :
- unifier les reclamations ;
- standardiser les statuts et le workflow support ;
- preparer les integrations notification / back-office.

Livrables :
- service reclamations ;
- parcours support initial ;
- modele de suivi unifie.

#### 8.2.5 Bascule progressive des capacites secondaires

Travaux :
- basculer progressivement les mises a jour d'assortiment, la preparation et les reclamations ;
- organiser les synchronisations transitoires avec le legacy quand elles restent necessaires ;
- verifier que les equipes magasin et support disposent bien des nouveaux parcours.

Livrables :
- flux franchise et support bascules par lots ;
- plan de coexistence mis a jour ;
- suivi de stabilisation par domaine.

### 8.3 Criteres de sortie

- les capacites franchise et support ne sont plus fondues dans un bloc flou ;
- les mises a jour locales alimentent correctement le catalogue ;
- les reclamations et la preparation sont prises en charge par des perimetres clairs ;
- la coexistence legacy / nouveau coeur est sous controle sur plusieurs domaines.

## 9. Phase 4 - Extraire les microservices critiques prioritaires

### 9.1 Objectif

Sortir du coeur les domaines qui apportent le plus de valeur a l'extraction en priorisant ceux qui ont le plus d'impact client ou de pression technique.

Duree indicative :
- `11 a 14 mois`

Priorite recommandee :
- `Payment Service`
- `Notification Service`
- `Delivery Service`
- `Integration Hub / ACL`

### 9.2 Sous-phases

#### 9.2.1 `Integration Hub / ACL`

Travaux :
- isoler les integrations externes ;
- absorber les contrats legacy et les evolutions du nouveau systeme de caisse ;
- standardiser les echanges vers `Dynamics 365`, `Sage`, `M365`, `TP System`.

Livrables :
- couche ACL operationnelle ;
- contrats d'integration versionnes ;
- suivi des erreurs et reprises.

#### 9.2.2 `Payment Service` - priorite client 1

Travaux :
- extraire le paiement en ligne ;
- isoler l'adapter `BNB / PSP` ;
- tracer les autorisations et echecs de paiement ;
- renforcer l'auditabilite et les tests.

Livrables :
- service paiement en ligne ;
- persistence dediee ;
- contrat d'evenements de paiement.

#### 9.2.3 `Notification Service` - priorite client 2

Travaux :
- centraliser emails, SMS et push ;
- brancher `SendGrid`, `Twilio`, `Firebase` ;
- transformer les effets de bord en traitements propres et testables.

Livrables :
- service notification ;
- templates et routage ;
- traces d'emission.

#### 9.2.4 `Delivery Service` - priorite client 3

Travaux :
- extraire la gestion de mission, tracking, ETA et preuve de livraison ;
- brancher `Google Maps` ;
- connecter l'application livreur.

Livrables :
- service livraison ;
- base `MongoDB` de tracking ;
- parcours livreur cible.

#### 9.2.5 Bascule service par service

Travaux :
- extraire puis mettre en service les microservices un par un ;
- ne jamais lancer plusieurs bascules critiques sans stabilisation intermediaire ;
- basculer en priorite les parcours client ayant le plus d'impact ;
- mesurer l'effet sur la performance, la disponibilite et l'exploitation.

Livrables :
- planning de bascule par service critique ;
- tableau de stabilisation post-bascule ;
- retour d'experience par extraction.

### 9.3 Criteres de sortie

- les domaines critiques sont isoles ;
- les integrations externes ne polluent plus le coeur ;
- la valeur d'une architecture partiellement distribuee devient visible ;
- plusieurs services critiques ont deja ete bascules en production.

## 10. Phase 5 - Industrialiser et etendre la distribution

### 10.1 Objectif

Passer d'une architecture techniquement juste a une architecture reellement exploitable a l'echelle, puis etendre la distribution seulement la ou cela a encore du sens.

Duree indicative :
- `14 a 16 mois`

### 10.2 Sous-phases

#### 10.2.1 Backbone evenementiel et fiabilite

Travaux :
- fiabiliser `RabbitMQ` ;
- definir retries, DLQ, idempotence, correlation et outbox si necessaire ;
- documenter les contrats d'evenements.

Livrables :
- backbone evenementiel maitrise ;
- strategie de fiabilite ;
- catalogue de contrats.

#### 10.2.2 Observabilite et securite runtime

Travaux :
- enrichir logs, traces et metriques ;
- definir SLI/SLO ;
- renforcer secrets, durcissement et controles d'acces runtime.

Livrables :
- observabilite distribuee ;
- tableaux de bord run ;
- controles de securite runtime.

#### 10.2.3 Plateforme de deploiement

Travaux :
- industrialiser la livraison jusqu'a staging et production ;
- preparer `AKS` ;
- introduire l'`IaC` et les strategies de deploiement progressif.

Livrables :
- chaine de deploiement industrialisee ;
- environnements stables ;
- pratiques de rollout / rollback.

#### 10.2.4 Generalisation selective des extractions

Travaux :
- evaluer les domaines restants un par un ;
- extraire uniquement ceux pour lesquels le gain est demontre ;
- eviter de transformer "le reste" en obligation systematique.

Livrables :
- matrice de decision d'extraction ;
- plan d'extension selective ;
- ADR des extractions complementaires.

### 10.3 Criteres de sortie

- la cible distribuee est operable par l'equipe ;
- les incidents sont visibles, tracables et actionnables ;
- la plateforme peut absorber des montes en charge progressives ;
- les domaines restants ont une trajectoire claire : rester dans le `modulith` ou etre extraits plus tard.

## 11. Phase 6 - Finaliser la sortie du legacy

### 11.1 Objectif

Terminer les bascules residuelles, reduire le legacy au minimum utile puis le retirer sans big bang.

Duree indicative :
- `16 a 18 mois`

### 11.2 Sous-phases

#### 11.2.1 Migration de donnees domaine par domaine

Travaux :
- definir les lots de migration ;
- verifier qualite, reprise et reconciliation ;
- basculer progressivement les domaines prioritaires.

Livrables :
- plan de migration detaille ;
- scripts et procedures de reprise ;
- rapport de reconciliation.

#### 11.2.2 Finalisation des bascules residuelles

Travaux :
- introduire strangler pattern, doubles ecritures ou synchronisations temporaires si necessaire ;
- basculer parcours par parcours ;
- surveiller les impacts metier et techniques.

Livrables :
- planning de bascule ;
- suivi de trafic et incidents ;
- decision logs de bascule.

#### 11.2.3 Decommissionnement et stabilisation finale

Travaux :
- retirer progressivement les composants legacy non necessaires ;
- clore les dependances prestataires devenues obsoletes ;
- consolider la documentation finale d'exploitation et d'architecture.

Livrables :
- plan de retrait legacy ;
- documentation cible ;
- bilan de transition.

### 11.3 Criteres de sortie

- les parcours prioritaires tournent sur la cible ;
- la dependance au legacy est reduite de facon mesurable ;
- l'architecture cible est documentee, exploitee et stabilisee.

## 12. Jalons recommandes

Pour rendre ce plan pilotable, les jalons suivants sont recommandes :

- Jalon 1 (`M2`) : existant securise, documente et supervise ;
- Jalon 2 (`M4`) : socle moderne et strategie de coexistence disponibles ;
- Jalon 3 (`M8`) : premier parcours client `catalogue -> commande -> paiement en ligne` operationnel sur le `modulith` ;
- Jalon 4 (`M11`) : capacites franchise et support stabilisees, avec plusieurs domaines deja bascules ;
- Jalon 5 (`M14`) : premiers microservices critiques extraits et mis en service ;
- Jalon 6 (`M16`) : plateforme distribuee industrialisee et extension selective decidee ;
- Jalon 7 (`M18`) : legacy residuel retire ou limite a un perimetre tres faible.

## 13. Ordre logique recommande

L'ordre recommande n'est pas arbitraire :
- `Phase 0` et `Phase 1` reduisent le risque ;
- `Phase 2` donne rapidement de la valeur metier sur les parcours client et lance deja la transition ;
- `Phase 3` clarifie les capacites magasin et support tout en poursuivant la coexistence ;
- `Phase 4` n'arrive qu'une fois les frontieres metier assez nettes et les priorites client identifiees ;
- `Phase 5` prepare l'exploitation reelle et generalise seulement ce qui merite d'etre distribue ;
- `Phase 6` termine la transformation sans rupture brutale.

## 14. Conclusion

Le bon plan de developpement pour GoodFood n'est pas un plan "full microservices" immediat.
Le plan le plus defendable est progressif :
- on securise ;
- on met en place un `modulith` propre ;
- on fait commencer la transition des que ce coeur peut porter de la valeur ;
- on bascule d'abord les parcours client ;
- on extrait ensuite les services critiques un par un ;
- on etend le reste seulement si c'est utile ;
- on termine par la sortie du legacy residuel.

Ce document peut donc servir de reference de pilotage pour presenter une trajectoire realiste, defendable et coherente avec l'`Option 3`.
