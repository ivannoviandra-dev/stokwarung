-- StokWarung Supabase schema
-- Safe to run more than once from the Supabase SQL Editor.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  email text not null,
  store_name text not null,
  phone text,
  is_pro boolean not null default false,
  total_transactions integer not null default 0,
  active_customers integer not null default 0,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.stores (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  phone text,
  address text,
  logo_url text,
  open_time text not null default '07:00',
  close_time text not null default '22:00',
  is_open boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists stores_owner_id_key
on public.stores(owner_id);

alter table public.profiles enable row level security;
alter table public.stores enable row level security;

drop policy if exists "Users can read own profile" on public.profiles;
drop policy if exists "Users can create own profile" on public.profiles;
drop policy if exists "Users can update own profile" on public.profiles;
drop policy if exists "Users can read own stores" on public.stores;
drop policy if exists "Users can create own stores" on public.stores;
drop policy if exists "Users can update own stores" on public.stores;

create policy "Users can read own profile"
on public.profiles
for select
to authenticated
using (id = auth.uid());

create policy "Users can create own profile"
on public.profiles
for insert
to authenticated
with check (id = auth.uid());

create policy "Users can update own profile"
on public.profiles
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

create policy "Users can read own stores"
on public.stores
for select
to authenticated
using (owner_id = auth.uid());

create policy "Users can create own stores"
on public.stores
for insert
to authenticated
with check (owner_id = auth.uid());

create policy "Users can update own stores"
on public.stores
for update
to authenticated
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  owner_name text;
  store_name text;
  phone_number text;
begin
  owner_name := coalesce(new.raw_user_meta_data->>'name', 'Pemilik Toko');
  store_name := coalesce(new.raw_user_meta_data->>'store_name', 'Toko Saya');
  phone_number := new.raw_user_meta_data->>'phone';

  insert into public.profiles (
    id,
    name,
    email,
    store_name,
    phone
  )
  values (
    new.id,
    owner_name,
    coalesce(new.email, ''),
    store_name,
    phone_number
  )
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
  values (
    new.id,
    store_name,
    phone_number,
    true,
    '07:00',
    '22:00'
  )
  on conflict (owner_id) do update
  set
    name = excluded.name,
    phone = excluded.phone,
    updated_at = now();

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- Backfill users that were created before the trigger existed.
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
from auth.users
left join public.profiles on profiles.id = users.id
where profiles.id is null
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
from auth.users
left join public.stores on stores.owner_id = users.id
where stores.owner_id is null
on conflict (owner_id) do update
set
  name = excluded.name,
  phone = excluded.phone,
  updated_at = now();
