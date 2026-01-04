CREATE OR REPLACE PROCEDURE proc_create_role(
    IN p_role_name VARCHAR(10),
    IN p_role_desc TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    INSERT INTO Roles (role_name, role_desc)
    VALUES (p_role_name, p_role_desc);

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Roles', 'INSERT', p_role_name, SESSION_USER, 'Created role ' || p_role_name);
END;
$$;
