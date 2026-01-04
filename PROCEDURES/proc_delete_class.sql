CREATE OR REPLACE PROCEDURE proc_delete_class(
    IN p_class_name VARCHAR(10)
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Class WHERE class_name = p_class_name) THEN
        RAISE EXCEPTION 'Class % does not exist', p_class_name;
    END IF;

    DELETE FROM Class WHERE class_name = p_class_name;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Class', 'DELETE', p_class_name, SESSION_USER, 'Deleted class ' || p_class_name);
END;
$$;
