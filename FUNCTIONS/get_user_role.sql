CREATE OR REPLACE FUNCTION get_user_role(
    p_user_id INT
)
RETURNS TABLE(role_name VARCHAR)
LANGUAGE sql
AS $$
	SELECT r.role_name
	FROM UserRole ur
	JOIN Roles r ON ur.role_id = r.role_id
	WHERE ur.user_id = p_user_id;
$$;
