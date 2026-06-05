-- Development only: manually confirm an existing auth user by email.
-- Replace the email below before running this in Supabase SQL Editor.

update auth.users
set
  email_confirmed_at = coalesce(email_confirmed_at, now()),
  confirmed_at = coalesce(confirmed_at, now()),
  updated_at = now()
where email = 'cuancuan@gmail.com';

select
  id,
  email,
  email_confirmed_at,
  confirmed_at
from auth.users
where email = 'cuancuan@gmail.com';
