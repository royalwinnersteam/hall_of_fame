-- ============================================================
-- Adds "Date you unlocked/reached this level" (level_at), separate
-- from "Date joined Vistory" (joined_at):
--   - index.html: Step 7 of the request form now asks for this date too.
--       * New registration (not an upgrade): both "Date joined Vistory"
--         AND "Date you unlocked <Board> Level XX" / "Date you reached
--         <Board> XX Direct" are asked.
--       * Upgrade (same NFT/ID already exists on another level of the
--         same board, confirmed via the "Yes, upgrade" prompt): only the
--         second date ("Date you unlocked/reached ...") is asked — the
--         original "Date joined Vistory" is kept from the existing
--         member row, not re-asked.
--     The public Hall of Fame cards and the ID card now show BOTH dates,
--     and "No. of Days" is now counted from level_at instead of
--     joined_at.
--   - admin.html: pending/rejected request cards and the members roster
--     card show the new date, and it's editable from the "Edit" modal
--     (member / request / rejected) next to "Joined Vistory".
--     Accepting an upgrade request now carries the ORIGINAL joined_at
--     over from the member row being replaced (since the upgrade form no
--     longer asks for it), while level_at always comes from the request.
-- ============================================================

alter table public.requests
    add column if not exists level_at date;

alter table public.members
    add column if not exists level_at date;

-- No RLS/grant changes needed — the existing insert/select/update grants
-- on public.requests and public.members are table-wide (not restricted to
-- specific columns), so level_at is already covered.
