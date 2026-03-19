# Option 3 - Questions et reponses de travail

Date de mise a jour : 2026-03-18

Ce document consigne les questions posees pendant l'ajustement du modele `GoodFood - C4-Option3` et les reponses retenues.
Il est maintenu a jour pour toute la session de travail en cours.

## 1. Fleches autour du broker

Question :
`je veux que des fleche service vers message broker pas l'inverse`

Reponse :
Le modele a ete modifie pour supprimer les relations `messageBroker -> service`.
La convention retenue est desormais :
- publication : `service -> messageBroker`
- consommation : `service -> messageBroker` avec un libelle explicite du type `Consumes ...`

Impact :
- coherence visuelle des schemas C2, C3 et C4 ;
- meme convention pour les flux synchrones et asynchrones.

## 2. Nommage des composants HTTP

Question :
`tu parles de api layer mais parles plutot de controller et en meme temps pas mal de nom depasse un pue de leur cadre corrige ça`

Reponse :
Les composants `API Layer` ont ete renommes en `Controller`.
Les libelles des services, applications, bases, integrations et titres de vues ont ete raccourcis pour mieux tenir dans les schemas.
La taille de police du style a aussi ete reduite pour ameliorer la lisibilite.

Impact :
- vocabulaire plus proche des patterns d'implementation ;
- diagrammes moins charges visuellement.

## 3. Langue des schemas

Question :
`Par contre laisse le texte en anglais`

Reponse :
Les libelles visibles dans les sources du workspace ont ete remis en anglais :
- noms affiches ;
- descriptions ;
- titres de vues ;
- libelles de flux ;
- documentation `docs/overview.md` ;
- ADR `0001-architecture-microservices.md`.

Note :
`workspace.json` est un artefact genere et peut rester temporairement avec d'anciens libelles tant qu'il n'a pas ete regenere.

## 4. Nommage des adaptateurs

Question :
`Parle d'adapter tout cours pas de psp adapter ou autres garde des nom generaliste qui corresponde a des pattern`

Reponse :
Les composants d'integration ont ete ramènes vers des noms de pattern plus generiques.
Le choix retenu est :
- `Controller`
- `Consumer`
- `Domain`
- `Repository`
- `Adapter`

Les descriptions courtes servent a distinguer la responsabilite du composant sans reintroduire un nom trop specifique.

## 5. Signification de `Consumer` dans le paiement

Question :
`Consumer on niveau du payment c'est quoi ?`

Reponse :
Dans `Payment Service`, le composant `Consumer` represente l'entree asynchrone du service.
Son role est de :
- recuperer les messages recus via le broker ;
- transmettre ces commandes ou evenements au `Domain` ;
- declencher ensuite la logique de traitement.

Equivalent de pattern :
- `message handler`
- ou `command handler` selon le niveau de precision souhaite.

## 6. Position de synthese

Les conventions actuellement retenues pour le workspace `GoodFood - C4-Option3` sont :
- texte visible en anglais ;
- composants nommes par pattern ;
- fleches vers le broker uniquement dans le sens `service -> broker` ;
- vues C3 dynamiques scopees par conteneur ;
- un seul composant `Adapter` par conteneur quand plusieurs integrations externes existent.

## 7. Regle de suivi pour la session

Question :
`tiens le a jour pour cette session`

Reponse :
Ce fichier devient le journal de decisions et de reponses de la session en cours.
Les prochaines questions et les arbitrages associes y seront ajoutes au fil de l'eau.

## 8. Signification de `TP POS`

Question :
`c'est quoi l'api externe TP pOS ?`

Reponse :
La lecture initiale etait trop ambiguë.
Le contexte dit deux choses differentes :
- `TP System` est un prestataire/externe deja en place pour le deploiement et la gestion des terminaux de paiement ;
- un `new POS` doit etre absorbe en parallele du projet, mais ce n'est pas documente comme une API externe precise a reutiliser telle quelle.

