-- Hidden activity names for cross-device sync (one row per user+name pair)
CREATE TABLE hidden_activities (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id text NOT NULL,
  name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, name)
);

ALTER TABLE hidden_activities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own hidden activities" ON hidden_activities
  FOR ALL USING (user_id = (auth.jwt() ->> 'sub'))
  WITH CHECK (user_id = (auth.jwt() ->> 'sub'));
