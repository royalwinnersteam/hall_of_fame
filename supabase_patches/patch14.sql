-- ============================================================
-- Adds "Date joined Vistory" to the Edit Request flow:
--   - index.html: the Edit modal (opened from the Edit button inside a
--     member's ID card) now has a "Date joined Vistory" field, prefilled
--     with the member's current date — left as it is, it keeps the same
--     date; changed, it's submitted as part of the edit request for an
--     admin to review.
--   - admin.html: the Edit Requests tab shows the old date struck through
--     above the proposed new one (same as Name/District/WhatsApp/ID), and
--     Accept applies it to the member row.
-- ============================================================

alter table public.edit_requests
    add column if not exists old_joined_at date;

alter table public.edit_requests
    add column if not exists new_joined_at date;

-- No RLS/grant changes needed — the existing insert/select/delete grants on
-- public.edit_requests are table-wide, so the two new columns are already
-- covered.
