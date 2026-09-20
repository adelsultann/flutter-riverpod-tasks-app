# Streak Feature — Product and Engineering Design

## 1. Document status

| Field | Value |
| --- | --- |
| Status | Proposed for implementation |
| Application | Tasks App |
| Owners | Product and engineering |
| Last updated | 2026-09-20 |
| Primary screen | Main task screen |

This document defines the streak feature before implementation. It records the
product rules, domain language, database responsibilities, concurrency model,
application contracts, delivery plan, and verification strategy.

The database is authoritative for task history and stored streak values. The
Flutter application presents the result and may derive time-dependent display
status from authoritative data, but it must not decide what streak value is
persisted.

---

## 2. Problem and expected value

Users may complete tasks without receiving a visible sense of continued
progress. The streak feature gives them a simple reason to return regularly by
showing how many qualifying days they have maintained.

### Product hypothesis

Showing a visible streak will encourage users to open the app and complete a
task regularly. The original target is a 20% improvement in active-user
engagement. This is a hypothesis, not an established result, and must be
validated with analytics after release.

### User story

> As a user, I want to see the progress I have maintained by completing tasks
> so that I feel a sense of achievement and continue using the app.

### Success measures

The feature should eventually be evaluated using defined metrics such as:

- Percentage of users who earn a first streak day.
- Percentage of users who return during the recovery window.
- Change in daily and weekly active users after release.
- Streak continuation rate at 2, 7, and 30 qualifying days.
- Task completion rate before and after the feature is introduced.

Analytics instrumentation is a separate delivery item unless it is added to
the implementation scope explicitly.

---

## 3. Scope

### Included

- Award at most one streak day per user calendar date.
- Display the current streak on the main task screen.
- Display whether the streak is active, at risk, or absent.
- Allow a two-calendar-day recovery window after the last qualifying date.
- Make only the first-ever completion of a task eligible to qualify a day.
- Preserve earned streak progress when a task is unchecked or deleted.
- Use each user's configured time zone to determine calendar dates.
- Apply task and streak changes atomically in PostgreSQL.
- Return the updated task and streak snapshot in one completion request.

### Excluded from the first version

- Longest-ever streak.
- A calendar or history of all qualifying days.
- Streak restoration by support staff.
- Freeze tokens, vacation mode, or purchased streak protection.
- Undoing an earned streak because a task was unchecked or deleted.
- Leaderboards, social sharing, badges, or notifications.
- Multiple streak types or per-project streaks.
- Offline conflict resolution beyond retrying against the authoritative server.

---

## 4. Domain language

Consistent terms prevent business rules from becoming ambiguous.

| Term | Definition |
| --- | --- |
| First completion | The first transition of a task to completed during that task's lifetime. |
| Previously completed task | A task whose first completion has already occurred, even if it is currently unchecked. |
| Qualifying completion | A task's first completion that occurs on a user calendar date that has not already qualified. |
| Qualifying date | A full local calendar date, including year, month, and day, on which the user earns one streak day. |
| Current streak | The number of qualifying days preserved by the current streak chain. It resets to 1 on a new qualifying completion after expiry. |
| Recovery window | The two calendar dates after the last qualifying date during which a new qualifying completion preserves the streak. |
| Streak snapshot | The current streak count, last qualifying date, and calculated status returned together. |
| User time zone | An IANA time-zone identifier such as `Asia/Riyadh` used to determine the user's calendar date. |

Use **qualifying**, not **quantifying**, throughout code and documentation.

---

## 5. Confirmed business rules

### 5.1 One point per qualifying date

Completing one, two, or five tasks on the same user calendar date adds at most
one point to the current streak.

### 5.2 A task has only one opportunity to qualify

Only a task's first-ever completion is eligible. Once a task has been completed:

- Unchecking it changes its current UI state but does not restore eligibility.
- Rechecking it on a later date does not affect the streak.
- Its historical completion state never returns to false.

A first completion is consumed even if another task already qualified that
calendar date. For example, if Task A qualifies Monday and Task B is first
completed later Monday, Task B cannot be rechecked Tuesday to earn Tuesday.

### 5.3 Unchecking and deletion do not reverse progress

Once a date has qualified, later unchecking or deleting its task does not
decrease the streak and does not remove the qualifying date. Deleting a task
removes the task and its task-level historical flag, but the aggregate streak
remains.

### 5.4 Recovery rule

Let `dayDifference` be the difference in full user calendar dates between the
new completion date and the last qualifying date.

