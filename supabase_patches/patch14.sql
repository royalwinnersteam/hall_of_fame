alter table public.edit_requests
    add column if not exists old_joined_at date;

alter table public.edit_requests
    add column if not exists new_joined_at date;

