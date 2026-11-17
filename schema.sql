create table if not exists public.wishes (
  id bigint generated always as identity primary key,
  title text not null check (char_length(trim(title)) between 1 and 200),
  url text not null check (url ~* '^https?://'),
  position integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.wish_clicks (
  id bigint generated always as identity primary key,
  wish_id bigint not null references public.wishes(id) on delete cascade,
  device_type text not null check (device_type in ('mobile', 'tablet', 'desktop')),
  clicked_at timestamptz not null default now()
);

alter table public.wishes enable row level security;
alter table public.wish_clicks enable row level security;

grant select on public.wishes to anon, authenticated;
grant insert, update, delete on public.wishes to authenticated;
grant insert on public.wish_clicks to anon, authenticated;
grant select on public.wish_clicks to authenticated;
grant usage, select on sequence public.wishes_id_seq to anon, authenticated;
grant usage, select on sequence public.wish_clicks_id_seq to anon, authenticated;

drop policy if exists "Anyone can read active wishes" on public.wishes;
create policy "Anyone can read active wishes"
  on public.wishes for select
  to anon, authenticated
  using (is_active);

drop policy if exists "Jamie can manage wishes" on public.wishes;
create policy "Jamie can manage wishes"
  on public.wishes for all
  to authenticated
  using ((auth.jwt() ->> 'email') = 'jamie.trading.9@gmail.com')
  with check ((auth.jwt() ->> 'email') = 'jamie.trading.9@gmail.com');

drop policy if exists "Anyone can record a wish click" on public.wish_clicks;
create policy "Anyone can record a wish click"
  on public.wish_clicks for insert
  to anon, authenticated
  with check (exists (
    select 1
    from public.wishes
    where wishes.id = wish_id and wishes.is_active
  ));

drop policy if exists "Jamie can read wish clicks" on public.wish_clicks;
create policy "Jamie can read wish clicks"
  on public.wish_clicks for select
  to authenticated
  using ((auth.jwt() ->> 'email') = 'jamie.trading.9@gmail.com');

insert into public.wishes (title, url, position)
select seed.title, seed.url, seed.position
from (values
  ('ESP 32 set', 'https://amzn.eu/d/07HSrJpH', 1),
  ('LCD Display', 'https://amzn.eu/d/0hF0dTcr', 2),
  ('Breadboard', 'https://amzn.eu/d/00EpWcra', 3)
) as seed(title, url, position)
where not exists (select 1 from public.wishes);
