# Overview - Good Food 3.0 Option 3

## Scope
This workspace shows the final Option 3 microservices target.
Phase colors indicate rollout order, not separate environments.
The runtime is grouped inside one Kubernetes cluster.

## Key Adjustments
- The web app uses `React`.
- The model includes both customer and courier mobile apps.
- Payments go through a `Payment Provider Adapter` to `BNB / PSP`.
- `C2` focuses on service flows, `C3` adds data stores, and `C4` shows components.

## Technology Stack
- Frontend: React, React Native
- Platform: Kubernetes, YARP, Keycloak, RabbitMQ, Redis, ELK
- Services: ASP.NET Core, plus Node.js / TypeScript for delivery
- Data: PostgreSQL, plus MongoDB for delivery
- Integrations: Google Maps, SendGrid, Twilio, Firebase

## Phase Colors
- Phase 1: Customer, Catalog, Order
- Phase 2: Complaint, Franchise
- Phase 3: Payment, Delivery, Notification, Integration Hub / ACL
- Phase 4: Saga Orchestrator and full distributed runtime

## Reading Notes
- `C2` hides databases to keep the main flows readable.
- `C3` adds databases and cache with `PostgreSQL`, `MongoDB`, and `Redis` icons.
- Each service shows one primary technology icon.
- The `Kubernetes Cluster` boundary shows the shared target runtime.
- The dashed gold border marks services using a `Circuit Breaker` pattern.
