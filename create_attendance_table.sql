-- Drop table if exists (to start fresh)
DROP TABLE IF EXISTS attendance CASCADE;

-- Create Attendance Table
CREATE TABLE attendance (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  school_id UUID REFERENCES schools(id) NOT NULL,
  student_id UUID REFERENCES users(id) NOT NULL,
  teacher_id UUID REFERENCES users(id) NOT NULL,
  class_id UUID REFERENCES classes(id) NOT NULL,
  subject_id UUID REFERENCES subjects(id) NOT NULL,
  date DATE NOT NULL,
  status TEXT CHECK (status IN ('present', 'absent', 'late', 'excused')) NOT NULL,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create indexes for faster queries
CREATE INDEX idx_attendance_student ON attendance(student_id);
CREATE INDEX idx_attendance_class ON attendance(class_id);
CREATE INDEX idx_attendance_date ON attendance(date);
CREATE INDEX idx_attendance_subject ON attendance(subject_id);

-- Enable RLS
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Students can view own attendance" ON attendance;
DROP POLICY IF EXISTS "Teachers can view class attendance" ON attendance;
DROP POLICY IF EXISTS "Teachers can create attendance" ON attendance;
DROP POLICY IF EXISTS "Teachers can update own attendance" ON attendance;
DROP POLICY IF EXISTS "Admins full access to attendance" ON attendance;

-- RLS Policies for Attendance
-- Students can view their own attendance
CREATE POLICY "Students can view own attendance"
ON attendance FOR SELECT
TO authenticated
USING (auth.uid() = student_id);

-- Teachers can view attendance for their school
CREATE POLICY "Teachers can view class attendance"
ON attendance FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.role = 'teacher'
    AND attendance.school_id = users.school_id
  )
);

-- Teachers can insert attendance
CREATE POLICY "Teachers can create attendance"
ON attendance FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = teacher_id
  AND EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.role = 'teacher'
  )
);

-- Teachers can update attendance they created
CREATE POLICY "Teachers can update own attendance"
ON attendance FOR UPDATE
TO authenticated
USING (auth.uid() = teacher_id);

-- Admins can do everything
CREATE POLICY "Admins full access to attendance"
ON attendance FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.role IN ('admin', 'owner')
    AND attendance.school_id = users.school_id
  )
);

-- Verification
SELECT 'Attendance table created successfully!' as message;
