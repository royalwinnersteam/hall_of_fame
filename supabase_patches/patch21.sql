-- patch21: site_settings table (holds the sentence added to WhatsApp/Share messages)

create table if not exists public.site_settings (
    key text primary key,
    value text not null default '',
    updated_at timestamptz not null default now()
);

alter table public.site_settings enable row level security;
revoke all on public.site_settings from anon, authenticated;

-- Everyone (the public Hall of Fame site) can read it
drop policy if exists "anon_read_site_settings" on public.site_settings;
create policy "anon_read_site_settings"
on public.site_settings
for select
to anon, authenticated
using (true);
grant select on public.site_settings to anon, authenticated;

-- Only the logged-in admin can add / change it
drop policy if exists "authenticated_insert_site_settings" on public.site_settings;
create policy "authenticated_insert_site_settings"
on public.site_settings
for insert
to authenticated
with check (true);
grant insert on public.site_settings to authenticated;

drop policy if exists "authenticated_update_site_settings" on public.site_settings;
create policy "authenticated_update_site_settings"
on public.site_settings
for update
to authenticated
using (true)
with check (true);
grant update on public.site_settings to authenticated;

-- Starting row (empty sentence)
insert into public.site_settings (key, value)
values ('share_sentence', '')
on conflict (key) do nothing;
