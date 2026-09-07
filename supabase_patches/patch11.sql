drop policy if exists "authenticated_update_members" on public.members;

create policy "authenticated_update_members"
on public.members
for update
to authenticated
using (true)
with check (true);

grant update
on public.members
to authenticated;
