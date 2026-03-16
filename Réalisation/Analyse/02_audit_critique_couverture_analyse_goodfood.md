# Audit critique de l'analyse GoodFood : couverture des demandes client, des faiblesses et des forces

## 1. Objet du rapport
Ce document audite l'analyse existante `01_analyse_contexte_goodfood_asis_et_options.md` au regard de la source de vérité principale : `GoodFood/Consignes/contexte goodfood.pdf`.

L'objectif n'est pas de refaire toute l'analyse, mais de répondre à quatre questions précises :
- Est-ce que toutes les demandes explicites du client sont prises en compte ?
- Est-ce que toutes les faiblesses importantes du SI actuel sont bien identifiées ?
- Est-ce que les options d'architecture proposées couvrent réellement ces demandes et ces faiblesses ?
- Est-ce que les forces du SI existant sont identifiées et réutilisées au maximum ?

## 2. Conclusion exécutive
L'analyse existante est globalement solide sur trois points :
- elle identifie correctement la majorité des faiblesses structurelles de l'existant ;
- elle compare des options d'architecture cohérentes ;
- elle justifie correctement qu'une trajectoire progressive est plus réaliste qu'une bascule directe vers un full microservices.

En revanche, elle présente cinq limites importantes :
- elle ne fournit pas de traçabilité explicite `demande client -> faiblesse -> critère -> option -> action de transition` ;
- plusieurs demandes explicites du contexte sont seulement traitées implicitement, pas démontrées ;
- certaines demandes ne sont pas réellement couvertes dans les options, mais seulement évoquées dans le texte ;
- les forces réutilisables du SI existant sont peu ou pas formalisées ;
- certains critères de matrice mélangent `style d'architecture`, `organisation du projet` et `qualité d'exécution`, ce qui affaiblit la démonstration.

Verdict global :
- l'analyse actuelle est `bonne mais incomplète` ;
- elle est suffisante pour défendre une direction architecturale ;
- elle n'est pas encore suffisante pour démontrer de manière rigoureuse que `toutes` les attentes client sont couvertes.

## 3. Principales critiques de méthode

### 3.1 Point fort méthodologique
L'analyse est bien structurée en :
- contexte et périmètre ;
- points faibles ;
- axes d'amélioration ;
- options d'architecture ;
- matrice de choix ;
- recommandation ;
- plan de transition.

Cette structure est saine.

### 3.2 Point faible méthodologique majeur
Il manque une matrice de traçabilité explicite entre :
- les demandes du client ;
- les constats de l'AS-IS ;
- les critères d'évaluation ;
- les options proposées ;
- les décisions finales.

Conséquence :
- on comprend globalement la logique ;
- mais on ne peut pas prouver rapidement et proprement qu'aucune demande du client n'a été oubliée.

### 3.3 Deuxième faiblesse de méthode
La matrice mélange des critères de natures différentes :
- certains relèvent bien du style d'architecture (`scalabilité`, `modularité`, `interopérabilité`) ;
- d'autres relèvent plutôt de la transformation (`maîtrise de la migration`, `durée totale`) ;
- d'autres relèvent surtout de la gouvernance et de l'exécution (`documentabilité`, `support mobile`, `développement durable`).

Ce n'est pas faux, mais cela exige de bien distinguer :
- ce qui dépend du style d'architecture ;
- ce qui dépend du programme de transformation ;
- ce qui dépend de la discipline d'ingénierie et de gouvernance.

Aujourd'hui, cette distinction n'est pas assez nette.

## 4. Audit détaillé des demandes explicites du client

Légende de lecture :
- `Traité` : la demande est bien prise en compte et démontrée.
- `Partiellement traité` : la demande est mentionnée, mais pas suffisamment couverte ou démontrée.
- `Non traité` : la demande n'est pas réellement prise en compte.

