CREATE OR REPLACE PROCEDURE proc_delete_timetable(
    IN p_timetable_id INT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Timetable WHERE timetable_id = p_timetable_id) THEN
        RAISE EXCEPTION 'Timetable with ID % does not exist', p_timetable_id;
    END IF;

    DELETE FROM Timetable WHERE timetable_id = p_timetable_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Timetable', 'DELETE', p_timetable_id::TEXT, SESSION_USER, 'Deleted timetable ' || p_timetable_id);
END;
$$;