| `dayDifference` | Meaning | Stored streak result for an eligible first completion |
| ---: | --- | --- |
| No previous date | First qualifying date | Start at 1 |
| 0 | The date already qualified | Leave count unchanged |
| 1 | Next calendar date | Increment by 1 |
| 2 | Recovery date after one fully missed date | Increment by 1 |
| 3 or more | Two or more consecutive dates were missed | Restart at 1 |

Date comparison must use full calendar dates. It must not use day-of-month
values or elapsed-hour calculations.

### 5.5 Display status

Status is calculated rather than persisted because it changes with time even
when no database write occurs.

| Difference between today and last qualifying date | Effective count | Status |
| ---: | ---: | --- |
| No last qualifying date | 0 | `noStreak` |
| 0 | Stored count | `active` |
| 1 | Stored count | `atRisk` |
| 2 | Stored count | `atRisk` |
| 3 or more | 0 | `noStreak` |

Example with a stored count of 4 after Monday:

| Event | Displayed count | Status |
| --- | ---: | --- |
| Task completed Monday | 4 | Active |
| App opened Tuesday before a completion | 4 | At risk |
| App opened Wednesday before a completion | 4 | At risk |
| Eligible task completed late Wednesday | 5 | Active |
| App opened Thursday after no Tuesday or Wednesday completion | 0 | No streak |

An expired stored count may remain in the database until the next authoritative
operation normalizes it. Read behavior must always return the effective count
and status defined above, so an expired value is never shown as current.

---

## 6. Time and time-zone policy

### 6.1 Exact instants and calendar dates are different concepts

PostgreSQL `timestamptz` represents an exact instant. A PostgreSQL `date`
represents a calendar date. ISO 8601 is the transfer representation used by
clients; timestamps must not be stored as plain text.

The database obtains the authoritative current instant. It converts that
instant into the user's calendar date using the user's configured IANA time
zone. The resulting complete date is used for streak comparison.

For example, Sunday 12:30 AM in Riyadh is Saturday 9:30 PM UTC. Extracting the
UTC date would incorrectly assign that completion to Saturday. Conversion to
`Asia/Riyadh` must occur before deriving the qualifying date.

### 6.2 User time-zone storage

Each user must have an authoritative IANA time-zone identifier available to the
database. A numeric UTC offset is insufficient because many regions change
offset during the year.

The time zone belongs to user settings rather than to an individual task. The
implementation may introduce a small user-preferences record or use an existing
profile record if one is added before this feature.

### 6.3 Travel policy — decision required before implementation

The current product discussion establishes that every user has a time zone but
does not establish how changing it affects an existing streak.

Recommended first-version policy:

- A qualifying date already earned never moves when the user changes time zone.
- Future completions use the newly configured time zone.
- A time-zone change cannot award a second point for the same effective date.
- Server-side validation and rate limiting may be added if time-zone switching
  becomes a source of abuse.

Product must approve or replace this policy before database logic is finalized.

---

## 7. State transitions

The current completion state and historical completion state serve different
purposes.

| User action | Final `isCompleted` | Final historical state | Streak eligibility |
| --- | ---: | ---: | --- |
| Create task | false | false | Eligible later |
| Complete for the first time | true | true | Evaluate qualifying date |
| Uncheck after completion | false | true | No effect |
| Recheck after completion | true | true | No effect |

Detailed decision table:

| Requested completion | Previously completed | Date already qualified | Task result | Streak result |
| ---: | ---: | ---: | --- | --- |
| false | Either | Either | Set unchecked; preserve history | No change |
| true | true | Either | Set checked; preserve history | No change |
| true | false | true | Set checked and consume first completion | No change |
| true | false | false | Set checked and consume first completion | Start, increment, or restart according to date difference |

The historical state is monotonic: it may change from false to true and must
never change from true to false.

---

## 8. Proposed persistence model

Names are proposed and should be finalized in the migration review.

### 8.1 Changes to `tasks`

Add a non-null Boolean field representing whether the task has ever been
completed.

| Field | Type | Rules |
| --- | --- | --- |
| `has_ever_been_completed` | `boolean` | Not null, defaults to false, never changes back to false |

The field records task history, not whether that task increased the streak. A
task first completed on an already-qualified date still changes this field to
true.

The client must not be allowed to reset this protected field through an
ordinary task update.

### 8.2 New per-user streak record

