-- Run this in the Supabase SQL Editor before connecting the app.
-- Student identifiers are pseudonymous in this app, but should still be
-- handled as student data under your school's retention policy.

create table if not exists public.reflections (
  id uuid primary key default gen_random_uuid(),
  student_id text not null check (char_length(student_id) between 1 and 10),
  created_at timestamptz not null default now(),
  participation_score smallint not null check (participation_score between 1 and 5),
  listening_score smallint not null check (listening_score between 1 and 5),
  thought_change text not null check (char_length(thought_change) between 1 and 300),
  memorable_peer_idea text not null check (char_length(memorable_peer_idea) between 1 and 300),
  my_final_thought text not null check (char_length(my_final_thought) between 1 and 300),
  next_goals text[] not null check (cardinality(next_goals) >= 1),
  next_goal_other text not null default '' check (char_length(next_goal_other) <= 300)
);

alter table public.reflections enable row level security;

-- The project does not automatically grant Data API access to new tables.
-- Grant only the operations this app needs; RLS policies below remain the
-- final gate for each row.
grant usage on schema public to anon, authenticated;
grant insert on table public.reflections to anon, authenticated;
grant select, delete on table public.reflections to authenticated;

-- Students do not need an account: they may submit a reflection, but cannot
-- read any stored records (including their own after the confirmation screen).
create policy "Anyone can submit a reflection"
on public.reflections
for insert
to anon, authenticated
with check (true);

-- Teachers sign in with Supabase Auth. Give each teacher account the
-- app_metadata role {"role":"teacher"}; only these accounts can read/delete.
create or replace function public.is_teacher()
returns boolean
language sql
stable
as $$
  select coalesce(auth.jwt() -> 'app_metadata' ->> 'role', '') = 'teacher';
$$;

create policy "Teachers can read reflections"
on public.reflections
for select
to authenticated
using (public.is_teacher());

create policy "Teachers can delete reflections"
on public.reflections
for delete
to authenticated
using (public.is_teacher());

create index if not exists reflections_created_at_idx
on public.reflections (created_at desc);