Decision corrigee :
- dans le modele, l'externe runtime doit representer `TP System / reseau TPE` ;
- le `new POS` reste une contrainte de transformation et d'integration, pas un systeme externe deja specifie au meme niveau de precision.

Impact :
- le modele runtime n'affirme plus a tort qu'une API `new POS` precise existe deja ;
- la reutilisation de l'existant terrain reste visible ;
- la dependance `new POS` reste tracee dans les documents d'analyse et de decision.

## 9. Clarification sur l'existant a reutiliser

Question :
`quel new pos dans le contexte il n'utilise pas un service externe qu'on devait reutilise ?`

Reponse :
Oui : l'existant a reutiliser, d'apres le contexte, est d'abord `TP System` et le reseau `TPE` deja deployee.
References de contexte :
- `TP System : deploiement et gestion des terminaux de paiement`
- `Reseau TPE deja deploye via TP System`
- `faire evoluer la solution en parallele du deploiement d'un nouveau systeme de caisse`

Conclusion :
- `TP System / TPE` = existant externe a capitaliser ;
- `new POS` = contrainte programme / integration future a absorber ;
- les deux ne doivent pas etre confondus dans le modele.

## 10. Role de `Dynamics 365`

Question :
`Dynamics 365 sert a quoi deja ?`

Reponse :
Dans le contexte GoodFood, `Dynamics 365` correspond au socle ERP deja deployee.
Il couvre la gestion transverse existante, notamment :
- finance ;
- RH ;
- clients ;
- stocks.

Role architectural retenu :
- on le conserve comme systeme coeur de gestion transverse ;
- on ne reconstruit pas ces capacites dans la nouvelle plateforme ;
- on l'integre via l'`Integration Hub` et une couche d'isolation pour eviter un couplage direct du coeur metier.

En pratique, la plateforme cible echange avec `Dynamics 365` pour reutiliser le referentiel et les fonctions ERP deja en place, plutot que de les reimplementer.

## 11. Utilite concrete de `Dynamics 365`

Question :
`Je comprends bien mais mes connaissances sur son utilite et son usage me sont inconnus`

Reponse :
`Dynamics 365` n'est pas une fonction metier unique.
C'est une suite d'applications de gestion d'entreprise de Microsoft, generalement utilisee pour deux grandes familles de besoins :
- `CRM` : gestion des clients, des interactions, du suivi commercial et du support ;
- `ERP` : gestion interne de l'entreprise, par exemple la finance, les stocks, certains processus de gestion et une partie du referentiel.

Dit simplement :
- le front ou les applications operationnelles servent a faire tourner le parcours utilisateur ;
- `Dynamics 365` sert souvent a porter la gestion de reference et la gestion administrative deja en place.

Usage typique :
- stocker et maintenir des fiches clients ;
- suivre des donnees finance ou facturation ;
- gerer des stocks ou des donnees de reference ;
- centraliser des informations utilisees par plusieurs equipes.

Dans GoodFood, il faut surtout le lire comme un systeme back-office transverse que la nouvelle plateforme doit alimenter ou consulter selon les cas, sans reconstruire ses fonctions natives.

## 12. Signification du composant `Outbox`

Question :
`Pour le checkout et payment c'est quoi le composant outbox`

Reponse :
Dans le modele actuel, `Outbox` apparait sur le flux de `checkout` cote `Order Service`, pas dans le `Payment Service`.

Role :
- il prepare et publie les evenements metier apres l'ecriture de la commande ;
- il sert a fiabiliser la publication vers le broker ;
- il evite de creer la commande en base sans emettre l'evenement associe, ou l'inverse.

Lecture simple du flux :
- `Controller` recoit la demande ;
- `Domain` valide et cree la commande ;
- `Repository` persiste la commande ;
- `Outbox` prend l'evenement metier a publier ;
- puis l'evenement est publie vers le broker, par exemple `OrderPlaced`.

En pratique, `Outbox` represente le pattern de publication fiable d'evenements entre la base metier et le broker.
Ce n'est pas une fonction metier visible par l'utilisateur, c'est un composant technique de robustesse.

