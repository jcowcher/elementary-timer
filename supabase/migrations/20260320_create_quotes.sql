-- Create quotes table for film/TV quote themes
CREATE TABLE quotes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  quote text NOT NULL,
  source_theme text NOT NULL,
  character text,
  created_at timestamptz DEFAULT now()
);

-- Index for filtered queries by theme
CREATE INDEX idx_quotes_source_theme ON quotes (source_theme);

-- RLS: publicly readable, admin-only writes
ALTER TABLE quotes ENABLE ROW LEVEL SECURITY;

-- Anyone can read quotes (no auth required)
CREATE POLICY "Quotes are publicly readable"
  ON quotes
  FOR SELECT
  USING (true);

-- Only authenticated admin can insert/update/delete
-- Uses service_role key (Supabase dashboard) or match your Clerk user ID
-- To restrict to your specific user, replace 'YOUR_CLERK_USER_ID' below:
-- CREATE POLICY "Admin can manage quotes" ON quotes FOR ALL
--   USING (auth.jwt() ->> 'sub' = 'YOUR_CLERK_USER_ID')
--   WITH CHECK (auth.jwt() ->> 'sub' = 'YOUR_CLERK_USER_ID');
-- For now, inserts/updates/deletes are blocked by RLS (no write policy)
-- Manage quotes via Supabase dashboard or service_role key
