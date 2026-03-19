# 1. Progressive Hybrid Architecture for Good Food 3.0

## Status
Accepted

## Context
Good Food must modernize its platform without disrupting production.
- Online sales are critical to the business.
- The legacy platform remains in place during the transition.
- The target scope covers web, mobile, franchise, support, and back-office use cases.
- The information system must absorb a new POS and several external integrations.
- The internal team must gradually increase its maturity on distributed operations.

## Decision
Adopt a progressive hybrid architecture with:
- a single facade through `API Gateway`,
- a domain-structured core exposed as service boundaries,
- priority extractions for `payment`, `delivery`, `notification`, and `integration`,
- asynchronous exchanges through `RabbitMQ`,
- centralized IAM,
- one database per domain once extraction is stable,
- distributed orchestration introduced only when boundaries are mature enough.

## Consequences
- Lower migration risk than a big-bang microservices cutover.
- Clearer business boundaries and a more defensible extraction path.
- Easier integration with ERP, finance, payment, POS, and logistics systems.
- Targeted scalability on the most constrained domains.
- Higher operational complexity as extractions increase.
- Strong discipline required on API contracts, event contracts, and observability.

## Alternatives Considered
- Legacy monolith: simple in the short term, but insufficient for growth and integrations.
- Full microservices from day one: aligned with the final target, but too risky for the Good Food context.
- Progressive hybrid architecture: selected to balance evolvability, migration risk, and team ramp-up.
