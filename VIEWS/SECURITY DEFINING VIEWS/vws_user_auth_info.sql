CREATE OR REPLACE VIEW vws_user_auth_info AS
SELECT 
    u.user_id,
    u.username,
    u.email,
    r.role_name,
    r.role_desc
FROM Users u
JOIN UserRole ur ON u.user_id = ur.user_id
JOIN Roles r ON ur.role_id = r.role_id;