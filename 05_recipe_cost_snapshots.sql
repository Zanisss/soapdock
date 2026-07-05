-- 05_recipe_cost_snapshots.sql — run in Supabase SQL Editor. Safe to re-run.
-- SoapDock records each recipe's cost per 1000 g of oils whenever it changes
-- (checked automatically on app load). Powers "Cost over time" on the
-- Pricing Calculator tab.
create table if not exists public.recipe_cost_snapshots (
  id          uuid primary key default gen_random_uuid(),
  recipe_id   uuid not null references public.recipes(id) on delete cascade,
  taken_at    timestamptz not null default now(),
  cost_per_kg numeric not null
);
create index if not exists rcs_recipe_time on public.recipe_cost_snapshots (recipe_id, taken_at desc);
alter table public.recipe_cost_snapshots enable row level security;
drop policy if exists rcs_all on public.recipe_cost_snapshots;
create policy rcs_all on public.recipe_cost_snapshots
  for all to authenticated using (true) with check (true);
grant select, insert, update, delete on public.recipe_cost_snapshots to authenticated;
grant select, insert on public.recipe_cost_snapshots to service_role;
