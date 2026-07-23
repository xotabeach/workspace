# Security audit

Run the project Skill **travel-platform-security-audit**
(`.cursor/skills/travel-platform-security-audit/SKILL.md`).

Follow its phases. Read `tourism-platform/docs/security/` first.
Do not push, touch production secrets, or DAST outside allowed environments.

## Scope variants

Pick one (or combine explicitly):

- `audit current diff` — changed files only
- `audit backend` — `tourism-backend`
- `audit mobile` — `tourism-mobile`
- `audit auth` — identity/tokens/password/storage
- `audit database` — Postgres/Redis/MinIO roles and access
- `audit release` — staging/release checklist + CI gates
- `audit whole workspace` — full Phase 2 inventory

Write findings to `tourism-platform/docs/security/audits/YYYY-MM-DD-security-audit.md`
unless the user asks for chat-only output.
