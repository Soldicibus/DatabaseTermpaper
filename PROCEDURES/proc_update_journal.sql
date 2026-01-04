CREATE OR REPLACE PROCEDURE proc_update_journal(
    IN p_journal_id INT,
    IN p_journal_teacher INT,
    IN p_journal_name VARCHAR(50)
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Journal WHERE journal_id = p_journal_id) THEN
        RAISE EXCEPTION 'Journal with ID % does not exist', p_journal_id;
    END IF;

    UPDATE Journal
    SET journal_teacher = COALESCE(p_journal_teacher, journal_teacher),
        journal_name = COALESCE(p_journal_name, journal_name)
    WHERE journal_id = p_journal_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Journal', 'UPDATE', p_journal_id::TEXT, SESSION_USER, 'Updated journal ' || p_journal_id);
END;
$$;
