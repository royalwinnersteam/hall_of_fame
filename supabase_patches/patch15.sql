-- ============================================================
-- Needed for: admin.html now has an "Edit" button on every tab
-- (Pending Requests, Rejected, Members, Edit Requests) instead of
-- just Members.
--
-- Pending/Rejected edits update public.requests, which already has an
-- authenticated update policy+grant (from main_supabase_patch1.sql) — no
-- change needed there.
--
-- Edit Requests edits update public.edit_requests, which so far only had
-- insert (anon) / select+delete (authenticated) — no update policy existed,
-- so an admin editing a proposed change there would be silently rejected
-- by RLS. This adds it.
-- ============================================================

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
