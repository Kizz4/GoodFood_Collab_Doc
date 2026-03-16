# Schéma physique cible Option 3

## Positionnement visé
- gauche : canaux et utilisateurs ;
- haut centre : edge Azure, gateway, IAM et légende de trajectoire ;
- centre : runtime AKS décrit dans son état final microservices ;
- bas centre : bases de données, cache et observabilité ;
- droite : SI externe, partenaires et fournisseurs techniques.

## Code couleur des étapes
- orange : noyau critique du premier modulith (`Compte Client`, `Catalogue`, `Commande`) ;
- vert : domaines ajoutés pour obtenir le modulith complet (`Réclamations`, `Franchise`) ;
- bleu : services extraits en priorité pendant la transition (`Paiement`, `Livraison`, `Notification`, `Integration Hub / ACL`) ;
- violet : briques de distribution finale (`Orchestrateur Saga` et bases associées).

## Couleurs des flux
- bleu : accès HTTP depuis le web/mobile et appels synchrones ;
- orange : événements asynchrones sur le broker ;
- violet : données, cache et logs ;
- rouge : paiement en ligne ;
- vert : intégrations ERP, trésorerie, messagerie, POS et EBICS.

## Message du schéma
Le schéma vise maintenant la cible runtime finale de l'option 3, c'est-à-dire une plateforme complètement découpée en microservices. La logique modulith-first n'a pas disparu : elle est racontée par la couleur des services, qui indique dans quel ordre les domaines sont construits puis extraits.
