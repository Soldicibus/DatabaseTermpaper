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
CREATE OR REPLACE PROCEDURE proc_delete_lesson(
    IN p_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_lessons WHERE lesson_id = p_id) THEN
        RAISE EXCEPTION 'Lesson % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    DELETE FROM lessons WHERE lesson_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Lessons', 'DELETE', p_id::text, SESSION_USER, 'Deleted lesson');
END;
$$;
CREATE OR REPLACE PROCEDURE proc_delete_homework(
    IN p_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_homeworks WHERE homework_id = p_id) THEN
        RAISE EXCEPTION 'Homework % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    DELETE FROM homework WHERE homework_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Homework', 'DELETE', p_id::text, SESSION_USER, 'Deleted homework');
END;
$$;
CREATE OR REPLACE PROCEDURE proc_delete_studentdata(
    IN p_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_student_data WHERE data_id = p_id) THEN
        RAISE EXCEPTION 'StudentData % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    DELETE FROM studentdata WHERE data_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('StudentData', 'DELETE', p_id::text, SESSION_USER, 'Deleted student data');
END;
$$;
CREATE OR REPLACE PROCEDURE proc_delete_user(
    IN p_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_users WHERE user_id = p_id) THEN
        RAISE EXCEPTION 'User % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    DELETE FROM users WHERE user_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Users', 'DELETE', p_id::text, SESSION_USER, 'Deleted user');
END;
$$;