| Field | Type | Rules |
| --- | --- | --- |
| `user_id` | `uuid` | Primary key; references the authenticated user; cascades on user deletion |
| `current_streak` | integer | Not null, default 0, never negative |
| `last_qualifying_date` | `date` | Nullable until the first qualifying completion |
| `created_at` | `timestamptz` | Database-generated audit timestamp |
| `updated_at` | `timestamptz` | Updated by authoritative database logic |

There must be at most one streak record per user. The status enum is not stored.
The last task ID is not stored because it cannot prove whether every older task
has already been completed. Eligibility is kept on each task.

### 8.3 User time-zone setting

| Field | Type | Rules |
| --- | --- | --- |
| `user_id` | `uuid` | One setting per authenticated user |
| `time_zone` | `text` | Valid IANA identifier; required before an eligible completion is processed |

The migration design must decide whether this setting lives in a dedicated
user-preferences table or an established profile table. It should not be copied
onto every task.

### 8.4 Existing data migration

- Existing completed tasks must be backfilled as previously completed so that
  unchecking and rechecking them cannot generate new streak days.
- Existing incomplete tasks remain eligible unless product decides otherwise.
- Existing users begin without a streak record; the record can be created on
  first read or first eligible completion.
- Existing users need a time-zone onboarding or default-selection strategy.
  A device-reported IANA identifier may initialize the preference, but the
  database stores the selected value.

---

## 9. Authoritative completion operation

### 9.1 One request and one transaction

Flutter sends one command containing the task ID and requested completion
value. A PostgreSQL function exposed through Supabase RPC, or an equivalent
trusted backend command, performs all checks and writes in one transaction.

The client must not coordinate separate task and streak writes. If either write
fails, the transaction rolls back both.

### 9.2 Transaction responsibilities

The authoritative operation must:

1. Identify the authenticated user from the database session.
2. Load and protect the user's task from concurrent completion operations.
3. Verify that the task belongs to the authenticated user.
4. Change the requested current completion state.
5. Detect whether this is the task's first completion.
6. Permanently consume first-completion eligibility when applicable.
7. Load and protect the user's single streak record.
8. Obtain the authoritative database time and user's configured time zone.
9. Derive the complete local calendar date.
10. Apply the one-point-per-date and recovery rules.
11. Commit the task and streak changes together.
12. Return the updated task and resulting streak snapshot from that transaction.

### 9.3 Concurrency requirements

Atomicity prevents partial writes but does not by itself prevent concurrent
transactions from reading the same old state. The operation must combine a
transaction with database concurrency control.

The implementation must protect:

- The task row, so two devices cannot both claim its first completion.
- The user's streak row, so two different tasks completed simultaneously cannot
  both qualify the same date.

Suitable PostgreSQL mechanisms include row locking, conditional updates,
uniqueness constraints, and an appropriate transaction strategy. The final SQL
design should document which mechanism enforces each invariant.

### 9.4 Idempotency and retries

Mobile requests may be retried after a timeout even when the first attempt
succeeded. Repeating a request to complete the same task must not award another
streak day. The historical task state and protected streak row provide the core
idempotent behavior.

An explicit request ID is not required for the first version unless later side
effects, such as analytics events or notifications, require exactly-once
processing.

---

## 10. Application contracts

### 10.1 Command input

The completion command accepts intent, not calculated historical state:

| Input | Meaning |
| --- | --- |
| `taskId` | Task whose current completion state should change |
| `isCompleted` | Requested current completion state |

The client does not send `hasEverBeenCompleted`, a streak count, a qualifying
date, or a calculated status as authoritative values.

### 10.2 Completion result

`SetTaskCompletionResult` represents final facts produced by the committed
operation. It should contain:

- The updated task or the task fields required to replace it in local state.
- The resulting streak snapshot.
- An optional `streakChanged` value if the presentation needs to distinguish a
  newly earned point from an unchanged snapshot without comparing old state.

The streak snapshot contains at least:

- Effective current streak count.
- Last qualifying date, if one exists.
- Calculated status at the time of the response, or enough authoritative data
  for the application to calculate it.

The result must not return the full task list. The application can replace the
changed task and streak state locally without an immediate refetch.

### 10.3 Read behavior

On initial screen load, tasks and the streak snapshot are read from their
repositories. Independent reads may run in parallel. A combined screen-specific
database endpoint should only be introduced if measurement shows that the
extra round trip materially affects the user experience.

On app resume or a local calendar-date change, the UI must recalculate or
refresh the time-dependent status so that a screen left open overnight does not
show stale information. This read behavior never writes a streak value.

---

