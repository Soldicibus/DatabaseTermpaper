CREATE OR REPLACE PROCEDURE proc_delete_day(
    IN p_id integer
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM days WHERE day_id = p_id) THEN
        RAISE EXCEPTION 'Day % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    DELETE FROM days WHERE day_id = p_id;
END;
$$;