### 4.1 Recommandations de l'audit DIW
| Demande client / audit | Dans l'analyse actuelle | Couverture par les options | Diagnostic critique |
|---|---|---|---|
| Refonte intégrale de l'application | Traité | O1 Oui, O2 Oui, O3 Oui | Bien couvert. Les 3 options partent bien d'une refonte réelle et non d'un simple upgrade .NET. |
| Utiliser des technologies open source à la place des solutions Microsoft historiques | Partiellement traité | O1 Oui, O2 Oui, O3 Oui | Le besoin est bien vu, mais il est traité comme un critère général. Il manque la traduction concrète en choix technologiques et l'explication de ce qui reste légitimement conservé côté Microsoft SaaS existant. |
| Proposer une application mobile avec accessibilité | Partiellement traité | O1 Partiel, O2 Partiel, O3 Partiel | Le besoin est mentionné dans les critères, mais il n'est pas vraiment discriminé par le style d'architecture. Aucune option n'explique comment elle permet réellement le mobile, l'accessibilité, le design system, la gestion des notifications et le rôle de DIW. |
| Refondre l'hébergement pour tenir les pics de charge | Traité | O1 Partiel, O2 Oui, O3 Oui | Bien couvert. C'est même un des points forts de l'analyse. |
| Développer un service pour franchises et groupements (commandes, préparations, fournisseurs, livraisons) | Partiellement traité | O1 Partiel, O2 Oui, O3 Oui | Le besoin est présent, mais il reste formulé de manière large. L'analyse ne démontre pas assez le support explicite des sous-domaines `préparation`, `fournisseurs` et `livraisons franchise`. |
| Intégrer éventuellement une aide à la décision | Partiellement traité | O1 Partiel, O2 Oui, O3 Oui | Le besoin est bien cité, mais reste au niveau d'un ajout possible. Il manque une position claire : intégré dès le départ, différé, ou traité comme extension ultérieure. |

### 4.2 Exigences explicites de Good Food pour la refonte
| Demande client | Dans l'analyse actuelle | Couverture par les options | Diagnostic critique |
|---|---|---|---|
| Conserver la totalité des données | Traité | O1 Oui, O2 Oui, O3 Oui | Bien couvert dans le discours et dans les critères. |
| Migration sans impact sur la production | Traité | O1 Partiel, O2 Faible, O3 Oui | Très bien pris en compte. C'est même l'argument le plus solide en faveur de l'option 3. |
| Code documenté | Partiellement traité | O1 Partiel, O2 Partiel, O3 Partiel | Le sujet est bien mentionné, mais surtout via `documentabilité`. Il manque un plan explicite : ADR, conventions, doc API, doc d'exploitation, documentation de migration, ownership. |
| Évolution concomitante avec un nouveau système de caisse | Non traité | O1 Non démontré, O2 Non démontré, O3 Non démontré | Manque important. C'est une contrainte explicite du contexte et elle n'est pas transformée en contrainte d'architecture ou de transition. |
| Nouvelle application accessible depuis d'autres solutions (compta, logistique, etc.) | Traité | O1 Oui, O2 Oui, O3 Oui | Bien couvert via l'interopérabilité et les contrats d'intégration. |
| Conformité au cahier des charges fonctionnel | Non traité | O1 Non démontré, O2 Non démontré, O3 Non démontré | Manque important. L'analyse parle d'architecture, mais elle ne prouve jamais que la solution retenue couvre exhaustivement le périmètre fonctionnel demandé. |
| DIW en charge du design graphique et du développement mobile | Non traité | O1 Non démontré, O2 Non démontré, O3 Non démontré | Ce n'est pas un détail. Cela crée une contrainte de gouvernance, de découpage des responsabilités, de contrats d'interface et de dépendances externes. |
| Compatibilité avec l'engagement de développement durable | Partiellement traité | O1 Partiel, O2 Partiel, O3 Partiel | Le besoin existe dans la matrice, mais reste abstrait. Il manque des leviers concrets : sobriété infra, réduction du surdimensionnement, observabilité pour éviter le gaspillage, éco-conception frontend/mobile, politique de rétention des logs. |

