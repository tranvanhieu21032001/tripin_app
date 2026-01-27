# wemu_team_app

Flutter app for Wemu Team.

## Source structure

The project follows a feature-first structure under `lib/`:

- `lib/main.dart`: App entry point; sets up DI and localization.
- `lib/core/`: App-wide utilities and shared infrastructure.
  - `lib/core/di/`: Dependency injection setup (get_it + injectable).
  - `lib/core/configs/`: Theme, assets, and shared configuration.
- `lib/features/`: Feature modules (UI, data, domain, bloc).
  - `lib/features/login/`: Login feature (API, token storage, bloc).
    - `data/`: Remote/local data sources and repositories.
    - `domain/`: Use cases and abstract repositories.
    - `presentation/`: UI state management (bloc/cubit).
- `lib/widgets/`: Reusable UI components (inputs, buttons, etc.).
- `lib/generated/`: Generated localization output from l10n.
- `lib/l10n/`: Localization ARB files (en.arb, vi.arb).

## Code generation and tooling

When you change DI annotations or add injectable classes:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

When you change localization ARB files:

```bash
flutter gen-l10n
```

## Run the app

```bash
flutter pub get
flutter run
```
# tripin_app
