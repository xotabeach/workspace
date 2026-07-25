# Backend review checklist

## API and correctness

- Router status codes and response models match behavior.
- Request bodies, paths, queries, pagination, and sorting are bounded.
- Empty/not-found/conflict/invalid-state cases are explicit and consistent.
- Application services do not leak ORM objects or infrastructure exceptions.
- Async sessions, clients, and Redis connections are closed correctly.
- Multi-write operations have intentional transaction boundaries and rollback.
- Datetimes are timezone-aware; ordering and pagination are deterministic.

## Architecture and maintainability

- Presentation imports application contracts, not database implementation.
- Domain/application avoid FastAPI, SQLAlchemy engines, and provider SDKs.
- Infrastructure implements explicit repository/port behavior.
- Public domain/application functions are strictly typed.
- No duplicated business rules, magic state strings, broad exception catches,
  silent fallbacks, prints, or unjustified ignores.

## Data and migrations

- Database constraints enforce invariants that matter under concurrency.
- Foreign keys, uniqueness, nullability, delete behavior, and indexes match
  access patterns.
- Dynamic SQL identifiers are allowlisted; values are bound.
- PostGIS SRID/types and spatial indexes are explicit.
- Alembic revisions are additive, ordered, reversible where practical, and do
  not contain application business logic.

## Security

- Explicit object/function authorization; identifiers are not authorization.
- DTOs prevent mass assignment and ORM serialization leaks.
- Secrets and sensitive data never reach logs or error responses.
- URLs, files, media, providers, and redirects have allowlists, limits, and
  timeouts.
- Production configuration rejects local/default credentials and cleartext.
- Security tests cover injection-like input as data, oversized input,
  unpublished/private access, and error disclosure.

## Operations and tests

- Health/readiness checks describe dependencies accurately.
- Structured logs include useful correlation without sensitive values.
- Configuration failures are early and actionable.
- Unit tests isolate ports; integration tests exercise real database behavior
  where ORM/PostGIS semantics matter.
- Regression tests fail before each proposed bug fix.
