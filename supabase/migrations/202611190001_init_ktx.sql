create extension if not exists "pgcrypto";

create table if not exists public.shops (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  food_name text not null,
  shop_name text not null,
  building_id text not null,
  category text not null default 'Khác',
  icon text not null default '🍽️',
  price integer not null check (price between 1000 and 1000000),
  open_hours text not null,
  note text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.menu_photos (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  owner_id uuid not null references auth.users(id) on delete cascade,
  object_path text not null,
  public_url text not null,
  mime_type text not null check (mime_type in ('image/jpeg', 'image/png', 'image/webp')),
  size_bytes integer not null check (size_bytes > 0 and size_bytes <= 5242880),
  created_at timestamptz not null default now()
);

create index if not exists shops_owner_id_idx on public.shops(owner_id);
create index if not exists shops_building_id_idx on public.shops(building_id);
create index if not exists menu_photos_shop_id_idx on public.menu_photos(shop_id);
create unique index if not exists menu_photos_object_path_idx on public.menu_photos(object_path);

create or replace function public.enforce_menu_photo_limit()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  photo_count integer;
begin
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtext(new.shop_id::text)::bigint);

  if new.object_path !~ (
    '^' || new.owner_id::text || '/' || new.shop_id::text || '/[^/]+\.(jpg|png|webp)$'
  ) then
    raise exception 'Invalid menu photo path' using errcode = '23514';
  end if;

  select count(*) into photo_count
  from public.menu_photos
  where shop_id = new.shop_id;

  if photo_count >= 5 then
    raise exception 'A shop may have at most 5 menu photos' using errcode = '23514';
  end if;

  return new;
end;
$$;

create trigger enforce_menu_photo_limit_before_insert
  before insert on public.menu_photos
  for each row execute function public.enforce_menu_photo_limit();

alter table public.shops enable row level security;
alter table public.menu_photos enable row level security;

create policy "shops are publicly readable"
  on public.shops for select
  using (true);

create policy "authenticated users can create shops"
  on public.shops for insert
  to authenticated
  with check (owner_id = auth.uid());

create policy "owners can update their shops"
  on public.shops for update
  to authenticated
  using (owner_id = auth.uid())
  with check (owner_id = auth.uid());

create policy "owners can delete their shops"
  on public.shops for delete
  to authenticated
  using (owner_id = auth.uid());

create policy "menu photos are publicly readable"
  on public.menu_photos for select
  using (true);

create policy "owners can create menu photo metadata"
  on public.menu_photos for insert
  to authenticated
  with check (
    owner_id = auth.uid()
    and exists (
      select 1 from public.shops
      where shops.id = menu_photos.shop_id
        and shops.owner_id = auth.uid()
    )
  );

create policy "owners can delete menu photo metadata"
  on public.menu_photos for delete
  to authenticated
  using (owner_id = auth.uid());

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'ktx-menu-photos',
  'ktx-menu-photos',
  true,
  5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create policy "public can view menu photos"
  on storage.objects for select
  using (bucket_id = 'ktx-menu-photos');

create policy "owners can upload menu photos"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'ktx-menu-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
    and exists (
      select 1 from public.shops
      where shops.id::text = (storage.foldername(name))[2]
        and shops.owner_id = auth.uid()
    )
  );

create policy "owners can update menu photos"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'ktx-menu-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'ktx-menu-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
    and exists (
      select 1 from public.shops
      where shops.id::text = (storage.foldername(name))[2]
        and shops.owner_id = auth.uid()
    )
  );

create policy "owners can delete menu photos"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'ktx-menu-photos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
