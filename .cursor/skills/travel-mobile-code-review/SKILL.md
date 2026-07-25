---
name: travel-mobile-code-review
description: Evidence-first review of the CrimeaTrip Flutter application for correctness, Riverpod and repository architecture, navigation and lifecycle safety, secure data handling, platform behavior, accessibility, rendering performance, and test quality. Use for whole-repository or change-set reviews of tourism-mobile, before mobile releases, and before planning mobile remediation.
---

# Travel mobile code review

Review first. Do not edit application code or update goldens until findings
from the requested review scopes are recorded and a remediation plan exists.

## Prepare

1. Record branch, commit, worktree status, platform targets, and review scope.
2. Read:
   - `.cursor/rules/workspace.mdc`
   - `.cursor/rules/flutter-mobile.mdc`
   - `.cursor/rules/testing.mdc`
   - `.cursor/rules/security-baseline.mdc`
   - `tourism-platform/docs/flutter-code-style.md`
   - `tourism-platform/docs/flutter-testing-guide.md`
   - relevant `tourism-platform/docs/security/mobile-security.md`
3. Read `references/review-checklist.md`.
4. Apply `.cursor/skills/travel-platform-security-audit/SKILL.md` to network,
   storage, deep-link, untrusted-content, and platform configuration surfaces.
5. Preserve unrelated changes and distinguish generated platform files from
   authored configuration.

## Establish the baseline

Run non-destructive checks before drawing conclusions:

```bash
./scripts/validate.sh
flutter analyze --fatal-infos
flutter test
flutter test test/security
```

Run platform builds available in the environment. Review existing goldens;
never silently update them during the audit. Report unavailable Android/iOS
SDKs, simulators, devices, or signing as unverified rather than passing.

## Review in passes

1. Trace each screen from router through provider, repository interface, data
   source, parsing, and rendered states.
2. Review async lifecycle, mounted/context use, cancellation, duplicate
   requests, error/empty/loading states, and state restoration.
3. Review `StatefulShellRoute`, branch ownership, deep links, back behavior,
   route arguments, and persistent navigation state.
4. Enforce feature-first boundaries: widgets do not call Dio or storage;
   repositories do not own presentation state.
5. Review DTO parsing, URL handling, untrusted text, secure storage, logs,
   production configuration, TLS assumptions, and platform manifests.
6. Review responsive layout, text scaling, semantics, focus order, contrast,
   48 px targets, reduce-motion, and platform-specific behavior.
7. Review animation interruption, controller disposal, rebuild scope, image
   decode/cache behavior, `BackdropFilter`, opacity/saveLayer interactions,
   and list/deck key stability.
8. Map behavior to tests and goldens. Look for missing navigation, lifecycle,
   parsing, security, accessibility, responsive, reduced-motion, and platform
   regressions.

Do not report subjective design taste unless it contradicts the supplied
design source, accessibility, a project token, or deterministic screenshot.

## Report findings

Write findings first, ordered by severity:

- `P0` credential exposure, unsafe release, or critical data-loss blocker
- `P1` high-impact correctness, navigation, security, or crash defect
- `P2` bounded user-visible defect or substantial architecture/test risk
- `P3` low-risk hardening, accessibility, performance, or code-quality issue

Each finding must include ID, priority, confidence, repository, absolute
file/line link, evidence, reproducible state, user/security impact, current
mitigation, recommended fix, regression tests, platform scope, and visual/API
compatibility risk.

Write the review to:
`tourism-platform/docs/reviews/YYYY-MM-DD-mobile-code-review.md`.
Include exact commands and results, reviewed goldens/platforms, unresolved
questions, and unverified areas. Never claim pixel-perfect without a visual
diff.

## Plan before remediation

After all requested repository reviews are complete, create one ordered plan
in `tourism-platform/docs/reviews/YYYY-MM-DD-code-review-remediation-plan.md`.
Group work by finding and commit boundary. Mark fixes that need design,
backend-contract, dependency, migration, or release approval.

Only then implement approved safe fixes. Add regression tests before or with
each fix, do not update dependencies automatically, rerun the full baseline
and relevant platform build, update finding status without erasing evidence,
commit child repositories first, and bump workspace pointers last.
