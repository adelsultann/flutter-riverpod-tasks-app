-- Initial schema for the tasks application.
-- Every task belongs to the authenticated user who creates it.

create table public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid()
    references auth.users (id) on delete cascade,
  title text not null check (btrim(title) <> ''),
  description text,
  is_completed boolean not null default false,
  created_at timestamptz not null default now()
);

-- Row Level Security makes the database enforce task ownership.
alter table public.tasks enable row level security;

create policy "Users can read their own tasks"
  on public.tasks
  for select
  to authenticated
  using (user_id = auth.uid());

create policy "Users can create their own tasks"
  on public.tasks
  for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "Users can update their own tasks"
  on public.tasks
  for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "Users can delete their own tasks"
  on public.tasks
  for delete
  to authenticated
  using (user_id = auth.uid());

-- RLS still controls each operation after these Data API privileges are granted.
grant select, insert, update, delete on table public.tasks to authenticated;
