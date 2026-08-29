-- ============================================================
-- Adds "Date joined the community" (joined_at):
--   - index.html: new Step 7 of 7 on the request form asks the member
--     for the date they joined the community. Shown on the public Hall
--     of Fame page (and ID card) as "Joined the community on dd-mm-yyyy",
--     replacing the old submission-date display.
--   - admin.html: the pending/rejected request cards and the members
--     roster card show this date, and it's editable from the "Edit
--     member" modal. Accepting a request now carries joined_at over
--     from the request row into the new members row.
-- ============================================================

alter table public.requests
    add column if not exists joined_at date;

alter table public.members
    add column if not exists joined_at date;

-- Backfill existing members so they still show a real date instead of
-- blank, falling back to their original submission date. Skip this if you
-- don't mind existing members showing no "Joined the community on ..." line
-- until an admin edits them in.
update public.members
set joined_at = submitted_at::date
where joined_at is null
  and submitted_at is not null;

-- No RLS/grant changes needed — the existing insert/select/update grants
-- on public.requests and public.members are table-wide (not restricted to
-- specific columns), so joined_at is already covered.
