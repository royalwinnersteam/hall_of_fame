drop policy if exists "anon_insert_edit_requests" on public.edit_requests;

create policy "anon_insert_edit_requests"
on public.edit_requests
for insert
to anon, authenticated
with check (true);

grant insert
on public.edit_requests
to authenticated;

grant insert
on public.edit_requests
to anon;
