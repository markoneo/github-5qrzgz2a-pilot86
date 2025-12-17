/*
  # Add Driver Trip Tracking Columns

  1. New Columns Added to `projects` table:
    - `acceptance_status` (text) - Track if driver accepted/declined/started trip (pending, accepted, started, declined)
    - `driver_fee` (numeric) - The fee the driver receives for this trip
    - `accepted_at` (timestamptz) - When the driver accepted the trip
    - `accepted_by` (uuid) - Which driver accepted (for audit)
    - `started_at` (timestamptz) - When the trip was started
    - `completed_at` (timestamptz) - When the trip was completed
    - `completed_by` (uuid) - Which driver completed (for audit)

  2. Purpose:
    - Enable drivers to accept/decline/start/complete trips
    - Track driver earnings separately from total trip price
    - Maintain history of completed trips for drivers
*/

-- Add acceptance_status column with default 'pending'
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'projects' AND column_name = 'acceptance_status'
  ) THEN
    ALTER TABLE projects ADD COLUMN acceptance_status text DEFAULT 'pending';
  END IF;
END $$;

-- Add driver_fee column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'projects' AND column_name = 'driver_fee'
  ) THEN
    ALTER TABLE projects ADD COLUMN driver_fee numeric;
  END IF;
END $$;

-- Add accepted_at column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'projects' AND column_name = 'accepted_at'
  ) THEN
    ALTER TABLE projects ADD COLUMN accepted_at timestamptz;
  END IF;
END $$;

-- Add accepted_by column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'projects' AND column_name = 'accepted_by'
  ) THEN
    ALTER TABLE projects ADD COLUMN accepted_by uuid;
  END IF;
END $$;

-- Add started_at column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'projects' AND column_name = 'started_at'
  ) THEN
    ALTER TABLE projects ADD COLUMN started_at timestamptz;
  END IF;
END $$;

-- Add completed_at column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'projects' AND column_name = 'completed_at'
  ) THEN
    ALTER TABLE projects ADD COLUMN completed_at timestamptz;
  END IF;
END $$;

-- Add completed_by column
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'projects' AND column_name = 'completed_by'
  ) THEN
    ALTER TABLE projects ADD COLUMN completed_by uuid;
  END IF;
END $$;

-- Create index for faster driver queries
CREATE INDEX IF NOT EXISTS idx_projects_driver_id ON projects(driver_id);
CREATE INDEX IF NOT EXISTS idx_projects_acceptance_status ON projects(acceptance_status);
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(status);
