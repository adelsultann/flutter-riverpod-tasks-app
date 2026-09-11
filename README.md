# Flutter Riverpod Tasks App

A cross-platform task manager built with Flutter, Riverpod, GoRouter, and
Supabase, with the local backend stack running in Docker. The project
demonstrates feature-first architecture, separation of concerns, typed
navigation, authenticated CRUD operations, Row Level Security, and an app-wide
Material 3 theme.

## Features

- Email and password sign-up, sign-in, and sign-out with Supabase Auth
- Authentication-aware redirects with typed GoRouter routes
- Create, list, complete, and delete tasks
- Per-user task isolation enforced by PostgreSQL Row Level Security (RLS)
- Riverpod for state management and dependency injection
- Material 3 light, dark, and system themes generated from a teal seed color
- A persistent theme selector backed by device-local preferences
- App-wide Inter typography kept separate from theme composition
- Compile-time development, staging, test, and production configuration

## Technology stack

| Area | Technology |
| --- | --- |
| UI | Flutter and Material 3 |
| State and dependency injection | Riverpod 3 |
| Navigation | GoRouter with generated typed routes |
| Backend and authentication | Supabase |
| Local backend environment | Supabase CLI and Docker |
| Database security | PostgreSQL Row Level Security |
| Models and serialization | Freezed and json_serializable |
| Local preferences | shared_preferences |
| Typography | google_fonts (Inter) |
| Code generation | build_runner |

The project also includes Drift, SQLite, and Dio dependencies as foundations
for future offline and network-layer work. Current task data is provided by
Supabase.

## Architecture

The application uses a feature-first, layered structure:

```text
lib/
├── app/
│   ├── config/          # Build environments and Supabase settings
│   ├── router/          # GoRouter configuration and typed routes
│   └── theme/           # Color, typography, and theme-mode state
├── core/                # Shared infrastructure
├── features/
│   ├── auth/
│   │   ├── application/ # Riverpod providers and controllers
│   │   ├── data/        # Supabase repository implementation
│   │   ├── domain/      # Entities, contracts, and use cases
│   │   └── presentation/# Authentication screens
│   ├── home/
│   └── tasks/
│       ├── application/ # Task providers and controller
│       ├── data/        # Supabase data source, models, and repository
│       ├── domain/      # Task entity, repository contract, and use cases
│       └── presentation/# Task list and task creation screens
└── main.dart            # Application startup and ProviderScope
```

The main dependency flow is:

```text
Presentation → Application → Domain ← Data
```

- **Presentation** renders widgets and forwards user actions.
- **Application** coordinates use cases and exposes state through Riverpod.
- **Domain** owns business entities, repository contracts, and use cases.
- **Data** implements domain contracts and communicates with Supabase.

App-wide concerns stay outside feature folders. For example,
`AppTypography` owns font decisions, `AppTheme` composes typography and color,
and `ThemeModeController` owns the user's theme preference. Screens consume the
result through `Theme.of(context)` rather than depending on typography details.

More detail is available in [`doc/architecture_overview.md`](doc/architecture_overview.md)
and [`doc/auth_feature_guide.md`](doc/auth_feature_guide.md).

## Prerequisites

Install the following before running the project:

