# 1. Option 3 - Trajectoire hybride progressive

## Status
Accepted

## Context
Le contexte Good Food impose :
- 80 % du chiffre d'affaires en ligne,
- une migration sans impact sur la production,
- des dépendances fortes au SI existant et aux prestataires,
- une équipe interne sans maturité développement au départ,
- un besoin d'évolutivité, d'intégration et de scalabilité,
- un lot `nouveau système de caisse` à absorber pendant la transformation.

## Decision
Adopter une trajectoire hybride progressive :
- coeur modernisé en modulith bien découpé,
- intégration via API Gateway, IAM, broker et couche anti-corruption,
- extraction ciblée des domaines à plus forte pression (`paiement`, `livraison`, `notification`),
- orchestration distribuée introduite seulement quand la frontière métier est stable.

## Consequences
- meilleure maîtrise du risque de migration,
- meilleure compatibilité avec le SI hybride existant,
- montée en compétence progressive,
- coût cumulé et durée de transformation plus élevés qu'une bascule directe,
- nécessité de garder une discipline de modularité stricte pour éviter un faux modulith.
