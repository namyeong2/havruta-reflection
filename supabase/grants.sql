-- Run this once if the initial schema was executed before the explicit
-- Data API grants were added. It gives the app only the required operations;
-- Row Level Security policies still decide which rows are accessible.

grant usage on schema public to anon, authenticated;
grant insert on table public.reflections to anon, authenticated;
grant select, delete on table public.reflections to authenticated;
