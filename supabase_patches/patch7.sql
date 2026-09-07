-- Adds a column to store the member's ORIGINAL submission date (from the
-- requests table), separate from `created_at` which is when the admin
-- accepted the request and the row landed in `members`.
alter table public.members
  add column if not exists submitted_at timestamptz;

-- Optional but recommended: backfill existing members so they show a real
-- date instead of falling back to created_at (their approval date).
-- Skip this if you don't mind existing rows showing their approval date.
update public.members
set submitted_at = created_at
where submitted_at is null;
