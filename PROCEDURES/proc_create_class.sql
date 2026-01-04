CREATE OR REPLACE PROCEDURE proc_create_class(
    IN p_class_name VARCHAR(10),
    IN p_class_journal_id INT,
    IN p_class_mainTeacher INT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    INSERT INTO Class (class_name, class_journal_id, class_mainTeacher)
    VALUES (p_class_name, p_class_journal_id, p_class_mainTeacher);

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Class', 'INSERT', p_class_name, SESSION_USER, 'Created class ' || p_class_name);
END;
$$;