## 11. Layer-by-layer implementation breakdown

The project keeps the dependency direction:

```text
Presentation -> Application -> Domain <- Data
```

### 11.1 Domain layer

Define concepts without Flutter, Supabase, JSON, or SQL dependencies:

- `Streak` or `StreakSnapshot` entity.
- `StreakStatus` with `active`, `atRisk`, and `noStreak` values.
- Updated `AppTask` historical completion state if it is needed by domain logic.
- `SetTaskCompletionResult`.
- Repository contracts for reading the streak and performing the authoritative
  completion command.
- A pure status calculation based on today, last qualifying date, and count if
  status is derived in Dart for presentation.

The existing `SetTaskCompletionUseCase` remains the user-intent entry point but
returns the new result contract rather than only an updated task.

### 11.2 Data layer

- Add serialization models for the streak snapshot and completion result.
- Add a remote data-source call for the transactional database operation.
- Map database field names to domain names.
- Keep database and Supabase exceptions out of the presentation layer.
- Add a read operation for the current streak snapshot.

### 11.3 Application layer

- Add a streak provider for screen state.
- Update `TaskController.setTaskCompletion` to consume the transaction result.
- Replace the affected task in task state or invalidate only when recovery is
  required.
- Update the streak provider from the same result.
- Preserve one loading/error boundary for the completion operation.
- Refresh or recalculate status when the app resumes on another date.

### 11.4 Presentation layer

- Replace the existing fire placeholder with the streak count and visual state.
- Use an active treatment after a qualifying completion.
- Use a grey treatment while the streak is at risk.
- Show the zero/no-streak state clearly without implying lost historical data.
- Keep task checkbox behavior responsive while preventing duplicate submission
  for the same task during an in-flight request.
- Provide an accessible text label; color alone must not communicate status.

### 11.5 Database layer

- Add schema fields and constraints through a new migration.
- Add or extend RLS policies for the per-user streak and time-zone records.
- Prevent ordinary clients from directly mutating protected historical and
  aggregate fields.
- Implement the transactional completion function.
- Ensure the function uses the authenticated user rather than accepting an
  arbitrary user ID.
- Return only rows owned by the authenticated user.

---

## 12. Security and data integrity

- RLS must isolate every task, streak, and user-setting record by authenticated
  user ID.
- The client must never submit an authoritative streak count.
- The client must never reset the historical completion field.
- The database function must derive user identity from the authenticated
  session.
- Direct table permissions must not provide a path around protected-field
  rules. RLS controls row access but does not by itself make a column immutable.
- Streak count must have a non-negative constraint.
- The per-user streak key must prevent duplicate streak rows.
- A missing or invalid time zone must produce a defined error rather than
  silently falling back to the database server's time zone.

---

## 13. Failure and recovery behavior

| Situation | Required behavior |
| --- | --- |
| Task does not exist | Return a domain-appropriate not-found result; change nothing |
| Task belongs to another user | RLS or authorization rejects access; change nothing |
| Time zone is missing or invalid | Return a clear configuration error; change nothing |
| Task write fails | Roll back streak changes |
| Streak write fails | Roll back task changes |
| Network fails before the request reaches the server | Keep prior UI state and allow retry |
| Network fails after commit but before response | Retry safely; do not award twice |
| Two devices complete the same task | One first completion at most |
| Two devices complete different tasks on the same date | One streak point at most |

After an uncertain network result, the application may refetch the task and
streak snapshot to reconcile with the database.

---

## 14. Verification strategy

### 14.1 Domain tests

Test the status and date transition rules as deterministic functions:

- No previous qualifying date.
- Same-date completion.
- Next-date completion.
- Completion two calendar dates later.
- Completion three or more calendar dates later.
- Month and year boundaries.
- Leap day.
- Active, at-risk, and no-streak calculations.

### 14.2 Database integration tests

- First completion creates or updates the streak correctly.
- Another new task on the same date does not increment.
- A task first completed on an already-qualified date is permanently consumed.
- Unchecking and rechecking never affects the streak.
- Deleting a task does not reduce the streak.
- Expired streak restarts at 1 on the next eligible first completion.
- Task and streak changes roll back together on failure.
- Simultaneous completion of the same task awards at most once.
- Simultaneous completion of different tasks awards one date at most.
- Users cannot read or mutate another user's streak.
- Direct requests cannot reset protected task history.

### 14.3 Time-zone tests

- A completion shortly after local midnight uses the new local date even when
  UTC is still on the previous date.