### 4.3 Contraintes de transformation et d'organisation
| Contrainte client / contexte | Dans l'analyse actuelle | Couverture par les options | Diagnostic critique |
|---|---|---|---|
| Aucune compétence de développement interne au départ | Traité | O1 Oui, O2 Partiel, O3 Oui | Bien pris en compte, surtout dans la justification de l'option 3. |
| Ancien prestataire obstructif, informations partielles et incomplètes | Partiellement traité | O1 Partiel, O2 Partiel, O3 Partiel | Le problème est bien senti, mais pas traité comme chantier explicite de `reverse engineering`, d'extraction de connaissance et de sécurisation contractuelle. |
| Prestataire paiement lent à répondre | Partiellement traité | O1 Partiel, O2 Partiel, O3 Partiel | Le risque est cité, mais il manque des réponses concrètes dans les options : sandbox, simulateur, contrats d'interface, pilotage anticipé du lot paiement/TPE. |
| Contradictions entre demandes franchisés et cahier des charges | Traité | O1 Partiel, O2 Partiel, O3 Oui | Le besoin de gouvernance est bien vu. En revanche, l'analyse pourrait mieux expliquer que l'architecture ne résout pas seule ce problème ; il faut aussi un dispositif produit et d'arbitrage. |
| Création d'un vrai pôle informatique interne | Traité | O1 Oui, O2 Partiel, O3 Oui | Bien couvert. C'est un vrai point fort de l'analyse. |

## 5. Couverture des faits SI existants

Cette partie ne concerne pas des demandes futures, mais les éléments du SI actuel qui doivent être pris en compte pour proposer une architecture crédible.

| Élément du contexte SI | Dans l'analyse actuelle | Diagnostic critique |
|---|---|---|
| Microsoft 365 utilisé par le siège et tous les franchisés | Partiellement traité | Pris en compte comme contrainte d'intégration, mais pas valorisé comme force existante à réutiliser pour le support, les échanges, l'onboarding et la conduite du changement. |
| Dynamics 365 déjà déployé sur finance, RH, clients, stocks | Traité | Correctement pris en compte dans l'intégration SI. |
| Sage on-prem utilisé pour la trésorerie | Traité | Correctement pris en compte. |
| Chaînes BNB / EBICS / Sage / trésoreries groupements | Traité | Correctement pris en compte dans l'intégration et les risques. |
| Tous les restaurants équipés a minima d'un TPE | Partiellement traité | Pris en compte côté intégration paiement, mais pas présenté comme actif existant à capitaliser. |
| Outils locaux / tableurs non intégrés par certains franchisés | Traité | Bien pris en compte comme faiblesse de qualité de données. |
| Réclamations reçues par email, téléphone, formulaire et tracées dans l'ERP | Traité | Bien pris en compte. |
| Base propre SQL Server 2008 | Traité | Bien pris en compte. |
| Synchronisation WCF 1 fois/jour à 5h chez WIM | Traité | Très bien pris en compte. |
| Site vitrine institutionnel Apache 2.2 / PHP / MySQL peu maintenu | Non traité | Manque net. C'est un composant public, exposé, vieillissant et peu maintenu. Même s'il n'est pas le coeur métier, il constitue un point faible de sécurité et d'image qui devrait apparaître dans l'analyse du SI existant. |

## 6. Audit des faiblesses : sont-elles toutes identifiées ?

### 6.1 Faiblesses bien identifiées
Ces faiblesses sont correctement capturées dans l'analyse actuelle :
- dépendance aux prestataires historiques ;
- faiblesse du pôle IT interne ;
- documentation insuffisante ;
- legacy monolithique difficile à faire évoluer ;
- stack obsolète Windows Server 2008 R2 / SQL Server 2008 ;
- batch WCF quotidien ;
- absence de mobile ;
- qualité de données hétérogène chez les franchisés ;
- criticité des chaînes BNB / EBICS / Sage ;
- faible maîtrise des droits et de la sécurité transverse ;
- difficulté à absorber les pics de charge ;
- dépendance d'observabilité et d'exploitation vis-à-vis des prestataires.

### 6.2 Faiblesses seulement partiellement identifiées
Ces faiblesses apparaissent indirectement, mais devraient être explicites :
- difficulté de récupération de connaissance due à l'obstruction de l'ancien prestataire ;
- lenteur du prestataire paiement comme risque concret de transformation ;
- hétérogénéité entre restaurants du groupe et groupements sur les flux TPE et de trésorerie ;
- fragmentation des responsabilités entre GoodFood, PWI, WIM, TP System, BNB, DIW.

