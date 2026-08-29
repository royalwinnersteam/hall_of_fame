-- ------------------------------------------------------------
-- REQUESTS TABLE
-- ------------------------------------------------------------
alter table public.requests
    drop constraint if exists requests_level_check;
alter table public.requests
    add constraint requests_level_check
    check (
        (board = 'vboost' and level between 1 and 10)
        or (board = 'ts' and level between 1 and 12)
        or (board in ('vboost_direct','ts_direct') and level between 0 and 30)
    );

-- ------------------------------------------------------------
-- MEMBERS TABLE
-- ------------------------------------------------------------
alter table public.members
    drop constraint if exists members_level_check;
alter table public.members
    add constraint members_level_check
    check (
        (board = 'vboost' and level between 1 and 10)
        or (board = 'ts' and level between 1 and 12)
        or (board in ('vboost_direct','ts_direct') and level between 0 and 30)
    );