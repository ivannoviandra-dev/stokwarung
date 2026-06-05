-- Check whether auth users, profiles, stores, and the signup trigger are aligned.

select
  trigger_name,
  event_manipulation,
  event_object_schema,
  event_object_table,
  action_statement
from information_schema.triggers
where event_object_schema = 'auth'
  and event_object_table = 'users'
  and trigger_name = 'on_auth_user_created';

select
  users.id,
  users.email,
  users.raw_user_meta_data->>'name' as metadata_name,
  users.raw_user_meta_data->>'store_name' as metadata_store_name,
  profiles.id is not null as has_profile,
  stores.id is not null as has_store
from auth.users as users
left join public.profiles on profiles.id = users.id
left join public.stores on stores.owner_id = users.id
order by users.created_at desc;
