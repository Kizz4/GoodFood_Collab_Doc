# Décisions de cohérence et écarts corrigés

## 1. Objet
Ce document liste les écarts détectés entre :
- le contexte GoodFood,
- les documents techniques existants,
- le C4 cible initial.

L'objectif est de rendre la proposition finale cohérente sans jeter le travail déjà produit.

## 2. Écarts détectés et décisions prises

| Sujet | État initial | Problème | Décision retenue |
|---|---|---|---|
| Architecture cible | microservices complets | la trajectoire d'option 3 risquait d'être perdue si le schéma ne montrait que l'état final | représenter la cible finale en microservices, avec un code couleur qui raconte `modulith initial -> modulith complet -> extractions -> cible finale` |
| Application web | `Blazor WASM` dans le C4 | contradiction avec `Plan_GoodFood_3.0.pdf` qui retient `React` | `React` devient la référence |
| Mobile | app livreur uniquement dans le plan et le C4 | ne couvre pas l'exigence explicite d'une app client | ajouter une `App Mobile Client` |
| Paiement | `Stripe` dans le C4 et le plan | contradictoire avec le contexte historique centré sur `BNB` | utiliser un `Payment Provider Adapter` vers `BNB / PSP` |
| Technologie livraison | service homogénéisé en `ASP.NET Core` dans la première version | choix moins pertinent si le domaine livraison doit gérer suivi temps réel, missions et preuves de livraison | `Node.js` avec `TypeScript` retenu pour le service livraison, avec contrats d'API et d'événements stricts |
| Données livraison | justification orientée NoSQL sans décision formelle | incohérence entre besoin de tracking flexible et absence de techno explicitement retenue | `MongoDB` retenu pour la livraison, `PostgreSQL` conservé pour le coeur, le paiement et les sagas |
| C4 | dossier `C4/` vide dans le workspace cible initial | incohérence documentaire | on garde les vues utiles C1/C2/C3 comme source principale |
| Option 3 | non matérialisée dans le C4 cible initial | écart entre analyse et schéma | création d'une variante `GoodFood - C4-Option3` |
| Intégration legacy | trop implicite dans le C4 initial | sous-estime Dynamics, Sage, M365, POS et migration | ajout explicite d'un `Integration Hub / ACL` |
| Nouveau système de caisse | absent du C4 initial | contrainte explicite du sujet non couverte | ajout dans les systèmes externes et dans la couche d'intégration |
| DIW | absent du modèle runtime | sujet de gouvernance, pas de runtime direct | documenté dans le dossier techno, pas modélisé comme runtime system |
| Domaine franchise | un unique `Franchise Service` très large dans le schéma | le contexte parle d'un besoin franchise large, mais comme besoin fonctionnel et non comme un microservice unique imposé ; le service restait trop flou et mélangeait assortiment local, fournisseurs et preparation | le domaine est maintenant decoupe en `Local Assortment Service`, `Supplier Service` et `Preparation Service` ; la livraison reste dans `Delivery Service` |

## 3. Règle appliquée
La règle suivie est simple :
- conserver les choix techniques déjà posés quand ils sont compatibles avec le contexte ;
- corriger les choix qui contredisent le contexte ou la trajectoire option 3 ;
- éviter d'introduire de nouvelles technologies si elles n'apportent pas une valeur claire à ce stade.

## 4. Résultat
Le résultat n'est pas un abandon du travail précédent. C'est une mise en cohérence :
- le travail microservices reste la cible technique finale,
- la trajectoire présentable et défendable pour GoodFood reste `hybride progressive`,
- les schémas `C4` et `draw.io` montrent désormais l'état final, tandis que le code couleur raconte la progression `modulith -> transition -> microservices`.
