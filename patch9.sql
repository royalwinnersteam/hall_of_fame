-- Run this in the Supabase SQL Editor (Project → SQL Editor → New query)

-- 1) Find the current unique constraint name on passport_nft
select conname, pg_get_constraintdef(oid)
from pg_constraint
where conrelid = 'members'::regclass and contype = 'u';

-- 2) Drop it — replace <constraint_name> below with whatever conname
--    the query above returned (e.g. members_passport_nft_key)
alter table members drop constraint <constraint_name>;

-- 3) Add a composite unique constraint instead: the same NFT/ID can now
--    exist once per board (so it can sit on both a Level board and its
--    paired Direct board), but you're still protected against a true
--    duplicate — the same NFT twice on the exact same board.
alter table members add constraint members_board_passport_nft_key unique (board, passport_nft);