Point important :
- dans ce workspace, `Payment Service` n'a pas de composant `Outbox` dedie ;
- l'`Outbox` visible dans le schema concerne surtout le demarrage du flux `checkout` / `order`.

## 13. Principe et utilite de l'`Outbox`

Question :
`Explique plus le principe je suis pas sur de comprendre l'utilite`

Reponse :
Le probleme de base est simple :
quand `Order Service` traite un checkout, il doit faire deux choses differentes :
- enregistrer la commande dans sa base ;
- publier un evenement `OrderPlaced` dans le broker pour lancer la suite du flux.

Sans `Outbox`, ces deux actions sont separees.
Donc si la commande est en base mais que le service tombe juste avant l'envoi au broker :
- la commande existe ;
- mais personne ne sait qu'elle existe ;
- le paiement, la coordination et la suite du processus ne demarrent pas.

L'`Outbox` sert a eviter cette perte.
Le principe est :
- dans la meme transaction que l'ecriture de la commande, le service enregistre aussi un message a publier ;
- ce message est stocke localement dans une table ou zone `outbox` ;
- ensuite un composant technique lit cette `outbox` et publie les messages vers le broker ;
- si le broker est indisponible, il reessaie plus tard au lieu de perdre l'evenement.

L'utilite concrete est donc :
- ne pas perdre l'intention de publication ;
- fiabiliser le demarrage des flux asynchrones ;
- decoupler l'ecriture metier locale de l'envoi reseau vers le broker.

Exemple GoodFood :
- le client valide son panier ;
- `Order Service` cree la commande ;
- en meme temps il ecrit dans l'`Outbox` qu'un `OrderPlaced` doit partir ;
- meme si le broker est KO a cet instant, l'evenement n'est pas oublie ;
- des que possible, il est republie et la saga peut lancer le paiement.

Limite importante :
- l'`Outbox` ne signifie pas "magie" ou "exactement une seule fois" ;
- elle sert surtout a ne pas perdre les evenements ;
- les consommateurs doivent souvent etre capables de tolerer un doublon si un message est republie.

## 14. Coherence avec les autres schemas sur l'emission d'evenements

Question :
`Dans d'autres schema c'est le domain qui s'occupe de ça pour la coherence restons comme ça`

Reponse :
Decision retenue pour cette session :
- on ne garde plus `Outbox` comme composant visible dans le schema `Option 3` ;
- pour rester coherent avec les autres schemas, c'est le `Domain` qui porte directement l'emission d'evenements dans les vues C3/C4.

Impact :
- `Order Service` n'affiche plus de composant `Outbox` dedie ;
- le flux visible devient `Domain -> Message Broker` ;
- si un mecanisme de fiabilisation existe en implementation, il reste implicite et n'est plus expose comme composant de diagramme.

## 15. Faut-il une base dediee pour une saga ?

Question :
`la saga c'est pour le pattern y'a vraiment besoin d'une db etc normalement c'est la gestion des flux critique inter service pas besoin de sa propre db si ?`

Reponse :
Le pattern `Saga` ne demande pas obligatoirement une base dediee par definition.
En revanche, si on choisit une saga orchestree, longue et asynchrone, il faut generalement un stockage durable quelque part pour :
- garder l'etat courant ;
- faire la correlation entre messages ;
- reprendre apres redemarrage ;
- gerer timeouts, retries et compensations.

Donc la bonne nuance est :
- pas besoin forcement d'une `DB` separee dessinee comme un systeme a part ;
- mais besoin, en pratique, d'un `state store` durable si l'orchestrateur porte vraiment la coordination.

Cas ou on peut simplifier :
- si on fait plutot de la choregraphie par evenements ;
- ou si on utilise un moteur/workflow qui persiste deja l'etat pour nous ;
- ou si le flux est tres simple et ne justifie pas un orchestrateur explicite.

Conclusion pour le schema :
- `Saga DB` n'est pas une obligation dogmatique du pattern ;
- elle traduit seulement le choix actuel d'un orchestrateur persistant ;
- si on veut un schema plus leger, on peut remplacer cette base par un stockage technique plus generique, ou supprimer l'orchestrateur si on bascule vers une choregraphie.

