-- Allows signed-in admins to edit existing members (name, district, phone,
-- passport_nft/link id, level, photo_url) from admin.html.
-- Without this, the members table only had insert/select/delete policies —
-- no update — so admin edits would be silently rejected by RLS.

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
