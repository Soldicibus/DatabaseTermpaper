CREATE OR REPLACE PROCEDURE proc_delete_journal(
    IN p_journal_id INT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Journal WHERE journal_id = p_journal_id) THEN
        RAISE EXCEPTION 'Journal with ID % does not exist', p_journal_id;
    END IF;

    DELETE FROM Journal WHERE journal_id = p_journal_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Journal', 'DELETE', p_journal_id::TEXT, SESSION_USER, 'Deleted journal ' || p_journal_id);
END;
$$;