## 16. Une base `NoSQL` serait-elle plus pertinente pour la saga ?

Question :
`Mais dans ce cas une base NoSql n'est pas plus pertienente ?`

Reponse :
Oui, une base `NoSQL` peut etre pertinente pour une saga, parce que l'etat d'une saga ressemble souvent a un document ou a un enregistrement cle-valeur :
- une correlation ;
- un statut courant ;
- quelques donnees de contexte ;
- des dates, timeouts et marqueurs techniques.

Mais elle n'est pas automatiquement plus pertinente.
Dans `Option 3`, `PostgreSQL` reste defendable pour trois raisons :
- le projet a deja standardise le coeur, le paiement et l'integration sur `PostgreSQL` ;
- la saga porte des flux critiques, donc la robustesse, l'auditabilite et l'outillage relationnel restent utiles ;
- l'orchestrateur est modele comme une `MassTransit Saga`, donc un stockage relationnel reste tres coherent operationalement.

En pratique :
- `NoSQL` devient plus interessant si l'etat est tres flexible, volumineux ou massivement distribue ;
- `PostgreSQL` reste pertinent si on cherche surtout coherence, simplicite d'exploitation et homogeneite de la plateforme.

Conclusion :
- `NoSQL` est une option valable ;
- mais dans ce dossier, elle n'est pas clairement meilleure que `PostgreSQL` pour la saga ;
- si on veut surtout alleger la lecture du schema, renommer `Saga DB` en `State Store` est probablement plus utile qu'un changement de techno affichee.

## 17. Faut-il distinguer paiement en ligne et paiement sur place ?

Question :
`Pour le payment service il faut pas distinguer payment sur place resto et en ligne ?`

Reponse :
Oui, il faut les distinguer dans la lecture fonctionnelle du schema, parce que ce ne sont pas exactement les memes flux.

Difference utile :
- `paiement en ligne` : declenche par le checkout digital, critique pour la vente en ligne, avec appel direct au `PSP / BNB` ;
- `paiement sur place` : lie au terrain, au `TP System / reseau TPE` et au contexte caisse / restaurant.

Recommendation pour `Option 3` :
- ne pas forcement creer deux microservices de paiement ;
- mais distinguer clairement deux canaux ou deux parcours ;
- garder `Payment Service` centre sur le paiement en ligne et les traitements associes ;
- garder le paiement sur place plutot du cote integration terrain / `TP System` tant que GoodFood ne pilote pas nativement ce flux.

En pratique, le modele actuel va deja un peu dans ce sens :
- `Payment Service` parle a `BNB / PSP` ;
- `TP System / TPE` est traite a part via l'integration.

Le vrai ajustement utile est donc surtout de rendre cette distinction explicite dans les vues, pas de multiplier les services sans necessite.

## 18. Paiement sur place et liaison avec `TP System`

Question :
`pas deux service mais dans le cas d'un paiement sur place on ne passera pas par notre paiement service, si oui dans ce cas faudrais une liaison avec le TP System nan ?`

Reponse :
Oui, si le paiement sur place est realise par le reseau `TPE / TP System`, il ne doit pas etre represente comme un appel du `Payment Service` vers le `PSP` en ligne.

La bonne lecture est :
- `Payment Service` pour le paiement en ligne ;
- `TP System / reseau TPE` pour le paiement sur place ;
- une liaison d'integration doit exister avec `TP System` pour remonter ou synchroniser l'etat utile au SI.

Dans `Option 3`, cette liaison existe deja au niveau conteneur via l'`Integration Hub`.
Ce qui manque surtout, si on veut rendre le schema plus juste, c'est un flux explicite de paiement sur place montrant par exemple :
- ordre ou contexte magasin ;
- interaction avec `TP System / TPE` ;
- retour d'etat vers la plateforme ;
- mise a jour de la commande ou du statut de paiement.