- [Flutter](https://docs.flutter.dev/get-started/install) with a Dart SDK
  compatible with `^3.13.0`
- A supported Flutter target such as an Android emulator, iOS simulator,
  desktop platform, or web browser
- [Node.js and npm](https://nodejs.org/) for the project-local Supabase CLI
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) for the
  local Supabase services

Confirm Flutter is ready:

```shell
flutter doctor
```

## Installation

Clone the repository and enter its directory:

```shell
git clone <repository-url>
cd flutter-riverpod-tasks-app
```

Install Flutter and Node dependencies:

```shell
flutter pub get
npm install
```

## Start local Supabase

Make sure Docker Desktop is running, then start the local stack:

```shell
npx supabase start
```

The first start may take a few minutes while Docker images are downloaded. The
committed migration creates the `tasks` table and its RLS policies.

Show the local URLs and API keys at any time with:

```shell
npx supabase status
```

This project configures the following local ports:

| Service | Address |
| --- | --- |
| Supabase API | `http://127.0.0.1:55552` |
| Supabase Studio | `http://127.0.0.1:55553` |
| PostgreSQL | `127.0.0.1:55555` |
| Local email viewer | `http://127.0.0.1:54310` |

Stop the local services when they are no longer needed:

```shell
npx supabase stop
```

### Reset the local database

After changing migrations, you can rebuild the local database with:

```shell
npx supabase db reset
```

> This deletes all data in the local Supabase database before applying the
> migrations again. It does not reset a hosted project.

## Configure the app

Create `tool/local.json`. This file is intentionally ignored by Git.

For an Android emulator, use `10.0.2.2` to reach the computer hosting
Supabase:

```json
{
  "RAHA_ENV": "development",
  "SUPABASE_URL": "http://10.0.2.2:55552",
  "SUPABASE_PUBLISHABLE_KEY": "your-local-publishable-key"
}
```

For Flutter Web, desktop, or an iOS simulator running on the same computer,
use the loopback address instead:

```json
{
  "RAHA_ENV": "development",
  "SUPABASE_URL": "http://127.0.0.1:55552",
  "SUPABASE_PUBLISHABLE_KEY": "your-local-publishable-key"
}
```

Copy the publishable key shown by `npx supabase status`. Never place a Supabase
secret or service-role key in this Flutter application.

The optional `RAHA_ENV` value defaults to `development`. Supported values are:

- `development`
- `staging`
- `test`
- `production`

These values select non-secret application behavior such as logging and the
debug banner. Supabase connection values are supplied separately through Dart
defines.

For a physical device, replace the loopback host with an address that the
device can reach on the local network.

## Run the app

From a terminal:

```shell
flutter run --dart-define-from-file=tool/local.json
```

In VS Code, select the included **Tasks App — Local Supabase** launch
configuration. It passes the same Dart-define file automatically.

To choose a specific device first:

```shell
flutter devices
flutter run -d <device-id> --dart-define-from-file=tool/local.json
```

## Code generation

Generated files support typed routes, immutable models, JSON serialization,
and generated asset access. Regenerate them after changing annotated source
files or assets:

```shell
dart run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:

```shell
dart run build_runner watch --delete-conflicting-outputs
```

Do not edit `*.g.dart` or `*.freezed.dart` files manually; regeneration will
overwrite those changes.

## Theme system

The app uses a teal Material 3 color scheme with light and dark variants.
`AppTypography` applies Inter to Material's base `TextTheme`, preserving the
correct colors for both brightness modes.

Users can choose System, Light, or Dark from the task screen. Riverpod exposes
the selection to the root `MaterialApp`, and `shared_preferences` restores it
after an app restart.

```text
AppTypography → AppTheme → MaterialApp → Screens
ThemeModeController ────────────────┘
```

## Database and security

The initial migration creates a `public.tasks` table containing:

- `id`
- `user_id`
- `title`
- `description`
- `is_completed`
- `created_at`

RLS is enabled. Authenticated users can select, insert, update, and delete only
rows whose `user_id` matches their authenticated Supabase user ID.

Environment-specific files and Supabase CLI state are excluded from Git,
including:

- `tool/local.json`
- `.env` files
- `supabase/.temp/`
- `supabase/.branches/`
- `node_modules/`

Publishable keys are intended for client applications when RLS is correctly
configured. Secret and service-role keys bypass RLS and must remain on a secure
backend.

## Quality checks

Format and analyze the project before committing:

```shell
dart format .
flutter analyze
```

The repository does not currently include automated tests. Unit and widget
tests are planned improvements.

## Current limitations and planned improvements

- Add repository and controller tests
- Improve user-facing authentication error messages
- Add password reset, email confirmation, and stronger form validation
- Preserve the originally requested route through authentication
- Add pagination, retry behavior, and offline synchronization
- Bundle Inter font assets for fully offline production use

## Contributing

Issues and pull requests are welcome. Keep feature code within its appropriate
layer, do not commit generated secrets or local configuration, and run the
formatter and analyzer before opening a pull request.

## License

This repository does not currently include a license. Add a license before
granting reuse or redistribution rights.
