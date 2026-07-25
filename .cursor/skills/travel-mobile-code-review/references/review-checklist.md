# Mobile review checklist

## Behavior and state

- Every async screen has deterministic loading, error, empty, and data states.
- Providers and controllers have intentional lifetimes and invalidation.
- Async callbacks check mounted/context safety and avoid duplicate completion.
- User actions are interruption-safe and cannot commit twice.
- Lists/decks use stable identity and preserve state intentionally.

## Architecture and navigation

- Presentation uses providers and repository ports rather than Dio/storage.
- Domain models avoid UI/network dependencies.
- API and mock repositories obey the same contract.
- Shell branches, detail routes, deep links, back behavior, and selected nav
  state agree.
- Route extras are optional optimizations, not the sole source of data.

## Security and data

- Credentials use Keychain/Keystore-backed secure storage only.
- Logs, errors, analytics, UI, and deep links do not expose secrets/tokens.
- Production rejects cleartext endpoints and unsafe defaults.
- Remote URLs accept only intended schemes/hosts and use timeouts/limits.
- Server/user text is rendered as inert text, bounded, and never raw HTML.
- Parsing handles missing, wrong-type, oversized, and forward-compatible data.

## UI, accessibility, and performance

- Layout survives target sizes and text scale 1.3 without overlap/overflow.
- Semantics expose label, role, selected/toggled state, and logical order.
- Hit targets are at least 48 px and reduced-motion avoids stretch/overshoot.
- Platform-specific controls preserve equivalent behavior and contrast.
- Animations are interrupt-safe; controllers/focus/page/scroll objects dispose.
- Drag ticks rebuild only local surfaces; images are cached/preloaded.
- No `Opacity` ancestor applies inherited opacity to a `BackdropFilter`.
- Blur/shadow/saveLayer use is bounded and isolated by `RepaintBoundary`.

## Tests and release

- Behavior tests cover navigation, state, parsing, and regression paths.
- Security tests cover unsafe URLs, hostile text, oversized input, and config.
- Goldens are deterministic, local-asset-only, and reviewed before update.
- Native launch, manifests, permissions, release config, and platform assets
  are validated on each supported platform available to the reviewer.