Conclusion :
- oui, il faut bien une liaison avec `TP System` ;
- non, cela n'implique pas forcement de faire porter ce flux par `Payment Service`.

Application au schema :
- le flux `checkout` a ete separe en `online payment` et `in-store payment` ;
- le paiement sur place est maintenant represente via `Integration Hub -> TP System` ;
- `Payment Service` reste reserve au paiement en ligne vers `BNB / PSP`.

## 19. Doublons et point de depart des vues dynamiques

Question :
`J'ai l'impression d'avoir des schema assez dupplique notamment pour payment service ou dans l'un j'ai juste l'api gateway en plus, de plus pq certains ont un flux complet partant de l'utilisateur et d'autre nn ? alors que c'est censé representer le flux dans les deux cas`

Reponse :
Oui, il y avait un melange de deux intentions dans les vues :
- des parcours metier de bout en bout ;
- des zooms techniques sur un sous-flux interne.

C'est ce qui donnait l'impression de doublon, surtout sur le paiement :
- un schema rejouait le checkout complet ;
- l'autre rejouait presque la meme chose avec seulement le detail du `Payment Service`.

Regle retenue desormais :
- une vue dynamique commence par son vrai declencheur ;
- si le flux est initie par un humain, elle commence par l'acteur ;
- si le flux est un sous-flux asynchrone, elle commence par le service ou l'evenement qui le declenche ;
- on evite qu'une vue "zoom" rejoue tout le parcours precedent.

Application :
- `Checkout to Online Payment Request` s'arrete a la publication de `InitiatePayment` ;
- `Online Payment Execution` commence a partir de cette commande publiee par la saga ;
- le doublon avec `Payment Service` est donc reduit et la lecture devient plus coherente.

## 20. Faut-il garder des zooms sur les services ?

Question :
`Je suis pas sur de vouloir garder les zoom sur les service, defends moi le point et explique moi a quoi ça pourrait servir`

Reponse :
Les zooms sur les services ne servent pas a raconter une seconde fois tout le parcours metier.
Ils servent a montrer ce qu'un schema bout en bout masque souvent :
- quel composant interne recoit quoi ;
- ou se situe la logique metier ;
- ou se fait la persistance ;
- ou se fait l'appel externe ;
- ou passent les messages async.

Utilite concrete :
- expliquer un flux critique sans surcharger un seul grand schema ;
- montrer la responsabilite reelle d'un service ;
- rendre visibles les points de panne, retries, persistance et dependances externes ;
- aider au debug, aux tests et au decoupage d'implementation.

Limite :
- si on les melange avec les parcours bout en bout au meme niveau, ils donnent une impression de doublon et brouillent la lecture.

Bonne pratique retenue :
- les garder seulement si leur objectif est clair ;
- ne pas les melanger avec les vues metier principales ;
- eventuellement les releguer en annexe ou en vues techniques complementaires si l'audience principale est moins technique.

## 21. Role concret du `Franchise Service`

Question :
`A quoi sert le franchise service concretemetn ?`

Reponse :
Concretement, le schema cible ne garde plus un unique `Franchise Service`.
Le besoin franchise a ete redecoupe en plusieurs services metier plus explicites :
- `Local Assortment Service` pour les variations locales de menu, stock, prix et promotions ;
- `Supplier Service` pour les fournisseurs et les contraintes d'approvisionnement ;
- `Preparation Service` pour les operations de preparation cote restaurant.

Le role principal est donc d'isoler la variabilite franchise / magasin du reste du coeur sans melanger plusieurs capacites dans un meme microservice.
Autrement dit :
- le `Catalog Service` expose le catalogue consommable par le client ;
- le `Local Assortment Service` porte les ajustements locaux qui viennent l'alimenter ou le modifier ;
- `Supplier Service` et `Preparation Service` couvrent les autres usages franchise demandes par le contexte.

Point important :
- dans le besoin metier global, le sujet franchise reste plus large et peut aussi toucher commandes et livraisons ;
- mais le schema n'utilise plus un faux service unique pour porter tout ce perimetre.

