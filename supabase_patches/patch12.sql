create table public.edit_requests (
    id uuid primary key default gen_random_uuid(),
    member_id uuid not null references public.members(id) on delete cascade,
    board text not null
        check (board in ('vboost','ts','vboost_direct','ts_direct')),

    old_name text,
    new_name text not null,

    old_district text,
    new_district text,

    old_phone text,
    new_phone text not null,

    old_passport_nft text,
    new_passport_nft text not null,

    old_photo_url text,
    new_photo_url text,

    created_at timestamptz not null default now(),

    constraint edit_requests_passport_check
        check (
            (board in ('vboost','vboost_direct') and new_passport_nft ~ '^[0-9]{5}$')
            or
            (board in ('ts','ts_direct') and new_passport_nft ~ '^[A-Za-z0-9]{10}$')
        )
);

create index edit_requests_board_idx on public.edit_requests(board);
create index edit_requests_member_id_idx on public.edit_requests(member_id);

alter table public.edit_requests enable row level security;

revoke all on public.edit_requests from anon, authenticated;

create policy "anon_insert_edit_requests"
on public.edit_requests
for insert
to anon
with check (true);

grant insert on public.edit_requests to anon;

create policy "authenticated_read_edit_requests"
on public.edit_requests
for select
to authenticated
using (true);

grant select on public.edit_requests to authenticated;

create policy "authenticated_delete_edit_requests"
on public.edit_requests
for delete
to authenticated
using (true);

grant delete on public.edit_requests to authenticated;

alter publication supabase_realtime
add table public.edit_requests;
