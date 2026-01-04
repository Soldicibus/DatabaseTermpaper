CREATE OR REPLACE PROCEDURE proc_create_subject(
    IN p_subject_name TEXT,
    IN p_cabinet INT,
    IN p_subject_program TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    INSERT INTO Subjects (subject_name, cabinet, subject_program)
    VALUES (p_subject_name, p_cabinet, p_subject_program);

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Subjects', 'INSERT', p_subject_name, SESSION_USER, 'Created subject ' || p_subject_name);
END;
$$;
