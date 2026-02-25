-- Create Exams Schedule Table
DROP TABLE IF EXISTS exams CASCADE;

CREATE TABLE exams (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  school_id UUID REFERENCES schools(id) NOT NULL,
  class_id UUID REFERENCES classes(id) NOT NULL,
  subject_id UUID REFERENCES subjects(id) NOT NULL,
  exam_type TEXT CHECK (exam_type IN ('midterm', 'final', 'quiz', 'assignment', 'project')) NOT NULL,
  exam_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  location TEXT,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create indexes
CREATE INDEX idx_exams_class ON exams(class_id);
CREATE INDEX idx_exams_subject ON exams(subject_id);
CREATE INDEX idx_exams_date ON exams(exam_date);

-- Enable RLS
ALTER TABLE exams ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Students can view class exams" ON exams;
DROP POLICY IF EXISTS "Teachers can view exams" ON exams;
DROP POLICY IF EXISTS "Admins full access to exams" ON exams;

-- RLS Policies
-- Students can view exams for their class
CREATE POLICY "Students can view class exams"
ON exams FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.class_id = exams.class_id
  )
);

-- Teachers can view all exams in their school
CREATE POLICY "Teachers can view exams"
ON exams FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.role = 'teacher'
    AND exams.school_id = users.school_id
  )
);

-- Admins can do everything
CREATE POLICY "Admins full access to exams"
ON exams FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.role IN ('admin', 'owner', 'manager')
    AND exams.school_id = users.school_id
  )
);

-- Verification
SELECT 'Exams table created successfully!' as message;
