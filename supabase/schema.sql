-- SCHOOLS TABLE
CREATE TABLE schools (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  logo_url TEXT,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- USERS TABLE
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id), -- Links to Supabase Auth
  school_id UUID REFERENCES schools(id), -- Nullable for Owner
  email TEXT NOT NULL,
  full_name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('owner', 'admin', 'teacher', 'student')),
  must_change_password BOOLEAN DEFAULT FALSE,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- CLASSES TABLE
CREATE TABLE classes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  school_id UUID REFERENCES schools(id) NOT NULL,
  name TEXT NOT NULL, -- e.g. "6-A"
  level TEXT NOT NULL CHECK (level IN ('Primary', 'Secondary', 'High School')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- SUBJECTS TABLE
CREATE TABLE subjects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  school_id UUID REFERENCES schools(id) NOT NULL,
  name TEXT NOT NULL,
  code TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- TIMETABLES TABLE
CREATE TABLE timetables (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  school_id UUID REFERENCES schools(id) NOT NULL,
  class_id UUID REFERENCES classes(id) NOT NULL,
  subject_id UUID REFERENCES subjects(id) NOT NULL,
  teacher_id UUID REFERENCES users(id) NOT NULL,
  day_of_week TEXT NOT NULL, -- Monday, Tuesday...
  period_number INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(school_id, class_id, day_of_week, period_number) -- Prevent double booking class
);

-- ATTENDANCE TABLE
CREATE TABLE attendance (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  school_id UUID REFERENCES schools(id) NOT NULL,
  student_id UUID REFERENCES users(id) NOT NULL,
  class_id UUID REFERENCES classes(id) NOT NULL,
  date DATE NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('Present', 'Absent', 'Late', 'Excused')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- GRADES TABLE
CREATE TABLE grades (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  school_id UUID REFERENCES schools(id) NOT NULL,
  student_id UUID REFERENCES users(id) NOT NULL,
  subject_id UUID REFERENCES subjects(id) NOT NULL,
  class_id UUID REFERENCES classes(id) NOT NULL,
  grade INTEGER NOT NULL CHECK (grade >= 0 AND grade <= 100),
  description TEXT, -- e.g. "Midterm", "Homework 1"
  date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ENABLE ROW LEVEL SECURITY
ALTER TABLE schools ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE timetables ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE grades ENABLE ROW LEVEL SECURITY;

-- POLICIES

-- 1. Owner can do anything
CREATE POLICY "Owner can do everything on schools" ON schools FOR ALL TO authenticated USING (auth.uid() IN (SELECT id FROM users WHERE role = 'owner'));
CREATE POLICY "Owner can do everything on users" ON users FOR ALL TO authenticated USING (auth.uid() IN (SELECT id FROM users WHERE role = 'owner'));
-- ... (repeat for all tables, or rely on school_id logic for simplicity if owner also has a school_id, but owner is super admin)
-- Simplest approach for Owner: They bypass RLS or we add a policy for them on every table.
-- Let's define a helper function or just separate policies.

-- 2. Scoped Access by School ID
-- Logic: Users can only see data where table.school_id == user.school_id
-- We need a way to look up the current user's school_id/role securely.
-- For standard RLS, we often cache user claims, but for now we'll do direct lookups or `auth.uid()`.

-- SCHOOLS
-- Owners see all. Users see their own school.
CREATE POLICY "Owners see all schools" ON schools FOR SELECT TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'owner'
);
CREATE POLICY "Users see their own school" ON schools FOR SELECT TO authenticated USING (
  id = (SELECT school_id FROM users WHERE id = auth.uid())
);

-- USERS
-- Owners see all. Managers see users in their school. Users see themselves.
CREATE POLICY "Owners see all users" ON users FOR SELECT TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'owner'
);
CREATE POLICY "Managers see users in their school" ON users FOR ALL TO authenticated USING (
  (SELECT role FROM users WHERE id = auth.uid()) = 'admin' AND
  school_id = (SELECT school_id FROM users WHERE id = auth.uid())
);
CREATE POLICY "Users see themselves" ON users FOR SELECT TO authenticated USING (
  id = auth.uid()
);

-- GENERIC SCHOOL SCOPED TABLES (classes, subjects, etc.)
-- Policy: User must belong to the same school_id as the record.
-- AND (Role based write permissions)

-- CLASSES
CREATE POLICY "View Classes: Same School" ON classes FOR SELECT TO authenticated USING (
  school_id = (SELECT school_id FROM users WHERE id = auth.uid()) OR 
  (SELECT role FROM users WHERE id = auth.uid()) = 'owner'
);
CREATE POLICY "Manage Classes: Admin/Owner" ON classes FOR ALL TO authenticated USING (
  ((SELECT role FROM users WHERE id = auth.uid()) IN ('admin', 'owner')) AND
  (school_id = (SELECT school_id FROM users WHERE id = auth.uid()) OR (SELECT role FROM users WHERE id = auth.uid()) = 'owner')
);

-- ... (Similar patterns for subjects, timetables)
