create or replace function public.enforce_shop_insert_rules()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  owned_count integer;
  duplicate_count integer;
begin
  if new.owner_id is distinct from auth.uid() then
    raise exception 'owner_id must match the authenticated user'
      using errcode = '42501';
  end if;

  select count(*)
  into owned_count
  from public.shops
  where owner_id = new.owner_id;

  if tg_op = 'INSERT' and owned_count >= 20 then
    raise exception 'A user may have at most 20 shops'
      using errcode = '23514';
  end if;

  select count(*)
  into duplicate_count
  from public.shops
  where owner_id = new.owner_id
    and building_id = new.building_id
    and lower(btrim(food_name)) = lower(btrim(new.food_name))
    and lower(btrim(shop_name)) = lower(btrim(new.shop_name))
    and (tg_op = 'INSERT' or id is distinct from new.id);

  if duplicate_count > 0 then
    raise exception 'This shop already exists for this owner and building'
      using errcode = '23505';
  end if;

  if char_length(btrim(new.food_name)) < 2
    or char_length(btrim(new.shop_name)) < 2
    or new.price < 1000
    or new.price > 1000000
    or new.open_hours !~ '^([01][0-9]|2[0-3]):[0-5][0-9]-([01][0-9]|2[0-3]):[0-5][0-9]$'
    or char_length(new.note) > 80
  then
    raise exception 'Invalid shop data'
      using errcode = '23514';
  end if;

  return new;
end;
$$;

drop trigger if exists enforce_shop_insert_rules on public.shops;

create trigger enforce_shop_insert_rules
  before insert or update on public.shops
  for each row execute function public.enforce_shop_insert_rules();

revoke execute on function public.enforce_shop_insert_rules() from public;
grant execute on function public.enforce_shop_insert_rules() to authenticated;
