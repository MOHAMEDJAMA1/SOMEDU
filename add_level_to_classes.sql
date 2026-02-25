-- Add level column to classes table
-- Run this in Supabase SQL Editor

ALTER TABLE classes ADD COLUMN IF NOT EXISTS level TEXT;

-- Verify column was added
SELECT 'level column added to classes table' as message;
