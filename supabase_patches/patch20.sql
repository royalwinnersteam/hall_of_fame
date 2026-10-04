-- REQUESTS
alter table public.requests drop constraint if exists requests_board_check;
alter table public.requests
    add constraint requests_board_check
    check (board in ('vboost','ts','vboost_direct','ts_direct','star'));

alter table public.requests drop constraint if exists requests_level_check;
alter table public.requests
    add constraint requests_level_check
    check (
        (board = 'vboost' and level between 1 and 10)
        or (board = 'ts' and level between 1 and 12)
        or (board in ('vboost_direct','ts_direct') and level between 0 and 30)
        or (board = 'star' and level between 1 and 7)
    );

alter table public.requests drop constraint if exists requests_passport_check;
alter table public.requests
    add constraint requests_passport_check
    check (
        (board in ('vboost','vboost_direct','star') and passport_nft ~ '^[0-9]{5}$')
        or
        (board in ('ts','ts_direct') and passport_nft ~ '^[A-Za-z0-9]{10}$')
    );

-- MEMBERS
alter table public.members drop constraint if exists members_board_check;
alter table public.members
    add constraint members_board_check
    check (board in ('vboost','ts','vboost_direct','ts_direct','star'));

alter table public.members drop constraint if exists members_level_check;
alter table public.members
    add constraint members_level_check
    check (
        (board = 'vboost' and level between 1 and 10)
        or (board = 'ts' and level between 1 and 12)
        or (board in ('vboost_direct','ts_direct') and level between 0 and 30)
        or (board = 'star' and level between 1 and 7)
    );

alter table public.members drop constraint if exists members_passport_check;
alter table public.members
    add constraint members_passport_check
    check (
        passport_nft is null
        or
        (board in ('vboost','vboost_direct','star') and passport_nft ~ '^[0-9]{5}$')
        or
        (board in ('ts','ts_direct') and passport_nft ~ '^[A-Za-z0-9]{10}$')
    );

-- EDIT REQUESTS
alter table public.edit_requests drop constraint if exists edit_requests_board_check;
alter table public.edit_requests
    add constraint edit_requests_board_check
    check (board in ('vboost','ts','vboost_direct','ts_direct','star'));

alter table public.edit_requests drop constraint if exists edit_requests_passport_check;
alter table public.edit_requests
    add constraint edit_requests_passport_check
    check (
        (board in ('vboost','vboost_direct','star') and new_passport_nft ~ '^[0-9]{5}$')
        or
        (board in ('ts','ts_direct') and new_passport_nft ~ '^[A-Za-z0-9]{10}$')
    );
