drop policy if exists anon_insert_requests on public.requests;

create policy anon_insert_requests
on public.requests
for insert
to anon, authenticated
with check (true);