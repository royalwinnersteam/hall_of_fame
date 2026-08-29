alter table members drop constraint members_passport_nft_key;

alter table members add constraint members_board_passport_nft_key unique (board, passport_nft);