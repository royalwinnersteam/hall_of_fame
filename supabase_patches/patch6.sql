do $$
declare
    r record;
begin
    for r in
        select conname, conrelid::regclass::text as tbl
        from pg_constraint
        where contype = 'c'
          and conrelid in ('public.requests'::regclass, 'public.members'::regclass)
          and pg_get_constraintdef(oid) ~ 'board|level|passport_nft'
    loop
        execute format('alter table %s drop constraint %I', r.tbl, r.conname);
    end loop;
end $$;

-- ------------------------------------------------------------
-- REQUESTS TABLE — recreated constraints with named
-- vboost_direct / ts_direct boards added
-- ------------------------------------------------------------
alter table public.requests
    drop constraint if exists requests_board_check;
alter table public.requests
    add constraint requests_board_check
    check (board in ('vboost','ts','vboost_direct','ts_direct'));

alter table public.requests
    drop constraint if exists requests_level_check;
alter table public.requests
    add constraint requests_level_check
    check (
        (board = 'vboost' and level between 1 and 10)
        or (board = 'ts' and level between 1 and 12)
        or (board in ('vboost_direct','ts_direct') and level between 1 and 30)
    );

alter table public.requests
    drop constraint if exists requests_passport_check;
alter table public.requests
    add constraint requests_passport_check
    check (
        (board in ('vboost','vboost_direct') and passport_nft ~ '^[0-9]{5}$')
        or
        (board in ('ts','ts_direct') and passport_nft ~ '^[A-Za-z0-9]{10}$')
    );

-- ------------------------------------------------------------
-- MEMBERS TABLE — same additions
-- ------------------------------------------------------------
alter table public.members
    drop constraint if exists members_board_check;
alter table public.members
    add constraint members_board_check
    check (board in ('vboost','ts','vboost_direct','ts_direct'));

alter table public.members
    drop constraint if exists members_level_check;
alter table public.members
    add constraint members_level_check
    check (
        (board = 'vboost' and level between 1 and 10)
        or (board = 'ts' and level between 1 and 12)
        or (board in ('vboost_direct','ts_direct') and level between 1 and 30)
    );

alter table public.members
    drop constraint if exists members_passport_check;
alter table public.members
    add constraint members_passport_check
    check (
        passport_nft is null
        or
        (board in ('vboost','vboost_direct') and passport_nft ~ '^[0-9]{5}$')
        or
        (board in ('ts','ts_direct') and passport_nft ~ '^[A-Za-z0-9]{10}$')
    );