## 22. Utilite metier concrete du `Franchise Service`

Question :
`Attends quel est l'utilite ? Preparer des modifications futurs qui arriveront dans le catalog apres par exemple ?`

Reponse :
Oui, c'est exactement une grande partie de l'utilite du `Local Assortment Service` dans le schema cible.

Il sert de point d'entree pour les changements locaux avant qu'ils ne se repercutent ailleurs.
Exemples :
- un restaurant change une disponibilite ;
- ajuste un stock ;
- active une promotion locale ;
- adapte un menu ou une regle locale.

Le service :
- recoit la modification ;
- verifie qu'elle respecte les regles locales ;
- la stocke ;
- publie ensuite un evenement pour que le `Catalog Service`, puis le `Order Service` via sa copie locale, et d'autres consommateurs se mettent a jour.

Donc oui :
- il prepare et fiabilise des changements futurs ;
- puis ces changements alimentent le catalogue expose au client.

Sa valeur est surtout de ne pas faire porter ces variations locales directement au service catalogue public.

## 23. Passage exact dans les consignes sur le besoin franchise

Question :
`C'est ce qui etait demande dans le cntexte ? retrouve moi le passage dans le dossier consignes`

Reponse :
Oui, le besoin franchise est bien explicite dans le document de contexte fourni dans les consignes.

Passages retrouves dans `Consignes/contexte goodfood.pdf` :
- `Developper un service pour les franchises et les groupements de franchises pour qu'ils puissent gerer leurs commandes, leurs preparations, leurs fournisseurs et leurs livraisons`
- `Le service franchise pour creer des promotions, gerer les fournisseurs, etc.`

Nuance importante egalement presente dans ce meme document :
- `Dans cette liste, un service n'est pas synonyme de service technique ou de composant.`

Conclusion :
- oui, le besoin metier franchise est bien demande dans le contexte ;
- non, le contexte n'impose pas qu'il corresponde exactement a un unique microservice technique nomme `Franchise Service`.

## 24. Impact franchise sur les flux catalogue et piste de decoupage

Question :
`Mais ça change les flux car quand le catalogue est consulte il faut pouvoir verifier les promotions etc d'ailleurs je pense qu'il serait plus interessant de decouper le service franchise en services dedie franchise mais pour chaque fonctionnalite`

Reponse :
Oui, la remarque est juste :
si les promotions, stocks et variantes locales influencent le catalogue visible, alors le domaine franchise impacte directement le flux de consultation du catalogue.

Mais le bon reflexe n'est pas forcement d'ajouter des appels synchrones du `Catalog Service` vers plusieurs services franchise a chaque lecture.
Pour le parcours de consultation, le plus robuste reste en general :
- `Catalog Service` sert une vue deja composee ;
- les changements de promotions, stock, disponibilite ou menu arrivent en amont par evenements ;
- le catalogue publie au client est donc deja enrichi avec ces regles locales.

Sur le decoupage :
- oui, un unique `Franchise Service` etait trop large ;
- mais il faut decouper par capacite metier coherente, pas par simple ecran ou fonctionnalite trop fine.

Decoupage retenu :
- `Local Assortment Service` pour menus, disponibilites, prix locaux, promotions locales ;
- `Supplier Service` pour fournisseurs ;
- `Preparation Service` pour les operations de preparation ;
- la livraison doit plutot rester dans `Delivery Service` sauf besoin franchise tres specifique.

Conclusion :
- la consultation catalogue doit probablement consommer les effets du domaine franchise ;
- mais idealement via une projection ou read model, pas via une cascade d'appels synchrones ;
- et oui, un decoupage du bloc franchise parait plus juste que de garder un unique service fourre-tout.

## 25. Isolation des capacites franchise par rapport a la charge client

Question :
`Ok par contre est ce que dans tous le cas on ne ferait pas un service a part pour les franchise car le delivery service pourra etre tres charge par les clients donc autant avoir un service pour les franchise ... faut le rajouter quelque part pour dire que c'etait dans les consignes, du details qu'on a ajoute et qui contredit pas le sujet et autorise`

