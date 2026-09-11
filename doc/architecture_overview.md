# Tasks App — Full Architecture Overview

This document summarizes the entire architecture, concepts, patterns, and Q&A discussed during the development of the Tasks App.  
It is designed as a long-term reference for maintaining and scaling the project.


UI → Riverpod → Repository → API + Drift → Models
---

## Table of Contents
1. [Technology Stack](#1-technology-stack)
2. [Architecture Style — Feature-First Layered Architecture](#2-architecture-style--feature-first-layered-architecture)
3. [Navigation — GoRouter + Typed Routes](#3-navigation--gorouter--typed-routes)
4. [Riverpod — State Management + Dependency Injection](#4-riverpod--state-management--dependency-injection)
5. [Models — Freezed + JSON](#5-models--freezed--json)
6. [Local Database — Drift](#6-local-database--drift)
7. [Environment System — Compile-Time Selection](#7-environment-system--compile-time-selection)
8. [API Layer — Dio + Riverpod](#8-api-layer--dio--riverpod)
9. [Repository — API + Drift Combined (Production Pattern)](#9-repository--api--drift-combined-production-pattern)
10. [UI — Reactive Screens](#10-ui--reactive-screens)
11. [Key Questions & Answers](#11-key-questions--answers)
12. [Summary — What This Architecture Gives You](#12-summary--what-this-architecture-gives-you)
13. [Next Steps (Optional Enhancements)](#13-next-steps-optional-enhancements)

---

## 1. Technology Stack

| Area | Technology | Purpose |
|------|------------|---------|
| Application framework | Flutter | Android/iOS UI |
| State management | Riverpod | Reactive state + DI |
| Navigation | GoRouter | Declarative routing |
| Typed navigation | go_router_builder | Type-safe routes |
| Immutable models | Freezed | Data classes |
| JSON serialization | json_serializable | Model ↔ JSON |
| Local database | Drift | SQLite ORM |
| Networking | Dio | API client |
| Environment system | Dart defines | dev/staging/test/prod |
| Code generation | build_runner | Generates all code |

---

## 2. Architecture Style — Feature-First Layered Architecture

```
lib/
├── src/
│   ├── features/
│   │   └── tasks/
│   │       ├── data/        # API, Drift, repositories
│   │       ├── domain/      # Models, providers, business logic
│   │       └── presentation/# Screens, widgets, controllers
│   ├── core/
│   │   ├── router/          # GoRouter + typed routes
│   │   ├── database/        # Drift database
│   │   ├── network/         # Dio client + API service
│   │   ├── config/          # Environment system
│   │   └── utils/           # Logging, helpers
│   └── main.dart
```

### Why feature-first?
- Each feature is isolated
- Easy to scale
- Easy to test
- Clean separation of concerns
- No "god folders" like `services/` or `screens/`

---

## 3. Navigation — GoRouter + Typed Routes

### Example:
```dart
@TypedGoRoute<TaskDetailsRoute>(
  path: '/task/:id',
)
class TaskDetailsRoute extends GoRouteData {
  const TaskDetailsRoute(this.id);
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TaskDetailsScreen(taskId: id);
  }
}
```

### Benefits:
- Type-safe navigation
- Refactor-safe
- No string mistakes
- Cleaner router
- Stronger architecture

---

## 4. Riverpod — State Management + Dependency Injection

### Provider types:
- `Provider` → static objects (router, database, API client)
- `StateProvider` → simple mutable state
- `AsyncNotifierProvider` → async business logic
- `StreamNotifierProvider` → reactive DB streams

### Example:
```dart
class TasksNotifier extends StreamNotifier<List<Task>> {
  @override
  Stream<List<Task>> build() {
    final repo = ref.read(tasksRepositoryProvider);
    return repo.watchTasks();
  }
}
```

### Why Riverpod?
- DI (dependency injection)
- Reactive state
- Testability
- Clean architecture
- No global mutable state

---

## 5. Models — Freezed + JSON

### Example:
```dart
@freezed
class Task with _$Task {
  const factory Task({
    int? id,
    required String title,
    String? description,
    @Default(false) bool isCompleted,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
```

### Benefits:
- Immutable
- `copyWith`
- JSON serialization
- Pattern matching
- Clean domain layer

---

## 6. Local Database — Drift

### Example table:
```dart
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
```

### Drift advantages:
- Type-safe SQL
- Streams for reactive UI
- Transactions
- Compile-time validation

---

## 7. Environment System — Compile-Time Selection

### BuildConfig:
```dart
const value = String.fromEnvironment('RAHA_ENV', defaultValue: 'development');
```

### Environments:
- `development`
- `staging`
- `test`
- `production`

### Why compile-time?
- Safer
- Deterministic
- CI/CD friendly
- No runtime switching
- No global mutable state

### Riverpod provider:
```dart
final buildConfigProvider = Provider<BuildConfig>((ref) {
  return BuildConfig.fromDartDefine();
});
```

---

## 8. API Layer — Dio + Riverpod

### Dio client:
```dart
final dioProvider = Provider<Dio>((ref) {
  final config = ref.read(buildConfigProvider);
  final dio = Dio(BaseOptions(baseUrl: config.settings.baseUrl));

  if (config.settings.enableLogging) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  return dio;
});
```

### API service:
```dart
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref.read(dioProvider));
});
```

---

## 9. Repository — API + Drift Combined (Production Pattern)

### Repository responsibilities:
- API = source of truth
- Drift = local cache
- Repository = orchestrator
- Riverpod = exposes data to UI

### Example:
```dart
Future<List<Task>> getAllTasks() async {
  final local = await _db.select(_db.tasks).get();

  try {
    final remote = await _api.fetchTasks();
    await _syncLocalWithRemote(remote);
    return remote;
  } catch (_) {
    return local; // fallback
  }
}
```

### Stream for UI:
```dart
Stream<List<Task>> watchTasks() {
  return _db.select(_db.tasks).watch().map(_mapRowToTask);
}
```

---

## 10. UI — Reactive Screens

### Example:
```dart
final tasks = ref.watch(tasksProvider);

return tasks.isEmpty
  ? Center(child: Text('No tasks'))
  : ListView.builder(...);
```

### Create task:
```dart
ref.read(tasksProvider.notifier).addTask(
  Task(title: 'New task', description: 'Created now'),
);
```

---

## 11. Key Questions & Answers

### Q: Why typed routes?
**A:** Type-safe navigation, refactor-safe, cleaner router.

### Q: Why Riverpod for router?
**A:** Router depends on app state (auth, locale, config).

### Q: Why nullable id in Task?
**A:** Drift auto-generates IDs.

### Q: Why StreamNotifier?
**A:** Drift streams → automatic UI updates.

### Q: Why combine API + Drift?
**A:** API = truth, Drift = offline cache.

### Q: Why compile-time environments?
**A:** Safer, deterministic, CI/CD friendly.

### Q: Why wrap Dio in ApiService?
**A:** Clean DI, testability, separation of concerns.

### Q: Why feature-first architecture?
**A:** Scalable, isolated, maintainable.

---

## 12. Summary — What This Architecture Gives You

- Offline-first
- API + local cache
- Typed navigation
- Reactive UI
- Clean separation of concerns
- Enterprise-level environment system
- Testable, scalable, maintainable codebase

**This is a real production architecture, not a tutorial-level setup.**

---

## 13. Next Steps (Optional Enhancements)

- Error handling layer
- Retry logic
- Sync service
- Background tasks
- Authentication + refresh tokens
- Pagination
- Unit tests + integration tests

---

## 14. Current Feature Structure

The app uses a feature-first layout. Each feature owns the files required to
implement one area of the product, rather than placing every screen, model, or
repository in one global folder.

```text
lib/
├── app/
│   ├── config/                 # Environment and Supabase configuration
│   └── router/                 # Typed GoRouter routes and auth redirects
├── core/                       # Shared infrastructure only
├── features/
│   ├── auth/
│   │   ├── application/        # Riverpod providers and AuthController
│   │   ├── data/               # SupabaseAuthRepository
│   │   ├── domain/             # AppUser, AuthRepository, auth use cases
│   │   └── presentation/       # Loading, sign-in, and sign-up screens
│   └── tasks/
│       ├── application/        # Task providers and TaskController
│       ├── data/               # Supabase source, model, repository impl
│       ├── domain/             # AppTask, repository contract, use cases
│       └── presentation/       # List and create-task screens
└── main.dart                   # App startup and ProviderScope
```

### Separation of concerns

| Layer | Responsibility | Must not know about |
|---|---|---|
| Presentation | Renders widgets, collects input, starts application commands, displays loading/errors. | Supabase queries and concrete repository implementations. |
| Application | Wires dependencies with Riverpod, exposes read state, and coordinates UI commands/loading/errors. | Widget layout details and raw Supabase API calls. |
| Domain | Defines the business vocabulary and rules: entities, repository contracts, and use cases. | Flutter, Riverpod, Supabase, and JSON/database models. |
| Data | Implements domain contracts, maps data models to domain entities, and calls external services. | Widget state and presentation navigation. |

The dependency direction always points inward:

```text
presentation → application → domain ← data
```

At runtime, a user request starts at the UI and travels downward to the data
layer. The response then returns upward as domain data and Riverpod state.

```text
User interaction
→ screen
→ controller/use case
→ repository contract
→ repository implementation
→ Supabase
→ application state
→ screen rebuild
```

## 15. Tasks Feature: What We Built

### Domain

`AppTask` is the task entity used outside the data layer. `TaskRepository` is a
contract describing task operations without saying how they are stored:

- get tasks
- add a task
- update a task
- delete a task
- set completion

Each operation has a use case. Use cases are the domain entry points for an
application command. For example, `AddTaskUseCase` validates and normalizes
the title/description, generates an ID, then calls the repository contract.

### Data

`SupabaseTaskRemoteDataSource` owns Supabase table calls. `TaskModel` maps
database-shaped data, while `TaskRepositoryImpl` translates between
`TaskModel` and `AppTask`. This prevents Supabase fields and SDK types from
leaking into screens or use cases.

### Application

`task_providers.dart` is the dependency-composition point:

```text
SupabaseTaskRemoteDataSource
→ TaskRepositoryImpl
→ TaskRepository contract
→ task use cases
```

`tasksProvider` is a `FutureProvider<List<AppTask>>`. It owns read state for
the task list: loading, data, and error.

`TaskController` is a `Notifier<AsyncValue<void>>`. It owns command state for
add, update, delete, and completion changes. Separating these providers means
the list is not mixed with the state of a button press.

For each successful mutation, the controller invalidates `tasksProvider`:

```text
TaskController command succeeds
→ ref.invalidate(tasksProvider)
→ Riverpod marks the cached list stale
→ active tasksProvider watch reloads through GetTasksUseCase
→ TasksScreen rebuilds with fresh data
```

The controller uses `AsyncValue.guard` so exceptions become `AsyncError`
instead of forcing every screen to write repetitive `try/catch` blocks.

### Presentation

`TasksScreen` watches `tasksProvider` and renders:

- a loading indicator while tasks load;
- a retry UI when loading fails;
- an empty state when there are no tasks;
- a task list when data exists.

Completion checkboxes call `TaskController.setTaskCompletion`. The add button
pushes `CreateTaskScreen`.

`CreateTaskScreen` owns temporary form state: its form key and text editing
controllers. It validates input locally, then calls `TaskController.addTask`.
It watches command loading state to disable duplicate submissions, listens for
errors to show a snack bar, and pops only after a loading-to-success state
transition.

```text
Submit
→ TaskController becomes AsyncLoading
→ Save button disables
→ add task use case runs
→ success: task list invalidates and CreateTaskScreen pops
→ failure: CreateTaskScreen stays open and shows an error
```

## 16. Authentication Feature: Matching the Same Pattern

Authentication uses the same boundary pattern as tasks:

```text
presentation → AuthController → auth use case → AuthRepository
             → SupabaseAuthRepository → Supabase
```

`AuthRepository` is the domain contract. `SupabaseAuthRepository` is the data
implementation and converts Supabase `User` objects into the domain `AppUser`.

The application layer exposes:

- `authRepositoryProvider`, which selects the Supabase implementation;
- use-case providers for sign in, sign up, sign out, and auth-state changes;
- `authStateProvider`, a stream used by the router;
- `authControllerProvider`, which holds loading/error state for user commands.

The router watches `authStateProvider` and applies the following policy:

```text
auth restoring       → /auth/loading
signed out           → public welcome/sign-in/sign-up routes only
signed in            → /tasks
```

Screens submit forms through `AuthController`; they do not navigate after a
successful sign-in. The Supabase auth event updates `authStateProvider`, and
the router redirects to the correct destination.
