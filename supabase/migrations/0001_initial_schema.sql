-- Sayyad Prices: initial database schema
-- Run in Supabase SQL Editor or via Supabase migrations.

create extension if not exists pgcrypto;

create table if not exists public.tracked_products (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  product_url text not null,
  product_name text,
  store_name text,
  image_url text,
  variant_label text,
  target_price numeric(12,2) check (target_price is null or target_price >= 0),
  currency text not null default 'EGP',
  last_seen_price numeric(12,2) check (last_seen_price is null or last_seen_price >= 0),
  last_checked_at timestamptz,
  tracking_status text not null default 'pending'
    check (tracking_status in ('pending','active','paused','unsupported','error')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, product_url)
);

create table if not exists public.price_history (
  id bigint generated always as identity primary key,
  tracked_product_id uuid not null references public.tracked_products(id) on delete cascade,
  price numeric(12,2) not null check (price >= 0),
  currency text not null default 'EGP',
  checked_at timestamptz not null default now(),
  source text
);

create index if not exists price_history_product_time_idx
  on public.price_history (tracked_product_id, checked_at desc);

create table if not exists public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  plan_code text not null default 'free'
    check (plan_code in ('free','basic','pro')),
  status text not null default 'inactive'
    check (status in ('inactive','trialing','active','past_due','cancelled','expired')),
  provider text,
  provider_customer_id text,
  provider_subscription_id text,
  current_period_end timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists tracked_products_user_idx
  on public.tracked_products (user_id, created_at desc);

alter table public.tracked_products enable row level security;
alter table public.price_history enable row level security;
alter table public.subscriptions enable row level security;

drop policy if exists "Users manage their own tracked products" on public.tracked_products;
create policy "Users manage their own tracked products"
on public.tracked_products for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Users read history for their products" on public.price_history;
create policy "Users read history for their products"
on public.price_history for select
using (
  exists (
    select 1 from public.tracked_products p
    where p.id = tracked_product_id and p.user_id = auth.uid()
  )
);

drop policy if exists "Users read their own subscription" on public.subscriptions;
create policy "Users read their own subscription"
on public.subscriptions for select
using (auth.uid() = user_id);

-- Subscription writes should be performed only by a trusted server/webhook,
-- never directly by the mobile client.
