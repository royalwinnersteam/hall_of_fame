alter table public.requests
    add column if not exists joined_at date;

alter table public.members
    add column if not exists joined_at date;

update public.members
set joined_at = submitted_at::date
where joined_at is null
  and submitted_at is not null;

