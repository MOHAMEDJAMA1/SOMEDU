-- Create teacher_subjects table (Fixed Version)
-- This table links teachers to the subjects they teach
-- Run this in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS teacher_subjects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  teacher_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  subject_id UUID REFERENCES subjects(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(teacher_id, subject_id) -- Prevent duplicate assignments
);

-- Enable RLS
ALTER TABLE teacher_subjects ENABLE ROW LEVEL SECURITY;

-- Add RLS policies (fixed to get school_id from related tables)
CREATE POLICY "View teacher_subjects: Same School" ON teacher_subjects FOR SELECT TO authenticated USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id = teacher_subjects.teacher_id 
    AND (users.school_id = (SELECT school_id FROM users WHERE id = auth.uid()) 
         OR (SELECT role FROM users WHERE id = auth.uid()) = 'owner')
  )
);

CREATE POLICY "Manage teacher_subjects: Admin/Owner" ON teacher_subjects FOR ALL TO authenticated USING (
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id = teacher_subjects.teacher_id 
    AND ((SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'owner'))
    AND (users.school_id = (SELECT school_id FROM users WHERE id = auth.uid()) 
         OR (SELECT role FROM users WHERE id = auth.uid()) = 'owner')
  )
);

-- Verify table was created
SELECT 'teacher_subjects table created successfully' as message;