### 6.3 Faiblesses manquantes
Ces faiblesses ne sont pas suffisamment traitées aujourd'hui :
- dépendance au futur déploiement du nouveau système de caisse ;
- site vitrine public peu maintenu sur une stack Apache 2.2 / PHP / MySQL vieillissante ;
- absence de démonstration de conformité au cahier des charges fonctionnel ;
- dépendance de réalisation vis-à-vis de DIW pour le design graphique et le mobile ;
- absence de stratégie explicite de découverte / reverse engineering du legacy avant migration.

## 7. Audit des forces : sont-elles identifiées et réutilisées ?

## 7.1 Constat général
C'est le point le plus faible de l'analyse actuelle.

Le document identifie très bien les faiblesses, mais il ne formalise presque jamais les forces ou actifs existants à réutiliser. Or une bonne stratégie d'architecture ne se contente pas de réparer les problèmes ; elle réutilise aussi ce qui fonctionne déjà.

## 7.2 Forces existantes sous-exploitées
| Force / actif existant | Est-elle explicitement identifiée ? | Est-elle réutilisée dans les options ? | Diagnostic critique |
|---|---|---|---|
| Microsoft 365 déjà déployé partout | Non | Partiellement | L'analyse en parle comme contrainte SI, mais pas comme levier de transition, d'onboarding et de collaboration. |
| Dynamics 365 déjà central dans la franchise | Partiellement | Oui | Réutilisé comme système d'intégration, mais pas formalisé comme actif à préserver. |
| Sage + EBICS déjà opérationnels | Partiellement | Oui | Réutilisé, mais il faudrait affirmer clairement que l'objectif n'est pas de refaire la trésorerie. |
| Réseau TPE déjà déployé via TP System | Non | Partiellement | Ce point est traité surtout comme dépendance externe, pas comme capacité déjà industrialisée à conserver. |
| Base historique et flux existants utiles à la migration | Partiellement | Oui | Bien exploités pour la migration, mais cela pourrait être plus explicite comme force. |
| Adoption existante des outils Microsoft par le siège et les franchisés | Non | Partiellement | C'est un vrai atout pour la conduite du changement, insuffisamment valorisé. |
| Prestataires déjà en place pour maintenir la continuité pendant la transition | Non | Partiellement | Aujourd'hui ils sont vus surtout comme problème, alors qu'ils peuvent aussi être utilisés comme filet de continuité court terme. |

## 7.3 Ce qu'il faudrait ajouter
Il manque une section dédiée du type `Forces du SI existant et actifs réutilisables`, avec au minimum :
- actifs applicatifs à conserver ;
- actifs de données à réutiliser ;
- actifs organisationnels à exploiter pendant la transition ;
- partenaires à conserver à court terme mais à découpler progressivement.

## 8. Est-ce que les options proposées résolvent bien les faiblesses ?

### 8.1 Option 1 - Monolithe modulaire modernisé
Points bien couverts :
- réduction de la complexité opérationnelle ;
- reprise en main plus simple ;
- modernisation de la stack ;
- exposition par API possible pour l'interopérabilité.

Faiblesses mal ou partiellement résolues :
- scalabilité lors des pics ;
- variabilité franchise à long terme ;
- extension progressive vers analytics, mobile enrichi, forte découpe métier ;
- isolation fine des domaines les plus sensibles.

Jugement :
- solution crédible à court terme ;
- insuffisante si GoodFood vise réellement une forte évolutivité et une architecture durable à l'échelle du réseau.

### 8.2 Option 2 - Microservices full event-driven
Points bien couverts :
- scalabilité ;
- découplage métier ;
- interopérabilité ;
- résilience aux dépendances externes ;
- extension future du périmètre.

Faiblesses mal ou partiellement résolues :
- migration sans rupture ;
- capacité réelle d'exploitation ;
- montée en compétence de l'équipe ;
- coexistence avec le SI hybride existant ;
- pilotage réaliste des dépendances prestataires.

Jugement :
- excellente cible ;
- mauvaise première étape si on la lit comme trajectoire immédiate.

