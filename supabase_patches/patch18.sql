drop policy if exists "anon_select_edit_requests" on public.edit_requests;

create policy "anon_select_edit_requests"
on public.edit_requests
for select
to anon
using (true);

grant select
on public.edit_requests
to anon;
