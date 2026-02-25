-- Drop table if exists (to start fresh)
DROP TABLE IF EXISTS grades CASCADE;

-- Create Grades Table
CREATE TABLE grades (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  school_id UUID REFERENCES schools(id) NOT NULL,
  student_id UUID REFERENCES users(id) NOT NULL,
  subject_id UUID REFERENCES subjects(id) NOT NULL,
  teacher_id UUID REFERENCES users(id) NOT NULL,
  class_id UUID REFERENCES classes(id) NOT NULL,
  exam_type TEXT CHECK (exam_type IN ('midterm', 'final', 'quiz', 'assignment', 'project')) NOT NULL,
  exam_name TEXT,
  score DECIMAL(5,2) NOT NULL,
  max_score DECIMAL(5,2) NOT NULL,
  percentage DECIMAL(5,2) GENERATED ALWAYS AS ((score / max_score) * 100) STORED,
  date DATE NOT NULL,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create indexes for faster queries
CREATE INDEX idx_grades_student ON grades(student_id);
CREATE INDEX idx_grades_subject ON grades(subject_id);
CREATE INDEX idx_grades_class ON grades(class_id);
CREATE INDEX idx_grades_exam_type ON grades(exam_type);

-- Enable RLS
ALTER TABLE grades ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Students can view own grades" ON grades;
DROP POLICY IF EXISTS "Teachers can view subject grades" ON grades;
DROP POLICY IF EXISTS "Teachers can create grades" ON grades;
DROP POLICY IF EXISTS "Teachers can update own grades" ON grades;
DROP POLICY IF EXISTS "Admins full access to grades" ON grades;

-- RLS Policies for Grades
-- Students can view their own grades
CREATE POLICY "Students can view own grades"
ON grades FOR SELECT
TO authenticated
USING (auth.uid() = student_id);

-- Teachers can view grades for their school
CREATE POLICY "Teachers can view subject grades"
ON grades FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.role = 'teacher'
    AND grades.school_id = users.school_id
  )
);

-- Teachers can insert grades
CREATE POLICY "Teachers can create grades"
ON grades FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = teacher_id
  AND EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.role = 'teacher'
  )
);

-- Teachers can update grades they created
CREATE POLICY "Teachers can update own grades"
ON grades FOR UPDATE
TO authenticated
USING (auth.uid() = teacher_id);

-- Admins can do everything
CREATE POLICY "Admins full access to grades"
ON grades FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.role IN ('admin', 'owner')
    AND grades.school_id = users.school_id
  )
);

-- Verification
SELECT 'Grades table created successfully!' as message;
