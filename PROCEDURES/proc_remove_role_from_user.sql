CREATE OR REPLACE PROCEDURE proc_remove_role_from_user(
    IN p_user_id integer,
    IN p_role_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_users WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User % does not exist', p_user_id
        USING ERRCODE = '22003';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM vws_user_roles
        WHERE user_id = p_user_id AND role_id = p_role_id
    ) THEN
        RAISE EXCEPTION 'Role % is not assigned to user %', p_role_id, p_user_id
        USING ERRCODE = '22003';
    END IF;

    DELETE FROM userrole
    WHERE user_id = p_user_id AND role_id = p_role_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('UserRole', 'DELETE', p_user_id || ',' || p_role_id, SESSION_USER, 'Removed role from user');
END;
$$;