Reponse :
Oui, c'est une interpretation d'architecture defendable et elle ne contredit pas le sujet.

Pourquoi :
- le contexte demande bien un besoin franchise explicite ;
- mais il precise aussi que le mot `service` dans les consignes n'impose pas un service technique unique ;
- on peut donc raffiner ce besoin en plusieurs capacites techniques si cela reste coherent avec le metier.

Argument d'architecture :
- si `Delivery Service` porte deja la charge client temps reel, il peut etre pertinent de ne pas lui ajouter en plus des usages franchise ou back-office ;
- isoler certaines capacites franchise permet de mieux separer les profils de charge, les priorites operatoires et l'evolutivite ;
- ce choix est encore plus defendable si les flux franchise n'ont pas les memes contraintes de latence ou de pic que le suivi client.

Trace documentaire :
- cet arbitrage a ete note dans `02_decisions_de_coherence_et_ecarts.md` comme raffinement autorise par les consignes ;
- il est presente comme un detail d'architecture ajoute par interpretation, pas comme une exigence litterale imposant un microservice unique.

## 26. Decision de simplification sur la livraison franchise

Question :
`pour eviter de la complexite partons sur le fait que livraison franchise et livraison client ne seront jalais effectue sur les meme tranches horaire et gardons donc le meme service`

Reponse :
Decision retenue :
- on garde un seul `Delivery Service` ;
- on ne cree pas de service de livraison franchise dedie a ce stade.

Hypothese explicite :
- les flux de livraison franchise et de livraison client ne sont pas executes sur les memes tranches horaires ;
- cette separation horaire est consideree comme suffisante pour ne pas justifier un service distinct maintenant.

Cadre documentaire :
- cette hypothese est un detail d'architecture ajoute par interpretation ;
- elle ne contredit pas les consignes, qui expriment un besoin franchise fonctionnel sans imposer un microservice technique unique ;
- elle a ete reportee dans `02_decisions_de_coherence_et_ecarts.md` pour rester visible hors du journal de session.

## 27. Gestion des promotions, menus et variantes locales

Question :
`ok maintenant comment on gere le cote promotion menu local etc`

Reponse :
Le plus coherent est de separer :
- l'ecriture des regles locales ;
- la lecture du catalogue expose au client.

Mecanique cible :
- une capacite magasin / franchise porte les changements locaux : menu, disponibilite, stock, prix, promotion, horaires ou regles locales ;
- elle publie des evenements de changement ;
- `Catalog Service` consomme ces evenements et reconstruit une vue catalogue precomposee par magasin ;
- le front lit ensuite cette vue deja enrichie, sans aller appeler plusieurs services en cascade pendant la consultation.

Principe de donnees :
- un catalogue de base existe ;
- des overrides locaux s'y appliquent selon le magasin, la plage horaire et les regles de promotion ;
- la vue finale exposee au client est donc deja resolue.

Regles utiles :
- priorite claire entre regles globales et locales ;
- promotions bornees dans le temps ;
- stock et disponibilite geres comme des contraintes locales ;
- revalidation au checkout pour confirmer prix, promo et disponibilite avant creation de commande.

Conclusion :
- la consultation catalogue doit lire une projection ou read model compose ;
- les promotions et variantes locales ne doivent pas etre calculees par aggregation synchrone a chaque requete ;
- le `Order Service` reste responsable de la verification finale au moment du checkout.

## 28. Faut-il dupliquer les produits pour gerer les promotions ?

Question :
`Détaille plus comment ça devrait se passer, mais à ce niveaux pq pas juste duppliquer les produit qui ont des promo avec limite une date de validation avec une notif pour franchise arrive a la fin de cette date pour modifier le prix du produit ou revenir sur celui de base etc`

Reponse :
L'idee de dupliquer le produit avec une date de validite peut sembler simple, mais elle cree vite des effets de bord :
- duplication des identifiants produit ;
- ambiguite sur le "vrai" produit pour le panier, les stats et les integrations ;
- risque de multiplier les copies pour chaque magasin, promotion ou variation de prix ;
- retour au prix de base plus fragile si plusieurs regles locales se chevauchent.

