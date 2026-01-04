CREATE OR REPLACE PROCEDURE proc_update_class(
    IN p_class_name VARCHAR(10),
    IN p_class_journal_id INT,
    IN p_class_mainTeacher INT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Class WHERE class_name = p_class_name) THEN
        RAISE EXCEPTION 'Class % does not exist', p_class_name;
    END IF;

    UPDATE Class
    SET class_journal_id = COALESCE(p_class_journal_id, class_journal_id),
        class_mainTeacher = COALESCE(p_class_mainTeacher, class_mainTeacher)
    WHERE class_name = p_class_name;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Class', 'UPDATE', p_class_name, SESSION_USER, 'Updated class ' || p_class_name);
END;
$$;
