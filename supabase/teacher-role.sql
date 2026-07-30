-- 1. In Supabase Dashboard > Authentication > Users, create a teacher user
--    with email/password first.
-- 2. Replace the email below and run this query in SQL Editor.
-- 3. Sign out and back in to refresh the teacher's JWT claim.

update auth.users
set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"teacher"}'::jsonb
where email = 'teacher@example.com';

