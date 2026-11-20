-- Run this once in Supabase: Dashboard > SQL Editor > New query > Run

create table if not exists public.stories (
  id bigint generated always as identity primary key,
  title text not null,
  summary text,
  author text,
  category text not null,
  lead boolean not null default false,
  published boolean not null default true,
  image_url text,
  video_url text,
  published_at timestamptz not null default now()
);

alter table public.stories enable row level security;

-- Visitors can read published stories
create policy "Public can read published stories"
  on public.stories for select
  to anon, authenticated
  using (published = true);

-- Signed-in editors can see, add, change and delete everything
create policy "Editors can read all stories"
  on public.stories for select
  to authenticated
  using (true);

create policy "Editors can add stories"
  on public.stories for insert
  to authenticated
  with check (true);

create policy "Editors can update stories"
  on public.stories for update
  to authenticated
  using (true)
  with check (true);

create policy "Editors can delete stories"
  on public.stories for delete
  to authenticated
  using (true);

-- Starter placeholder stories (delete these once you add your own)
insert into public.stories (title, summary, author, category, lead, published_at) values
  ('Leaders gather for summit on regional trade and infrastructure', 'Delegates opened talks on shared infrastructure, trade rules, and emissions targets.', 'Maria Lopez', 'politics', true, now() - interval '2 hours'),
  ('Local markets rise as quarterly earnings beat expectations', 'Analysts say steady consumer spending helped offset higher borrowing costs this quarter.', 'Priya Shah', 'business', false, now() - interval '4 hours'),
  ('Underdogs secure stunning overtime win in season opener', 'A late goal sealed the result in front of a sold-out crowd at the home stadium.', 'Marcus Bell', 'sports', false, now() - interval '7 hours'),
  ('Astronomers spot unusually bright comet visible to the naked eye', 'The comet is expected to be best viewed in the pre-dawn sky over the coming weeks.', 'Elena Rossi', 'science', false, now() - interval '6 hours'),
  ('This week on the podcast: the future of public transport', 'Our guests discuss funding, fares, and what riders really want from their commute.', 'Murfi Podcast Team', 'podcast', false, now() - interval '19 hours');
