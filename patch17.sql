-- ============================================================
-- Adds the level-specific date ("Date you unlocked/reached ...") to the
-- Edit Request flow, alongside the existing "Date joined Vistory":
--   - index.html: the Edit modal (opened from the Edit button inside a
--     member's ID card) now has a second date field for this, prefilled
--     with the member's current level_at — left as it is, it keeps the
--     same date; changed, it's submitted as part of the edit request for
--     an admin to review.
--   - admin.html: the Edit Requests tab shows the old date struck through
--     above the proposed new one (same as the other fields), and Accept
--     applies it to the member row. The admin "Edit" modal (opened from
--     any tab, including Edit Requests) also gets a matching field.
-- ============================================================

alter table public.edit_requests
    add column if not exists old_level_at date;

alter table public.edit_requests
    add column if not exists new_level_at date;

-- No RLS/grant changes needed — the existing insert/select/update/delete
-- grants on public.edit_requests are table-wide, so the two new columns
-- are already covered.
