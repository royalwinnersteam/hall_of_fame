alter table public.requests
    add column if not exists level_at date;

alter table public.members
    add column if not exists level_at date;

