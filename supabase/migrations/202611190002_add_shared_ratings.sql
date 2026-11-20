create table if not exists public.ratings (
  spot_id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  stars smallint not null check (stars between 1 and 5),
  comment text not null default '' check (char_length(comment) <= 200),
  updated_at timestamptz not null default now(),
  primary key (spot_id, user_id)
);

create index if not exists ratings_updated_at_idx on public.ratings(updated_at desc);

alter table public.ratings enable row level security;

drop policy if exists "ratings are publicly readable" on public.ratings;
drop policy if exists "authenticated users can create their own ratings" on public.ratings;
drop policy if exists "users can update their own ratings" on public.ratings;
drop policy if exists "users can delete their own ratings" on public.ratings;

create policy "ratings are publicly readable"
  on public.ratings for select
  using (true);

create policy "authenticated users can create their own ratings"
  on public.ratings for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "users can update their own ratings"
  on public.ratings for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "users can delete their own ratings"
  on public.ratings for delete
  to authenticated
  using (user_id = auth.uid());

grant select on public.ratings to anon, authenticated;
grant insert, update, delete on public.ratings to authenticated;
