create table if not exists public.workout_dashboard (
    user_id uuid primary key references auth.users (id) on delete cascade,
    state jsonb not null,
    updated_at timestamptz not null default now()
);

alter table public.workout_dashboard enable row level security;

revoke all on table public.workout_dashboard from anon;
grant select, insert, update on table public.workout_dashboard to authenticated;

drop policy if exists "Users can read their own workout data" on public.workout_dashboard;
drop policy if exists "Users can insert their own workout data" on public.workout_dashboard;
drop policy if exists "Users can update their own workout data" on public.workout_dashboard;

create policy "Users can read their own workout data"
    on public.workout_dashboard
    for select
    to authenticated
    using ((select auth.uid()) = user_id);

create policy "Users can insert their own workout data"
    on public.workout_dashboard
    for insert
    to authenticated
    with check ((select auth.uid()) = user_id);

create policy "Users can update their own workout data"
    on public.workout_dashboard
    for update
    to authenticated
    using ((select auth.uid()) = user_id)
    with check ((select auth.uid()) = user_id);
