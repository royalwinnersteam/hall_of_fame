-- Remove old policies
drop policy if exists "anon_upload_member_photos" on storage.objects;
drop policy if exists "public_view_member_photos" on storage.objects;
drop policy if exists "authenticated_delete_member_photos" on storage.objects;

-- Public can view uploaded files
create policy "public_view_member_photos"
on storage.objects
for select
to public
using (bucket_id = 'member-photos');

-- Anyone can upload to this bucket
create policy "anon_upload_member_photos"
on storage.objects
for insert
to public
with check (bucket_id = 'member-photos');

-- Authenticated users can delete
create policy "authenticated_delete_member_photos"
on storage.objects
for delete
to authenticated
using (bucket_id = 'member-photos');