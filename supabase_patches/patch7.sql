alter table public.members
  add column if not exists submitted_at timestamptz;

update public.members
set submitted_at = created_at
where submitted_at is null;
