-- ASH Quiz progress tracking (Supabase)
-- Run in Supabase SQL Editor.

create table if not exists public.ash_user_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  stats jsonb not null default '{}'::jsonb,
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.ash_user_progress enable row level security;

-- Users can read their own progress
drop policy if exists "read own progress" on public.ash_user_progress;
create policy "read own progress"
on public.ash_user_progress
for select
to authenticated
using (auth.uid() = user_id);

-- Users can insert their own progress
drop policy if exists "insert own progress" on public.ash_user_progress;
create policy "insert own progress"
on public.ash_user_progress
for insert
to authenticated
with check (auth.uid() = user_id);

-- Users can update their own progress
drop policy if exists "update own progress" on public.ash_user_progress;
create policy "update own progress"
on public.ash_user_progress
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- Optional: keep updated_at fresh on update
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists ash_user_progress_set_updated_at on public.ash_user_progress;
create trigger ash_user_progress_set_updated_at
before update on public.ash_user_progress
for each row
execute procedure public.set_updated_at();

