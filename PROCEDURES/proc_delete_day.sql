CREATE OR REPLACE PROCEDURE proc_delete_day(
    IN p_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_days WHERE day_id = p_id) THEN
        RAISE EXCEPTION 'Day % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    DELETE FROM days WHERE day_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Days', 'DELETE', p_id::text, SESSION_USER, 'Deleted day');
END;
$$;
