select conname, pg_get_constraintdef(oid)
from pg_constraint
where conrelid = 'members'::regclass and contype = 'u';

alter table members drop constraint <constraint_name>;

alter table members add constraint members_board_passport_nft_key unique (board, passport_nft);
