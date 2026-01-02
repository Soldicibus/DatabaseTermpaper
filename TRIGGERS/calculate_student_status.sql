CREATE OR REPLACE FUNCTION calculate_student_status()
RETURNS TRIGGER AS $$
DECLARE
    v_avg_grade NUMERIC(4,2);
    v_attendance_pct NUMERIC(5,2);
    v_new_status VARCHAR(20);
    v_student_id INT;
BEGIN
    -- Determine student_id (works for INSERT/UPDATE on StudentData)
    v_student_id := NEW.student_id;

    -- 1. Calculate Average Grade (ignoring NULLs)
    SELECT AVG(mark) INTO v_avg_grade
    FROM StudentData
    WHERE student_id = v_student_id AND mark IS NOT NULL;

    -- 2. Calculate Attendance Percentage
    -- Counts 'Присутній'/'П' as present, everything else as absent/total
    SELECT 
        CASE WHEN COUNT(*) = 0 THEN 0 
        ELSE (COUNT(*) FILTER (WHERE status IN ('Присутній', 'П'))::NUMERIC / COUNT(*)) * 100 
        END INTO v_attendance_pct
    FROM StudentData
    WHERE student_id = v_student_id;

    -- 3. Determine Status Logic (Complex Business Logic)
    IF v_avg_grade >= 10 AND v_attendance_pct >= 90 THEN
        v_new_status := 'Excellent'; -- Відмінник
    ELSIF v_avg_grade >= 7 AND v_attendance_pct >= 75 THEN
        v_new_status := 'Good'; -- Хорошист
    ELSIF v_avg_grade < 4 OR v_attendance_pct < 50 THEN
        v_new_status := 'At Risk'; -- В зоні ризику
    ELSE
        v_new_status := 'Regular'; -- Звичайний
    END IF;

    -- 4. Update Student Table
    -- Only update if the status has actually changed to avoid unnecessary writes
    UPDATE Students
    SET academic_status = v_new_status
    WHERE student_id = v_student_id
    AND (academic_status IS DISTINCT FROM v_new_status);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_student_status
AFTER INSERT OR UPDATE ON StudentData
FOR EACH ROW
EXECUTE FUNCTION calculate_student_status();