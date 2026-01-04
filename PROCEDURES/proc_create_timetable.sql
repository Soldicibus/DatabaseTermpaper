CREATE OR REPLACE PROCEDURE proc_create_timetable(
    IN p_timetable_name VARCHAR(20),
    IN p_timetable_class VARCHAR(10)
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    INSERT INTO Timetable (timetable_name, timetable_class)
    VALUES (p_timetable_name, p_timetable_class);

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Timetable', 'INSERT', p_timetable_name, SESSION_USER, 'Created timetable ' || p_timetable_name);
END;
$$;
