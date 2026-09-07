-- ============================================================
-- Hall of Fame Board
-- Fresh Supabase SQL
-- Part 1 - Extensions, Tables & Constraints
-- ============================================================
create extension if not exists pgcrypto;
-- ============================================================
-- REQUESTS TABLE
-- ============================================================
create table public.requests (
    id uuid primary key default gen_random_uuid(),
    board text not null
        check (board in ('vboost','ts')),
    level integer not null,
    name text not null,
    district text not null,
    phone text not null,
    passport_nft text not null,
    photo_url text not null,
    proof_photo_url text not null,
    status text not null default 'pending'
        check (status in ('pending','rejected')),
    is_upgrade boolean not null default false,
    upgrade_from_level integer,
    created_at timestamptz not null default now(),
    constraint requests_level_check
        check (
            (board='vboost' and level between 1 and 10)
            or
            (board='ts' and level between 1 and 12)
        ),
    constraint requests_passport_check
        check (
            (
                board='vboost'
                and passport_nft ~ '^[0-9]{5}$'
            )
            or
            (
                board='ts'
                and passport_nft ~ '^[A-Za-z0-9]{10}$'
            )
        )
);
-- ============================================================
-- MEMBERS TABLE
-- ============================================================
create table public.members (
    id uuid primary key default gen_random_uuid(),
    board text not null
        check (board in ('vboost','ts')),
    level integer not null,
    name text not null,
    district text,
    phone text not null,
    passport_nft text unique,
    photo_url text not null,
    created_at timestamptz not null default now(),
    constraint members_level_check
        check (
            (board='vboost' and level between 1 and 10)
            or
            (board='ts' and level between 1 and 12)
        ),
    constraint members_passport_check
        check (
            passport_nft is null
            or
            (
                board='vboost'
                and passport_nft ~ '^[0-9]{5}$'
            )
            or
            (
                board='ts'
                and passport_nft ~ '^[A-Za-z0-9]{10}$'
            )
        )
);
-- ============================================================
-- INDEXES
-- ============================================================
create index requests_board_level_idx
on public.requests(board, level);

create index members_board_level_idx
on public.members(board, level);
-- ============================================================
-- PART 2
-- Row Level Security & Permissions
-- ============================================================
-- Enable RLS
alter table public.requests enable row level security;
alter table public.members enable row level security;
-- ============================================================
-- GRANTS
-- ============================================================
revoke all on public.requests from anon, authenticated;
revoke all on public.members from anon, authenticated;
-- ============================================================
-- REQUESTS TABLE POLICIES
-- ============================================================
create policy "anon_insert_requests"
on public.requests
for insert
to anon
with check (true);

grant insert on public.requests to anon;
--------------------------------------------------------------
create policy "anon_check_pending"
on public.requests
for select
to anon
using (true);

grant select (board, level, passport_nft)
on public.requests
to anon;
--------------------------------------------------------------
create policy "authenticated_read_requests"
on public.requests
for select
to authenticated
using (true);

grant select
on public.requests
to authenticated;
--------------------------------------------------------------
create policy "authenticated_update_requests"
on public.requests
for update
to authenticated
using (true)
with check (true);

grant update
on public.requests
to authenticated;
--------------------------------------------------------------
create policy "authenticated_delete_requests"
on public.requests
for delete
to authenticated
using (true);

grant delete
on public.requests
to authenticated;
-- ============================================================
-- MEMBERS TABLE POLICIES
-- ============================================================
create policy "anon_read_members"
on public.members
for select
to anon
using (true);

grant select
on public.members
to anon;
--------------------------------------------------------------
create policy "authenticated_read_members"
on public.members
for select
to authenticated
using (true);

grant select
on public.members
to authenticated;
--------------------------------------------------------------
create policy "authenticated_insert_members"
on public.members
for insert
to authenticated
with check (true);

grant insert
on public.members
to authenticated;
--------------------------------------------------------------
create policy "authenticated_delete_members"
on public.members
for delete
to authenticated
using (true);

grant delete
on public.members
to authenticated;
-- ============================================================
-- PART 3
-- Realtime + Storage
-- ============================================================
-- ============================================================
-- REALTIME
-- ============================================================
alter publication supabase_realtime
add table public.requests;

alter publication supabase_realtime
add table public.members;
-- ============================================================
-- STORAGE BUCKET
-- ============================================================
insert into storage.buckets
(id, name, public)
values
(
    'member-photos',
    'member-photos',
    true
);
-- ============================================================
-- STORAGE POLICIES
-- ============================================================
create policy "anon_upload_member_photos"
on storage.objects
for insert
to anon
with check (
    bucket_id = 'member-photos'
);
---------------------------------------------------------------
create policy "public_view_member_photos"
on storage.objects
for select
using (
    bucket_id = 'member-photos'
);
---------------------------------------------------------------
create policy "authenticated_delete_member_photos"
on storage.objects
for delete
to authenticated
using (
    bucket_id = 'member-photos'
);
-- ============================================================
-- END OF FRESH INSTALL
-- ============================================================