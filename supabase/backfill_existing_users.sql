-- Run this after registration if auth users exist but public.profiles/stores are empty.

select
  id,
  email,
  raw_user_meta_data
from auth.users
order by created_at desc;

insert into public.profiles (
  id,
  name,
  email,
  store_name,
  phone
)
select
  users.id,
  coalesce(users.raw_user_meta_data->>'name', 'Pemilik Toko'),
  coalesce(users.email, ''),
  coalesce(users.raw_user_meta_data->>'store_name', 'Toko Saya'),
  users.raw_user_meta_data->>'phone'
from auth.users as users
on conflict (id) do update
set
  name = excluded.name,
  email = excluded.email,
  store_name = excluded.store_name,
  phone = excluded.phone,
  updated_at = now();

insert into public.stores (
  owner_id,
  name,
  phone,
  is_open,
  open_time,
  close_time
)
select
  users.id,
  coalesce(users.raw_user_meta_data->>'store_name', 'Toko Saya'),
  users.raw_user_meta_data->>'phone',
  true,
  '07:00',
  '22:00'
from auth.users as users
on conflict (owner_id) do update
set
  name = excluded.name,
  phone = excluded.phone,
  updated_at = now();

select * from public.profiles;
select * from public.stores;
