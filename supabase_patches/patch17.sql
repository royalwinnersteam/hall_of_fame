alter table public.edit_requests
    add column if not exists old_level_at date;

alter table public.edit_requests
    add column if not exists new_level_at date;

