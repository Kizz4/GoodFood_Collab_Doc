# 1. Microservices Architecture for Good Food 3.0

## Status
Accepted

## Context
Good Food needs a platform that can handle growth, integrations, and peak traffic.
- Online sales are critical to the business.
- The legacy platform is hard to maintain.
- The target includes web, mobile, franchise, and back-office use cases.

## Decision
Adopt a microservices architecture with:
- an API Gateway as the single entry point,
- business services split by domain,
- asynchronous events through a message broker,
- service discovery for runtime routing,
- one database per service.

## Consequences
- Better scalability and availability.
- Clearer ownership and easier maintenance.
- Easier integration with ERP, finance, payment, and logistics systems.
- Higher operational complexity and governance needs.

## Alternatives Considered
- Monolith: simple to deploy, but hard to scale and evolve.
- Modular monolith: cleaner structure, but less flexible for the target runtime.
- Microservices: chosen for scale, integration, and domain isolation.
