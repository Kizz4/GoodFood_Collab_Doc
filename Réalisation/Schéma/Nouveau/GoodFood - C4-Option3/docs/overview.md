# Overview - Good Food 3.0 Option 3

## Scope
This workspace represents the selected Option 3 for Good Food:
- a progressive hybrid path,
- a cleanly structured core first,
- then service extractions for the highest-pressure domains.

Phase colors show rollout order, not separate environments.
The target runtime remains grouped inside a single Kubernetes cluster.

## Context
- online sales are business-critical;
- the legacy information system must keep running during the transition;
- Good Food must absorb a new POS, ERP/finance integrations, and significant load growth;
- the internal team must progressively take over delivery and operations.

## Architecture Choice
- single entry point through `API Gateway`;
- centralized IAM through `Keycloak`;
- domain-driven boundaries with progressive extraction;
- asynchronous exchanges through `RabbitMQ`;
- `Catalog Service` serves precomposed store-specific views built from base products and local assortment events;
- `Order Service` validates checkout against a locally replicated commercial snapshot instead of calling `Catalog Service` synchronously;
- `Payment Service` handles the online payment flow through `BNB / PSP`;
- the former broad franchise scope is split into `Local Assortment`, `Supplier`, and `Preparation` services;
- explicit anti-corruption layer for TPE/store-side systems, ERP, treasury, and messaging;
- deliberate polyglot exception for delivery: `Node.js + TypeScript + MongoDB`.

## Technology Stack
- Frontend: `React`, `React Native`
- Platform: `Kubernetes`, `YARP`, `Keycloak`, `RabbitMQ`, `Redis`, `ELK`
- Services: `ASP.NET Core`, plus `Node.js / TypeScript` for delivery
- Data: `PostgreSQL`, plus `MongoDB` for delivery
- Integrations: `Google Maps`, `SendGrid`, `Twilio`, `Firebase`, `Dynamics 365`, `Sage`, `Microsoft 365`, `TP System / TPE`

## Reading Guide
- `C2` shows the runtime facade, containers, and external integrations.
- `C3` shows the main business flows as dynamic views owned by the responsible service: detailed internal components for that service, and neighboring containers for the rest of the flow.
- catalog reads are shown as resolved store views, while checkout relies on an asynchronously replicated commercial snapshot inside `Order Service`.
- `C4` details the internals of each target service or logical boundary.

## Phase Colors
- Phase 1: Customer, Catalog, Order
- Phase 2: Complaint, Local Assortment, Supplier, Preparation
- Phase 3: Payment, Delivery, Notification, Integration Hub
- Phase 4: Saga Orchestrator and full distributed runtime