Le modele plus robuste consiste en general a garder :
- un produit de base ;
- des overrides locaux ou regles temporelles qui modifient son comportement commercial.

Forme simple et defendable pour GoodFood :
- `Base Product` : identite produit, libelle, composition, prix de reference ;
- `Store Override` : disponibilite locale, prix local, masquage, horaires ou contraintes magasin ;
- `Promotion Rule` : reduction, prix promo, type d'offre, date de debut et de fin, perimetre d'application.

La vue catalogue exposee au client est ensuite calculee comme :
- produit de base ;
- puis surcharge locale ;
- puis promotion active si la date, le magasin et les conditions correspondent.

Pour rester pragmatique :
- oui, on peut garder une date de validite ;
- oui, on peut notifier le franchise avant expiration ;
- oui, le prix peut revenir automatiquement au prix local ou au prix de base quand la promo se termine ;
- mais il vaut mieux faire cela avec une regle ou un override, pas en clonant le produit.

Exception acceptable :
- si la promotion cree en realite une offre differente, par exemple un menu special, un bundle ou une edition limitee, alors on peut assumer un produit distinct.

## 29. Application au schema du modele `base product + local override + promotion rule`

Question :
`ok on part sur ta version fais les updates des schemas en consequences`

Reponse :
Le schema a ete aligne sur le principe suivant :
- un produit de base n'est pas duplique pour une simple promotion ;
- les variations locales et les promotions sont gerees comme des regles ou overrides ;
- `Catalog Service` publie une vue catalogue resolue par magasin ;
- `Order Service` valide le checkout a partir d'une copie locale de cette vue commerciale.

Application visible :
- `Catalog Service` est decrit comme `Resolved store catalog` ;
- `Local Assortment Service` porte explicitement les `local overrides and promotions` ;
- les flux `C3` de consultation lisent une vue catalogue resolue ;
- les flux `C3` de checkout ne montrent plus d'appel synchrone `Order -> Catalog` ;
- le flux assortiment local publie des evenements de type `LocalAssortmentChanged` puis `ResolvedCatalogChanged`.

## 30. Pourquoi le `Controller` de l'`Integration Hub` pointe vers les `Consumers` ?

Question :
`Pour le flux integration hub pourquoi le controller a une relation avec le consumers ???`

Reponse :
Dans l'etat actuel du schema, cette relation sert a representer l'idee suivante :
- le `Controller` expose des endpoints d'exploitation ;
- ces endpoints peuvent declencher des traitements proches de ceux executes apres reception d'evenements.

Mais sur le plan de la responsabilite, ce n'est pas tres propre.
Un `Consumer` est normalement une entree asynchrone, pas un composant applicatif appele par un `Controller`.

Lecture plus juste :
- le `Controller` et les `Consumers` devraient plutot converger vers un meme composant metier ou orchestrateur interne ;
- ou bien le composant actuel devrait etre renomme s'il porte en realite des handlers partageables.

Conclusion :
- la relation actuelle est un raccourci de modelisation ;
- elle n'est pas ideale semantiquement ;
- si on veut un schema plus rigoureux, il faudrait remplacer ce lien par `Controller -> Domain/Coordinator`, et faire aussi pointer les `Consumers` vers ce meme composant.

## 31. Suppression du lien `Integration Controller -> Consumers`

Question :
`supprime la relation ca fait une incoherence par rapport au reste des flux`

Reponse :
Decision appliquee :
- la relation `integrationApi -> eventConsumers` a ete supprimee du schema ;
- l'`Integration Hub` garde ses `Consumers` comme entree asynchrone autonome ;
- le `Controller` reste visible comme endpoint d'exploitation, sans etre relie artificiellement aux `Consumers`.

Motif :
- eviter une incoherence avec le reste des flux ;
- ne pas representer un `Consumer` comme une cible applicative classique d'un `Controller`.
