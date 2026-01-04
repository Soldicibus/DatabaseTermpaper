CREATE OR REPLACE PROCEDURE proc_update_timetable(
    IN p_timetable_id INT,
    IN p_timetable_name VARCHAR(20),
    IN p_timetable_class VARCHAR(10)
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Timetable WHERE timetable_id = p_timetable_id) THEN
        RAISE EXCEPTION 'Timetable with ID % does not exist', p_timetable_id;
    END IF;

    UPDATE Timetable
    SET timetable_name = COALESCE(p_timetable_name, timetable_name),
        timetable_class = COALESCE(p_timetable_class, timetable_class)
    WHERE timetable_id = p_timetable_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Timetable', 'UPDATE', p_timetable_id::TEXT, SESSION_USER, 'Updated timetable ' || p_timetable_id);
END;
$$;
