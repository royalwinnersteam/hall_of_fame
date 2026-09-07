drop policy if exists "authenticated_update_edit_requests" on public.edit_requests;

create policy "authenticated_update_edit_requests"
on public.edit_requests
for update
to authenticated
using (true)
with check (true);

grant update
on public.edit_requests
to authenticated;
