---
name: travel-platform-security-audit
description: Audit and safely remediate security issues in the CrimeaTrip Python FastAPI backend, Flutter mobile application, PostgreSQL/PostGIS, Redis, MinIO, containers and GitLab CI. Use before authentication, authorization, user-data, upload, AI/RAG, infrastructure changes, releases, or when explicitly requested to run a security review.
---

# Travel platform security audit

Canonical docs: `tourism-platform/docs/security/`.
Do not claim full security. Do not push, touch production, rotate real secrets,
or run DAST outside local/explicit staging.

## PHASE 1 — Scope

1. Identify repositories and changed files (`tourism-platform`, `tourism-backend`, `tourism-mobile`, workspace).
2. Read `docs/security/security-baseline.md` and relevant topic docs.
3. Identify assets and trust boundaries (`threat-model.md`).
4. Define scope: whole project | current diff | one module | one endpoint | one release.

## PHASE 2 — Read-only audit

1. Inventory dependencies (`uv.lock`, `pubspec.lock`).
2. Search secrets (no real values in reports — mask).
3. Search dangerous patterns (`eval`, string SQL, `pickle`, `shell=True`, cleartext prod).
4. Review auth / password / token handling.
5. Review authorization (BOLA/BFLA/mass assignment).
6. Review input validation and limits.
7. Review SQL / PostGIS.
8. Review HTML/WebView/Markdown.
9. Review CSRF applicability (Bearer vs cookie).
10. Review files/MinIO.
11. Review Redis/cache.
12. Review external APIs/SSRF/AI.
13. Review logs/error handlers.
14. Review CI/container/infra.
15. Run available non-destructive checks (`validate.sh`, `pytest tests/security`, `pip-audit`, `ruff`, `flutter analyze`).

## PHASE 3 — Findings report

For each finding include: ID, severity (Critical/High/Medium/Low/Informational),
confidence (Confirmed/High/Medium/Low/Needs manual verification), CWE, OWASP
mapping, repo, file/lines, evidence, attack scenario, impact, existing
mitigations, remediation, required tests, breaking-change risk, status.

Do not publish exploit-ready instructions for production. Describe attack path
and safe regression test only.

Do not assert a vulnerability without file, code locus, attack path, and
evidence or justified probability. Do not treat disputed items as confirmed.

## PHASE 4 — Remediation plan

**SAFE AUTOMATIC:** missing validation, explicit DTOs, limits, insecure log
fields, parameterized query fix, missing tests, secure default config.

**REQUIRES REVIEW:** auth contract, token format, crypto/key migration,
password hash migration, DB privilege changes, destructive migrations, RLS,
public API compatibility, production secret rotation, bucket/network policy,
user data deletion, retention changes.

For REQUIRES REVIEW: prepare patch plan; do not apply without explicit approval.

## PHASE 5 — Fix

1. Fix root cause; no security theatre.
2. Do not suppress scanner findings without justification / exception record.
3. No broad noqa/ignore.
4. Add regression tests.
5. Preserve API compatibility or state breaking change explicitly.
6. Do not replace one vuln with another; no homemade crypto.
7. Do not weaken controls to pass tests.

## PHASE 6 — Verification

formatter, lint, typecheck, unit/integration/security tests, dependency audit,
secret scan, SAST/container scan if available, inspect diff.

## PHASE 7 — Report

Write `tourism-platform/docs/security/audits/YYYY-MM-DD-security-audit.md` with:
scope, commit/branch, tools, commands, tests, findings summary, fixed,
accepted risk, false positives, unresolved, not tested, recommendations,
exact command results. Never write real secrets into the report.