### 8.3 Option 3 - Trajectoire hybride progressive
Points bien couverts :
- migration sans rupture ;
- reprise en main du SI ;
- compatibilité avec un SI hybride ;
- montée en compétence progressive ;
- possibilité de converger vers une cible distribuée.

Faiblesses encore insuffisamment couvertes :
- dépendance au lot `nouveau système de caisse` non intégrée ;
- rôle de DIW non traité ;
- stratégie de documentation non industrialisée ;
- valorisation des forces existantes insuffisante ;
- gouvernance fonctionnelle et preuve de conformité au cahier des charges encore trop implicites.

Jugement :
- c'est bien la meilleure option parmi les trois ;
- mais sa description doit être complétée pour pouvoir prétendre couvrir l'ensemble des attentes du client.

## 9. Ce qui manque pour pouvoir dire que toutes les demandes client sont couvertes
Pour pouvoir soutenir sérieusement que `toutes les demandes client sont traitées`, il manque encore au document d'analyse les ajouts suivants :

1. Une matrice de traçabilité complète `demande client -> exigence -> faiblesse -> décision d'architecture -> mesure de transition`.
2. Une section dédiée au `nouveau système de caisse` : impacts, interfaces, séquencement, risque projet.
3. Une section dédiée à `DIW` : responsabilités, interfaces, dépendances, gouvernance et points de passage.
4. Une section dédiée à la `conformité au cahier des charges fonctionnel` : cartographie simple des grands domaines couverts.
5. Une section `Forces et actifs réutilisables` pour montrer ce qui est conservé et capitalisé.
6. Une faiblesse explicite sur le `site vitrine` exposé et peu maintenu.
7. Une réponse plus concrète au besoin `développement durable`.
8. Une stratégie explicite de `reverse engineering` et de sécurisation documentaire face à l'ancien prestataire.

## 10. Recommandation de réécriture de l'analyse existante
La base actuelle est bonne. La bonne correction n'est pas de tout refaire, mais d'ajouter quatre blocs structurants :

### Bloc A - Traceabilité des attentes client
Ajouter un tableau unique couvrant :
- la demande ;
- sa source ;
- son caractère bloquant ou non ;
- où elle est traitée ;
- comment elle influence le choix d'architecture.

### Bloc B - Forces du SI existant
Ajouter une section positive et réutilisable :
- M365 ;
- Dynamics ;
- Sage/EBICS ;
- TPE déjà déployés ;
- données historiques ;
- habitudes numériques déjà présentes dans le réseau.

### Bloc C - Contraintes de programme aujourd'hui sous-traitées
Ajouter explicitement :
- DIW ;
- nouveau système de caisse ;
- récupération de connaissance legacy ;
- dépendances prestataires lentes.

### Bloc D - Règles de décision
Séparer clairement :
- les exigences éliminatoires ou quasi éliminatoires ;
- les critères de matrice ;
- les choix technologiques ;
- les choix de trajectoire.

Exemple :
- `migration sans impact production` ne devrait pas être seulement un critère pondéré ;
- c'est pratiquement une contrainte de passage obligatoire.

## 11. Verdict final
### 11.1 Ce qui est réussi
- Les faiblesses majeures du legacy sont bien identifiées.
- L'option 3 est correctement choisie comme trajectoire la plus réaliste.
- La logique migration / maîtrise du risque / montée en compétence est pertinente.
- L'ajout du TDD ciblé est cohérent avec le contexte GoodFood.

### 11.2 Ce qui est insuffisant
- La couverture des demandes client n'est pas démontrée de bout en bout.
- Certaines demandes explicites sont oubliées ou seulement implicites.
- Les forces existantes ne sont pas suffisamment valorisées.
- Les options ne traitent pas explicitement certains sujets de programme pourtant imposés par le contexte.

### 11.3 Position finale
Si la question est :
`L'analyse actuelle va-t-elle dans la bonne direction ?`
la réponse est `oui`.

Si la question est :
`Peut-on affirmer rigoureusement qu'elle couvre toutes les demandes client, toutes les faiblesses et qu'elle réutilise au maximum les forces existantes ?`
la réponse est `non, pas encore`.

Le document a besoin d'une passe de consolidation ciblée, pas d'une refonte complète.
