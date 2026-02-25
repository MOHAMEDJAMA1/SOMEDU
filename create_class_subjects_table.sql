-- Create class_subjects table
-- This table links classes to subjects (e.g., Grade 6-A takes Biology, Chemistry, etc.)
-- Run this in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS class_subjects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  class_id UUID REFERENCES classes(id) ON DELETE CASCADE NOT NULL,
  subject_id UUID REFERENCES subjects(id) ON DELETE CASCADE NOT NULL,
  school_id UUID REFERENCES schools(id) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(class_id, subject_id) -- Prevent duplicate subject assignments
);

-- Enable RLS
ALTER TABLE class_subjects ENABLE ROW LEVEL SECURITY;

-- Add RLS policies
CREATE POLICY "View class_subjects: Same School" ON class_subjects FOR SELECT TO authenticated USING (
  school_id = (SELECT school_id FROM users WHERE id = auth.uid()) OR 
  (SELECT role FROM users WHERE id = auth.uid()) = 'owner'
);

CREATE POLICY "Manage class_subjects: Admin/Owner" ON class_subjects FOR ALL TO authenticated USING (
  ((SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'owner')) AND
  (school_id = (SELECT school_id FROM users WHERE id = auth.uid()) OR (SELECT role FROM users WHERE id = auth.uid()) = 'owner')
);

-- Verify table was created
SELECT 'class_subjects table created successfully' as message;