- Two timestamps with different UTC dates but the same user date qualify once.
- Date comparison works through daylight-saving transitions for affected zones.
- The approved travel policy is preserved after a time-zone change.

### 14.4 Application and widget tests

- The completion result updates the checkbox and streak together.
- Active, at-risk, and no-streak states render correctly.
- The at-risk state remains understandable without color.
- An operation error does not display optimistic state as committed.
- Retrying after an uncertain response reconciles with server state.
- Resuming the app on a later calendar date refreshes status.

---

## 15. Acceptance criteria

The first version is complete when all of the following are true:

1. A user's first eligible task completion starts a streak at 1.
2. Additional task completions on the same user date do not increment it.
3. A task can never qualify more than once, even after being unchecked.
4. A completion one or two calendar dates after the last qualifying date
   increments the streak.
5. A completion three or more calendar dates later restarts it at 1.
6. After expiry, the task screen displays 0 and no-streak status.
7. Unchecking or deleting tasks never reverses an earned streak.
8. The user's configured IANA time zone determines qualifying dates.
9. Concurrent completion requests cannot award duplicate points.
10. Task history and streak state commit or roll back together.
11. One completion request returns the updated task and streak snapshot.
12. The main task screen shows the count and an accessible status treatment.
13. RLS and protected-field rules prevent cross-user access and client-side
    manipulation of authoritative streak data.

---

## 16. Delivery plan

Implement and review the feature in small, verifiable stages.

### Phase 1 — Finalize decisions

- Approve the travel and time-zone-change policy.
- Finalize database and domain names.
- Confirm the migration behavior for existing users and tasks.
- Confirm the UI copy and visual treatment for each status.

### Phase 2 — Database foundation

- Add the task historical field.
- Add the user streak record and constraints.
- Add user time-zone storage.
- Backfill existing task history.
- Add RLS and protected-field controls.

### Phase 3 — Transactional command

- Implement the single completion operation.
- Add locking or equivalent concurrency enforcement.
- Return the completion result contract.
- Verify rollback, retry, and concurrent-request behavior.

### Phase 4 — Flutter domain and data layers

- Add streak domain types and status rules.
- Update the completion result and repository contracts.
- Add Supabase mappings and data-source operations.
- Add focused domain tests.

### Phase 5 — Application state

- Add streak providers.
- Update the task controller to apply the combined result.
- Add reconciliation behavior for uncertain failures.
- Refresh status when the relevant calendar date changes.

### Phase 6 — Presentation

- Replace the fire placeholder with the final streak component.
- Implement active, at-risk, and no-streak states.
- Add loading, failure, and accessibility behavior.
- Add focused widget tests.

### Phase 7 — Release validation

- Reset and migrate the local Supabase database.
- Run automated domain, database, and widget checks.
- Test two concurrent clients manually or through integration tests.
- Verify midnight behavior with controlled timestamps and multiple zones.
- Confirm analytics requirements before production release.

---

## 17. Risks and mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Client performs separate task and streak writes | Inconsistent state | One trusted transactional command |
| Two requests qualify the same date | Inflated streak | Protect the per-user streak row and enforce one transaction |
| UTC date used as the user date | Incorrect behavior near midnight | Convert database time with the stored IANA time zone before deriving the date |
| Historical field is reset | A task earns repeatedly | Protect the field and enforce a monotonic transition |
| Status is persisted | Status becomes stale without writes | Calculate status from date and count |
| Screen refetches after every toggle | Extra latency and requests | Return the updated task and streak snapshot from the command |
| Time-zone changes are undefined | Inconsistent travel behavior | Approve and test an explicit policy before implementation |
| Existing completed tasks remain eligible | Artificial streak awards after rollout | Backfill them as previously completed |

---

## 18. Decisions summary

### Approved

- One point maximum per user calendar date.
- Multiple completed tasks on a date still produce one streak point.
- Two-date recovery window after the last qualifying date.
- Status values are active, at risk, and no streak.
- Status is calculated from the last qualifying date.
- Every user has an individual time zone.
- Only a task's first-ever completion is eligible.
- First completion is consumed even when its date already qualified.
- Unchecking and deletion do not undo earned streak progress.
- Database logic is authoritative and transactional.
- Completion returns an updated task and streak snapshot in one request.

### Pending approval

- Exact behavior when the user changes time zone or travels.
- Location and onboarding flow for the user time-zone setting.
- Final UI copy and visual design.
- Whether the result includes an explicit `streakChanged` field.
- Analytics scope for the first release.

