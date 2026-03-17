# 2. Option 3 - Hybrid Transition Path

## Status
Accepted

## Context
Good Food must modernize without disrupting production.
- Online sales are business-critical.
- The current information system and vendors remain in place during the transition.
- Internal engineering maturity grows over time.
- A new POS rollout must be absorbed during the transformation.

## Decision
Adopt a progressive hybrid path:
- start with a well-structured modulith core,
- add gateway, IAM, messaging, and anti-corruption layers,
- extract the highest-pressure domains first: `payment`, `delivery`, and `notification`,
- introduce distributed orchestration only when boundaries are stable.

## Consequences
- Lower migration risk.
- Better compatibility with the existing hybrid landscape.
- Progressive team ramp-up.
- Higher cumulative cost and a longer transition than a direct cutover.
- Strong modularity discipline remains mandatory.
