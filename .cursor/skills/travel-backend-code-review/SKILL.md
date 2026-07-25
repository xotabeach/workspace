---
name: travel-backend-code-review
description: Evidence-first review of the CrimeaTrip FastAPI/Python backend for correctness, API behavior, architecture, async and transaction safety, security, migrations, observability, and test quality. Use for whole-repository or change-set reviews of tourism-backend, before backend releases, and before planning backend remediation.
---

# Travel backend code review

Review first. Do not edit production code until findings from the requested
review scopes are recorded and a remediation plan exists.

## Prepare

1. Record branch, commit, worktree status, and review scope.
2. Read:
   - `.cursor/rules/workspace.mdc`
   - `.cursor/rules/python-backend.mdc`
   - `.cursor/rules/migrations.mdc`
   - `.cursor/rules/testing.mdc`
   - `.cursor/rules/security-baseline.mdc`
   - `tourism-platform/docs/python-code-style.md`
   - `tourism-platform/docs/python-testing-guide.md`
   - relevant `tourism-platform/docs/security/` documents
3. Read `references/review-checklist.md`.
4. If security-sensitive surfaces exist, apply
   `.cursor/skills/travel-platform-security-audit/SKILL.md` as a nested pass.
5. Preserve unrelated worktree changes. Never review generated or vendored
   files as authored source unless generation/configuration is the finding.

## Establish the baseline

Run non-destructive checks before drawing conclusions:

```bash
./scripts/validate.sh
uv run pytest
uv run pytest tests/security
uv run ruff check .
uv run mypy src
```

Run `uv run pip-audit` when its advisory data is available. Report unavailable
tools, services, network, Docker, PostGIS, Redis, or MinIO as unverified; do not
turn missing infrastructure into a finding against application code.

## Review in passes

1. Trace each public endpoint from router through application service to
   infrastructure and response schema.
2. Review correctness, failure behavior, async lifecycle, transactions,
   pagination, ordering, time zones, and resource cleanup.
3. Enforce presentation → application → domain boundaries and explicit ports.
4. Review DTO boundaries, validation limits, authorization, query safety,
   secret handling, SSRF/files/media, logs, and error disclosure.
5. Review models, indexes, constraints, PostGIS use, and Alembic
   upgrade/downgrade behavior.
6. Review configuration defaults, environment guards, health checks,
   containers, and CI validation.
7. Map behavior to tests. Look for missing negative, security, concurrency,
   transaction, migration, and integration coverage.

Do not report cosmetic preferences unless they hide a defect, violate a
project rule, or materially increase maintenance risk.

## Report findings

Write findings first, ordered by severity:

- `P0` critical security/data-loss/release blocker
- `P1` high-impact correctness, authorization, or reliability defect
- `P2` bounded defect or substantial maintainability/test risk
- `P3` low-risk hardening or code-quality issue

Each finding must include ID, priority, confidence, repository, absolute
file/line link, evidence, trigger/attack path, impact, current mitigation,
recommended fix, required regression tests, and compatibility/migration risk.
Do not claim a vulnerability without a concrete code locus and plausible path.

Write the review to:
`tourism-platform/docs/reviews/YYYY-MM-DD-backend-code-review.md`.
Include exact commands and results, unresolved questions, and unverified
areas. If there are no findings, say so and list residual risks/test gaps.

## Plan before remediation

After all requested repository reviews are complete, create one ordered plan
in `tourism-platform/docs/reviews/YYYY-MM-DD-code-review-remediation-plan.md`.
Group work by finding and commit boundary. Mark:

- safe automatic fixes;
- API/schema/migration/security decisions requiring review;
- dependencies and verification commands.

Only then implement approved safe fixes. Work outside `main`, add regression
tests, run the complete baseline again, update finding status without deleting
the original evidence, commit child repositories first, and bump workspace
submodule pointers last.
