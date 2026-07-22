create table if not exists public.sori_trips (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.sori_trips enable row level security;

drop policy if exists "sori trips public select" on public.sori_trips;
drop policy if exists "sori trips public insert" on public.sori_trips;
drop policy if exists "sori trips public update" on public.sori_trips;

create policy "sori trips public select"
on public.sori_trips for select
using (true);

create policy "sori trips public insert"
on public.sori_trips for insert
with check (true);

create policy "sori trips public update"
on public.sori_trips for update
using (true)
with check (true);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'sori-trip-photos',
  'sori-trip-photos',
  true,
  5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update
set public = true,
    file_size_limit = 5242880,
    allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp'];

drop policy if exists "sori trip photos public select" on storage.objects;
drop policy if exists "sori trip photos public insert" on storage.objects;
drop policy if exists "sori trip photos public update" on storage.objects;
drop policy if exists "sori trip photos public delete" on storage.objects;

create policy "sori trip photos public select"
on storage.objects for select
using (bucket_id = 'sori-trip-photos');

create policy "sori trip photos public insert"
on storage.objects for insert
with check (bucket_id = 'sori-trip-photos');

create policy "sori trip photos public update"
on storage.objects for update
using (bucket_id = 'sori-trip-photos')
with check (bucket_id = 'sori-trip-photos');

create policy "sori trip photos public delete"
on storage.objects for delete
using (bucket_id = 'sori-trip-photos');
