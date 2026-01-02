-- Combined Procedures and Functions
-- Generated automatically

-- DROP statements
DROP FUNCTION IF EXISTS absents_more_than_x(p_class VARCHAR, p_x INT) CASCADE;
DROP FUNCTION IF EXISTS get_children_by_parent(p_parent_id INT) CASCADE;
DROP FUNCTION IF EXISTS get_data_by_user_id(p_user_id INT) CASCADE;
DROP FUNCTION IF EXISTS get_homework_by_date_class(p_class VARCHAR, p_date DATE) CASCADE;
DROP FUNCTION IF EXISTS get_student_grade_entries(p_student_id INT, p_start_date DATE, p_end_date DATE) CASCADE;
DROP FUNCTION IF EXISTS get_student_marks(p_student_id INT, p_from DATE, p_to DATE) CASCADE;
DROP FUNCTION IF EXISTS get_teacher_salary(p_teacher_id INT, p_from DATE, p_to DATE) CASCADE;
DROP FUNCTION IF EXISTS get_user_role(p_user_id INT) CASCADE;
DROP FUNCTION IF EXISTS homework_by_date_subject(p_date DATE, p_subject INT) CASCADE;
DROP FUNCTION IF EXISTS login_user(p_login TEXT, p_password TEXT) CASCADE;
DROP FUNCTION IF EXISTS student_attendance_report(p_student_id INT, p_from DATE, p_to DATE) CASCADE;
DROP FUNCTION IF EXISTS student_day_plan(p_student_id INT, p_date DATE) CASCADE;
DROP FUNCTION IF EXISTS translit_uk_to_lat(p_text TEXT) CASCADE;
DROP PROCEDURE IF EXISTS proc_assign_role_to_user(IN p_user_id integer, IN p_role_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_assign_student_parent(IN p_student_id integer, IN p_parent_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_create_day(IN p_subject integer, IN p_timetable integer, IN p_day_time time, IN p_day_weekday varchar(20), OUT new_day_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_create_homework(INOUT p_name varchar(100), IN p_teacher integer, IN p_lesson integer, INOUT p_duedate date, INOUT p_desc text, IN p_class varchar(10), OUT new_homework_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_create_lesson(IN p_name varchar(50), IN p_class varchar(10), IN p_subject integer, IN p_material integer, IN p_teacher integer, IN p_date date, OUT new_lesson_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_create_material(IN p_name varchar(100), IN p_desc text, IN p_link text, OUT new_material_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_create_parent(IN p_name VARCHAR(50), IN p_surname VARCHAR(50), IN p_patronym VARCHAR(50), IN p_phone VARCHAR(20), IN p_user_id INTEGER, OUT new_parent_id INTEGER, OUT generated_password TEXT) CASCADE;
DROP PROCEDURE IF EXISTS proc_create_student(IN p_name VARCHAR(50), IN p_surname VARCHAR(50), IN p_patronym VARCHAR(50), IN p_phone VARCHAR(20), IN p_user_id INTEGER, IN p_class varchar(10), OUT new_student_id INTEGER, OUT generated_password TEXT) CASCADE;
DROP PROCEDURE IF EXISTS proc_create_studentdata(IN p_journal_id integer, IN p_student_id integer, IN p_lesson integer, IN p_mark smallint, IN p_status journal_status_enum, INOUT p_note text, OUT new_data_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_create_teacher(IN p_name varchar(50), IN p_surname varchar(50), IN p_patronym varchar(50), IN p_phone varchar(20), IN p_user_id integer, OUT new_teacher_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_create_user(IN p_username varchar(50), IN p_email varchar(60), IN p_password varchar(50), OUT new_user_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_delete_day(IN p_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_delete_day(IN p_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_delete_homework(IN p_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_delete_lesson(IN p_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_delete_material(IN p_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_delete_parent(IN p_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_delete_student(IN p_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_delete_studentdata(IN p_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_delete_teacher(IN p_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_delete_user(IN p_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_register_user(IN p_username VARCHAR(50), IN p_email VARCHAR(60), IN p_password TEXT, OUT new_user_id INT) CASCADE;
DROP PROCEDURE IF EXISTS proc_remove_role_from_user(IN p_user_id integer, IN p_role_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_reset_user_password(IN p_user_id integer, IN p_new_password varchar(50)) CASCADE;
DROP PROCEDURE IF EXISTS proc_unassign_student_parent(IN p_student_id integer, IN p_parent_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_update_day(IN p_id integer, IN p_subject integer, IN p_timetable integer, IN p_time time, IN p_weekday varchar(20)) CASCADE;
DROP PROCEDURE IF EXISTS proc_update_homework(IN p_id integer, IN p_name varchar(100), IN p_teacher integer, IN p_lesson integer, IN p_duedate date, IN p_desc text, IN p_class varchar(10)) CASCADE;
DROP PROCEDURE IF EXISTS proc_update_material(IN p_id integer, IN p_name varchar(100), IN p_desc text, IN p_link text) CASCADE;
DROP PROCEDURE IF EXISTS proc_update_parent(IN p_id integer, IN p_name varchar(50), IN p_surname varchar(50), IN p_patronym varchar(50), IN p_phone varchar(20), IN p_user_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_update_student(IN p_id integer, IN p_name varchar(50), IN p_surname varchar(50), IN p_patronym varchar(50), IN p_phone varchar(20), IN p_user_id integer, IN p_class varchar(10)) CASCADE;
DROP PROCEDURE IF EXISTS proc_update_studentdata(IN p_id integer, IN p_journal_id integer, IN p_student_id integer, IN p_lesson integer, IN p_mark smallint, IN p_status journal_status_enum, IN p_note text) CASCADE;
DROP PROCEDURE IF EXISTS proc_update_teacher(IN p_id integer, IN p_name varchar(50), IN p_surname varchar(50), IN p_patronym varchar(50), IN p_phone varchar(20), IN p_user_id integer) CASCADE;
DROP PROCEDURE IF EXISTS proc_update_user(IN p_id integer, IN p_username varchar(50), IN p_email varchar(60), IN p_password varchar(50)) CASCADE;
DROP PROCEDURE IF EXISTS public.proc_update_lesson(IN p_lesson_id integer, IN p_name character varying, IN p_class character varying, IN p_subject integer, IN p_material integer, IN p_teacher integer, IN p_date date) CASCADE;

-- Definitions
-- Source: FUNCTIONS/absents_more_than_x.sql
CREATE OR REPLACE FUNCTION absents_more_than_x(
    p_class VARCHAR,
    p_x INT
)
RETURNS TABLE(student_id INT, student_name VARCHAR, student_surname VARCHAR, absents INT)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
	SELECT s.student_id, s.student_name, s.student_surname, COUNT(*)
	FROM Students s
	JOIN StudentData sd ON s.student_id = sd.student_id
	WHERE s.student_class = p_class
	AND sd.status IN ('Н','Не присутній')
	GROUP BY s.student_id
	HAVING COUNT(*) > p_x;
$$;


-- Source: FUNCTIONS/get_children_by_parent.sql
CREATE OR REPLACE FUNCTION get_children_by_parent(
    p_parent_id INT
)
RETURNS TABLE(
    student_name VARCHAR,
    student_surname VARCHAR,
    student_class VARCHAR,
    avg_grade NUMERIC(4,2),
    attendance NUMERIC(5,2)
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
    SELECT
        s.student_name,
        s.student_surname,
        s.student_class,

        ROUND(AVG(j.mark)::NUMERIC, 2) AS avg_grade,

        ROUND(
            100.0 * COUNT(*) FILTER (WHERE j.status = 'Присутній' OR j.status = 'П')
            / NULLIF(COUNT(*), 0),
            2
        ) AS attendance

    FROM StudentParent sp
    JOIN Students s ON sp.student_id_ref = s.student_id
    LEFT JOIN StudentData j ON j.student_id = s.student_id

    WHERE sp.parent_id_ref = p_parent_id

    GROUP BY s.student_id, s.student_name, s.student_surname, s.student_class;
$$;


-- Source: FUNCTIONS/get_data_by_user_id.sql
CREATE OR REPLACE FUNCTION get_data_by_user_id(
    p_user_id INT
)
RETURNS TABLE (
    role TEXT,
    entity_id INT,
    name VARCHAR,
    surname VARCHAR,
    patronym VARCHAR,
    email VARCHAR,
    phone VARCHAR
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM students WHERE student_user_id = p_user_id
    ) THEN
        RETURN QUERY
        SELECT
            get_user_role(p_user_id)::TEXT,
            s.student_id,
            s.student_name,
            s.student_surname,
	        s.student_patronym,
            u.email,
            s.student_phone
        FROM students s
        JOIN users u ON u.user_id = s.student_user_id
        WHERE s.student_user_id = p_user_id;
    ELSIF EXISTS (
        SELECT 1 FROM teacher WHERE teacher_user_id = p_user_id
    ) THEN
        RETURN QUERY
        SELECT
            get_user_role(p_user_id)::TEXT,
            t.teacher_id,
            t.teacher_name,
            t.teacher_surname,
			t.teacher_patronym,
            u.email,
            t.teacher_phone
        FROM teacher t
        JOIN users u ON u.user_id = t.teacher_user_id
        WHERE t.teacher_user_id = p_user_id;
    ELSIF EXISTS (
        SELECT 1 FROM parents WHERE parent_user_id = p_user_id
    ) THEN
        RETURN QUERY
        SELECT
            get_user_role(p_user_id)::TEXT,
            p.parent_id,
            p.parent_name,
            p.parent_surname,
			p.parent_patronym,
            u.email,
            p.parent_phone
        FROM parents p
        JOIN users u ON u.user_id = p.parent_user_id
        WHERE p.parent_user_id = p_user_id;

    ELSE
        RAISE EXCEPTION 'No entity linked to user_id %', p_user_id
        USING ERRCODE = 'P0001';
    END IF;
END;
$$;

-- Source: FUNCTIONS/get_homework_by_date_class.sql
CREATE OR REPLACE FUNCTION get_homework_by_date_class(
    p_class VARCHAR,
    p_date DATE
)
RETURNS TABLE(name VARCHAR, description TEXT)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
	SELECT homework_name, homework_desc
	FROM Homework
	WHERE homework_class = p_class
	AND homework_duedate = p_date;
$$;


-- Source: FUNCTIONS/get_student_grade_entries.sql
CREATE OR REPLACE FUNCTION get_student_grade_entries(
    p_student_id INT,
    p_start_date DATE DEFAULT (CURRENT_DATE - INTERVAL '2 days')::DATE,
    p_end_date DATE DEFAULT (CURRENT_DATE + INTERVAL '7 days')::DATE
)
RETURNS TABLE (
    lesson_id INT,
    lesson_date DATE,
    subject_name TEXT,
    data_id INT,
    mark SMALLINT,
    status TEXT
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
    SELECT
	l.lesson_id,
        l.lesson_date,
        s.subject_name,
	sd.data_id,
        sd.mark,
        sd.status
    FROM StudentData sd
    JOIN Lessons l ON sd.lesson = l.lesson_id
    JOIN Subjects s ON l.lesson_subject = s.subject_id
    WHERE sd.student_id = p_student_id
      AND l.lesson_date BETWEEN p_start_date AND p_end_date
	  AND sd.mark IS NOT NULL
    ORDER BY l.lesson_date DESC, s.subject_name;
$$;

-- Source: FUNCTIONS/get_student_marks.sql
CREATE OR REPLACE FUNCTION get_student_marks(
    p_student_id INT,
    p_from DATE DEFAULT CURRENT_DATE - INTERVAL '1 month',
    p_to DATE DEFAULT CURRENT_DATE
)
RETURNS TABLE(mark SMALLINT, lesson_date DATE)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
	SELECT sd.mark, l.lesson_date
	FROM StudentData sd
	JOIN Journal j ON sd.journal_id = j.journal_id
	JOIN Lessons l ON j.journal_teacher = l.lesson_teacher
	WHERE sd.mark IS NOT NULL
	AND sd.student_id = p_student_id
	  AND l.lesson_date BETWEEN p_from AND p_to;
$$;

-- Source: FUNCTIONS/get_teacher_salary.sql
CREATE OR REPLACE FUNCTION get_teacher_salary(
    p_teacher_id INT,
    p_from DATE DEFAULT CURRENT_DATE - INTERVAL '1 month',
    p_to DATE DEFAULT CURRENT_DATE
)
RETURNS NUMERIC
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
SELECT COUNT(*) * 550
	FROM Lessons
	WHERE lesson_teacher = p_teacher_id
	AND lesson_date BETWEEN p_from AND p_to;
$$;

-- Source: FUNCTIONS/get_user_role.sql
CREATE OR REPLACE FUNCTION get_user_role(
    p_user_id INT
)
RETURNS TABLE(role_name VARCHAR)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
	SELECT r.role_name
	FROM UserRole ur
	JOIN Roles r ON ur.role_id = r.role_id
	WHERE ur.user_id = p_user_id;
$$;


-- Source: FUNCTIONS/homework_by_date_subject.sql
CREATE OR REPLACE FUNCTION homework_by_date_subject(
    p_date DATE,
    p_subject INT DEFAULT NULL
)
RETURNS TABLE(homework TEXT)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
	SELECT h.homework_desc
	FROM Homework h
	JOIN Lessons l ON h.homework_lesson = l.lesson_id
	WHERE h.homework_duedate = p_date
	AND (p_subject IS NULL OR l.lesson_subject = p_subject);
$$;


-- Source: FUNCTIONS/login_user.sql
CREATE OR REPLACE FUNCTION login_user(
    p_login TEXT,   -- username OR email
    p_password TEXT
)
RETURNS TABLE (
    user_id INT,
    username VARCHAR,
    email VARCHAR
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.user_id,
        u.username,
        u.email
    FROM users u
    WHERE
        (u.username = p_login OR u.email = p_login)
        AND u.password = crypt(p_password, u.password);

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Invalid credentials'
        USING ERRCODE = '28P01';
    END IF;
END;
$$;



-- Source: FUNCTIONS/student_attendance_report.sql
CREATE OR REPLACE FUNCTION student_attendance_report(
    p_student_id INT,
    p_from DATE DEFAULT CURRENT_DATE,
    p_to DATE DEFAULT (CURRENT_DATE + INTERVAL '7 days')::DATE
)
RETURNS TABLE (
    present INT,
    absent INT,
    present_percent NUMERIC(5,2)
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*)::INT
    INTO total
    FROM StudentData sd
    JOIN Lessons l ON l.lesson_id = sd.lesson
    WHERE sd.student_id = p_student_id
      AND l.lesson_date BETWEEN p_from AND p_to;

    IF total = 0 THEN
        RETURN QUERY SELECT 0, 0, (0)::numeric;
        RETURN;
    END IF;

    RETURN QUERY
    SELECT
        COUNT(*) FILTER (WHERE sd.status IN ('П','Присутній'))::INT,
        COUNT(*) FILTER (WHERE sd.status IN ('Н','Не присутній'))::INT,
        ROUND(
            (COUNT(*) FILTER (WHERE sd.status IN ('П','Присутній'))::NUMERIC / total) * 100,
            2
        )
    FROM StudentData sd
    JOIN Lessons l ON l.lesson_id = sd.lesson
    WHERE sd.student_id = p_student_id
      AND l.lesson_date BETWEEN p_from AND p_to;
END;
$$;


-- Source: FUNCTIONS/student_day_plan.sql
CREATE OR REPLACE FUNCTION student_day_plan(
    p_student_id INT,
    p_date DATE
)
RETURNS TABLE(lesson VARCHAR, mark SMALLINT, homework TEXT)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
	SELECT l.lesson_name, sd.mark, h.homework_desc
	FROM Students s
	JOIN Lessons l ON l.lesson_class = s.student_class
	LEFT JOIN StudentData sd ON sd.student_id = s.student_id
	LEFT JOIN Homework h ON h.homework_class = s.student_class
	WHERE s.student_id = p_student_id
	AND l.lesson_date = p_date;
$$;


-- Source: FUNCTIONS/translit_uk_to_lat.sql
CREATE OR REPLACE FUNCTION translit_uk_to_lat(p_text TEXT)
RETURNS TEXT
LANGUAGE plpgsql
IMMUTABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    t TEXT;
BEGIN
    t := lower(p_text);

    -- Multi-letter replacements first
    t := replace(t, 'щ', 'shch');
    t := replace(t, 'ж', 'zh');
    t := replace(t, 'ч', 'ch');
    t := replace(t, 'ш', 'sh');
    t := replace(t, 'ю', 'yu');
    t := replace(t, 'я', 'ya');
    t := replace(t, 'є', 'ye');
    t := replace(t, 'ї', 'yi');
    t := replace(t, 'х', 'kh');
    t := replace(t, 'ц', 'ts');

    -- Single-letter mapping
    t := translate(
        t,
        'абвгґдеиіїйклмнопрстуфзь',
        'abvhgdeyiyiklmnoprstufz'
    );

    RETURN t;
END;
$$;


-- Source: PROCEDURES/proc_assign_role_to_user.sql
CREATE OR REPLACE PROCEDURE proc_assign_role_to_user(
    IN p_user_id integer,
    IN p_role_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_users WHERE user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'User % does not exist', p_user_id
        USING ERRCODE = '22003';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM vws_roles WHERE role_id = p_role_id
    ) THEN
        RAISE EXCEPTION 'Role % does not exist', p_role_id
        USING ERRCODE = '22003';
    END IF;

    IF EXISTS (
        SELECT 1 FROM vws_user_roles
        WHERE user_id = p_user_id AND role_id = p_role_id
    ) THEN
        RAISE EXCEPTION 'User % already has role %', p_user_id, p_role_id
        USING ERRCODE = '23505';
    END IF;

    INSERT INTO userrole (user_id, role_id)
    VALUES (p_user_id, p_role_id);

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('UserRole', 'INSERT', p_user_id || ',' || p_role_id, SESSION_USER, 'Assigned role to user');
END;
$$;

-- Source: PROCEDURES/proc_assign_student_parent.sql
CREATE OR REPLACE PROCEDURE proc_assign_student_parent(
    IN p_student_id integer,
    IN p_parent_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_students WHERE student_id = p_student_id) THEN
        RAISE EXCEPTION 'Student % does not exist', p_student_id
        USING ERRCODE = '22003';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM vws_parents WHERE parent_id = p_parent_id) THEN
        RAISE EXCEPTION 'Parent % does not exist', p_parent_id
        USING ERRCODE = '22003';
    END IF;

    IF EXISTS (
        SELECT 1 FROM vws_student_parents
        WHERE student_id_ref = p_student_id AND parent_id_ref = p_parent_id
    ) THEN
        RAISE EXCEPTION 'This student is already assigned to this parent'
        USING ERRCODE = '23505';
    END IF;

    INSERT INTO studentparent(student_id_ref, parent_id_ref)
    VALUES (p_student_id, p_parent_id);

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('StudentParent', 'INSERT', p_student_id || ',' || p_parent_id, SESSION_USER, 'Assigned student to parent');
END;
$$;

-- Source: PROCEDURES/proc_create_day.sql
CREATE OR REPLACE PROCEDURE proc_create_day(
    IN p_subject integer,
	IN p_timetable integer,
    IN p_day_time time,
    IN p_day_weekday varchar(20),
    OUT new_day_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_timetables WHERE timetable_id = p_timetable
    ) THEN
        RAISE EXCEPTION 'Timetable % does not exist', p_timetable
        USING ERRCODE = '22003';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM vws_subjects WHERE subject_id = p_subject
    ) THEN
        RAISE EXCEPTION 'Subject % does not exist', p_subject
        USING ERRCODE = '22003';
    END IF;
	
    IF p_day_time IS NULL THEN
        RAISE EXCEPTION 'Day time cannot be NULL'
        USING ERRCODE = '23502';
    END IF;

    IF NOT p_day_weekday IN ('Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П''ятниця') THEN
        RAISE EXCEPTION 'Invalid weekday: %', p_day_weekday
        USING ERRCODE = '23514';
    END IF;

    INSERT INTO Days(day_subject, day_timetable, day_time, day_weekday)
    VALUES (p_subject, p_timetable, p_day_time, p_day_weekday)
    RETURNING day_id INTO new_day_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Days', 'INSERT', new_day_id::text, SESSION_USER, 'Created day');
END;
$$;

-- Source: PROCEDURES/proc_create_homework.sql
CREATE OR REPLACE PROCEDURE proc_create_homework(
    INOUT p_name varchar(100),
    IN p_teacher integer,
    IN p_lesson integer,
    INOUT p_duedate date,
    INOUT p_desc text,
    IN p_class varchar(10),
    OUT new_homework_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    p_name := NULLIF(trim(p_name), '');
    p_desc := NULLIF(trim(p_desc), '');

    IF p_desc IS NULL THEN
        RAISE EXCEPTION 'Homework description cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM vws_teachers WHERE teacher_id = p_teacher
    ) THEN
        RAISE EXCEPTION 'Teacher % does not exist', p_teacher
        USING ERRCODE = '23503';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM vws_lessons WHERE lesson_id = p_lesson
    ) THEN
        RAISE EXCEPTION 'Lesson % does not exist', p_lesson
        USING ERRCODE = '23503';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM vws_classes WHERE class_name = p_class
    ) THEN
        RAISE EXCEPTION 'Class % does not exist', p_class
        USING ERRCODE = '23503';
    END IF;

    IF p_class !~ '^(?:[1-9]|1[0-2])-([А-ЩЬЮЯҐЄІЇ]|[а-щьюяґєії])$' THEN
        RAISE EXCEPTION 'Class "%" does not match format N-Letter (e.g., 7-А)', p_class
        USING ERRCODE = '23514';
    END IF;

    IF p_duedate IS NULL THEN
        RAISE EXCEPTION 'Due date cannot be NULL'
        USING ERRCODE = '23502';
    END IF;

    IF p_duedate < CURRENT_DATE THEN
        RAISE EXCEPTION 'Due date (%) cannot be in the past', p_duedate
        USING ERRCODE = '22007';
    END IF;

    INSERT INTO homework(
        homework_name,
        homework_teacher,
        homework_lesson,
        homework_duedate,
        homework_desc,
        homework_class
    )
    VALUES (
        p_name,
        p_teacher,
        p_lesson,
        p_duedate,
        p_desc,
        p_class
    )
    RETURNING homework_id INTO new_homework_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Homework', 'INSERT', new_homework_id::text, SESSION_USER, 'Created homework');
END;
$$;


-- Source: PROCEDURES/proc_create_lesson.sql
CREATE OR REPLACE PROCEDURE proc_create_lesson(
    IN p_name varchar(50),
    IN p_class varchar(10),
    IN p_subject integer,
    IN p_material integer,
    IN p_teacher integer,
    IN p_date date,
    OUT new_lesson_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_classes WHERE class_name = p_class) THEN
        RAISE EXCEPTION 'Class % does not exist', p_class
        USING ERRCODE = '22003';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM vws_subjects WHERE subject_id = p_subject) THEN
        RAISE EXCEPTION 'Subject % does not exist', p_subject
        USING ERRCODE = '22003';
    END IF;

    IF p_material IS NOT NULL AND NOT EXISTS (SELECT 1 FROM vws_materials WHERE material_id = p_material) THEN
        RAISE EXCEPTION 'Material % does not exist', p_material
        USING ERRCODE = '22003';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM vws_teachers WHERE teacher_id = p_teacher) THEN
        RAISE EXCEPTION 'Teacher % does not exist', p_teacher
        USING ERRCODE = '22003';
    END IF;

    INSERT INTO Lessons(lesson_name, lesson_class, lesson_subject, lesson_material, lesson_teacher, lesson_date)
    VALUES (p_name, p_class, p_subject, p_material, p_teacher, COALESCE(p_date, CURRENT_DATE))
    RETURNING lesson_id INTO new_lesson_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Lessons', 'INSERT', new_lesson_id::text, SESSION_USER, 'Created lesson');
END;
$$;


-- Source: PROCEDURES/proc_create_material.sql
CREATE OR REPLACE PROCEDURE proc_create_material(
    IN p_name varchar(100),
    IN p_desc text,
    IN p_link text,
    OUT new_material_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    p_name := NULLIF(trim(p_name), '');
    IF p_name IS NULL THEN
        RAISE EXCEPTION 'Material name cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    p_desc := NULLIF(trim(p_desc), '');
    p_link := NULLIF(trim(p_link), '');

    INSERT INTO material(material_name, material_desc, material_link)
    VALUES (p_name, p_desc, p_link)
    RETURNING material_id INTO new_material_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Material', 'INSERT', new_material_id::text, SESSION_USER, 'Created material');
END;
$$;


-- Source: PROCEDURES/proc_create_parent.sql
CREATE OR REPLACE PROCEDURE proc_create_parent(
    IN p_name VARCHAR(50),
    IN p_surname VARCHAR(50),
    IN p_patronym VARCHAR(50),
    IN p_phone VARCHAR(20),
    IN p_user_id INTEGER,
    OUT new_parent_id INTEGER,
    OUT generated_password TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_user_id INT;
    v_username TEXT;
    v_email TEXT;
    v_password TEXT;
    v_patronym_part TEXT;
    v_parent_role_id INT;
BEGIN
	generated_password := NULL;
    /* ---------- Normalize input ---------- */
    p_name := NULLIF(trim(p_name), '');
    p_surname := NULLIF(trim(p_surname), '');
    p_patronym := NULLIF(trim(p_patronym), '');
    p_phone := NULLIF(trim(p_phone), '');

    IF p_name IS NULL OR p_surname IS NULL OR p_phone IS NULL THEN
        RAISE EXCEPTION 'Required parent fields cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    /* ---------- If user is provided, validate ---------- */
    IF p_user_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM vws_users WHERE user_id = p_user_id) THEN
            RAISE EXCEPTION 'User % does not exist', p_user_id
            USING ERRCODE = '22003';
        END IF;

        v_user_id := p_user_id;

    ELSE
        /* ---------- Generate username / email / password ---------- */

		v_patronym_part :=
		    substr(
		        translit_uk_to_lat(coalesce(p_patronym, 'xxx')),
		        1,
		        3
		    );

        v_username :=
		    translit_uk_to_lat(p_name) ||
		    translit_uk_to_lat(p_surname) ||
		    v_patronym_part;
		
		v_email :=
		    translit_uk_to_lat(p_name) ||
		    translit_uk_to_lat(p_surname) ||
		    v_patronym_part || '@school.edu.ua';

        generated_password :=
		    encode(gen_random_bytes(6), 'base64');
		
		v_password := generated_password;
		
        /* ---------- Register user ---------- */
        CALL proc_register_user(
            v_username,
            v_email,
            v_password,
            v_user_id
        );

        /* ---------- Assign parent role ---------- */
        SELECT role_id
        INTO v_parent_role_id
        FROM vws_roles
        WHERE role_name = 'Parent';

        IF v_parent_role_id IS NULL THEN
            RAISE EXCEPTION 'Role parent does not exist';
        END IF;

        CALL proc_assign_role_to_user(v_user_id, v_parent_role_id);

        RAISE NOTICE 'Generated password for %: %', v_username, v_password;
    END IF;

    /* ---------- Create parent entity ---------- */
    INSERT INTO parents (
        parent_name,
        parent_surname,
        parent_patronym,
        parent_phone,
        parent_user_id
    )
    VALUES (
        p_name,
        p_surname,
        p_patronym,
        p_phone,
        v_user_id
    )
    RETURNING parent_id INTO new_parent_id;
	INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Parent', 'INSERT', new_parent_id::text, SESSION_USER, 'Created parent');
END;
$$;


-- Source: PROCEDURES/proc_create_student.sql
CREATE OR REPLACE PROCEDURE proc_create_student(
    IN p_name VARCHAR(50),
    IN p_surname VARCHAR(50),
    IN p_patronym VARCHAR(50),
    IN p_phone VARCHAR(20),
    IN p_user_id INTEGER,
	IN p_class varchar(10),
    OUT new_student_id INTEGER,
    OUT generated_password TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_user_id INT;
    v_username TEXT;
    v_email TEXT;
    v_password TEXT;
    v_patronym_part TEXT;
    v_student_role_id INT;
BEGIN
	generated_password := NULL;
    /* ---------- Normalize input ---------- */
    p_name := NULLIF(trim(p_name), '');
    p_surname := NULLIF(trim(p_surname), '');
    p_patronym := NULLIF(trim(p_patronym), '');
    p_phone := NULLIF(trim(p_phone), '');

    IF p_name IS NULL OR p_surname IS NULL OR p_phone IS NULL THEN
        RAISE EXCEPTION 'Required student fields cannot be empty'
        USING ERRCODE = '23514';
    END IF;

	IF NOT EXISTS (
        SELECT 1 FROM vws_classes WHERE class_name = p_class
    ) THEN
        RAISE EXCEPTION 'Class % does not exist', p_class
        USING ERRCODE = '22003';
    END IF;

    /* ---------- If user is provided, validate ---------- */
    IF p_user_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM vws_users WHERE user_id = p_user_id) THEN
            RAISE EXCEPTION 'User % does not exist', p_user_id
            USING ERRCODE = '22003';
        END IF;

        v_user_id := p_user_id;

    ELSE
        /* ---------- Generate username / email / password ---------- */

		v_patronym_part :=
		    substr(
		        translit_uk_to_lat(coalesce(p_patronym, 'xxx')),
		        1,
		        3
		    );

        v_username :=
		    translit_uk_to_lat(p_name) ||
		    translit_uk_to_lat(p_surname) ||
		    v_patronym_part;
		
		v_email :=
		    translit_uk_to_lat(p_name) ||
		    translit_uk_to_lat(p_surname) ||
		    v_patronym_part || '@school.edu.ua';

        generated_password :=
		    encode(gen_random_bytes(6), 'base64');
		
		v_password := generated_password;
		
        /* ---------- Register user ---------- */
        CALL proc_register_user(
            v_username,
            v_email,
            v_password,
            v_user_id
        );

        /* ---------- Assign student role ---------- */
        SELECT role_id
        INTO v_student_role_id
        FROM vws_roles
        WHERE role_name = 'Student';

        IF v_student_role_id IS NULL THEN
            RAISE EXCEPTION 'Role student does not exist';
        END IF;

        CALL proc_assign_role_to_user(v_user_id, v_student_role_id);

        RAISE NOTICE 'Generated password for %: %', v_username, v_password;
    END IF;

    /* ---------- Create parent entity ---------- */
    INSERT INTO students (
        student_name,
        student_surname,
        student_patronym,
        student_phone,
        student_user_id,
		student_class
    )
    VALUES (
        p_name,
        p_surname,
        p_patronym,
        p_phone,
        v_user_id,
		p_class
    )
    RETURNING student_id INTO new_student_id;
	INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Student', 'INSERT', new_student_id::text, SESSION_USER, 'Created student');
END;
$$;


-- Source: PROCEDURES/proc_create_studentdata.sql
CREATE OR REPLACE PROCEDURE proc_create_studentdata(
    IN p_journal_id integer,
    IN p_student_id integer,
    IN p_lesson integer,
    IN p_mark smallint,
    IN p_status journal_status_enum,
    INOUT p_note text,
    OUT new_data_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_journals WHERE journal_id = p_journal_id
    ) THEN
        RAISE EXCEPTION 'Journal % does not exist', p_journal_id
        USING ERRCODE = '23503';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM vws_students WHERE student_id = p_student_id
    ) THEN
        RAISE EXCEPTION 'Student % does not exist', p_student_id
        USING ERRCODE = '23503';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM vws_lessons WHERE lesson_id = p_lesson
    ) THEN
        RAISE EXCEPTION 'Lesson % does not exist', p_lesson
        USING ERRCODE = '23503';
    END IF;

    IF p_mark IS NOT NULL AND (p_mark < 1 OR p_mark > 12) THEN
        RAISE EXCEPTION 'Mark % is out of range (1–12)', p_mark
        USING ERRCODE = '22003';
    END IF;

    p_note := NULLIF(trim(p_note), '');

    INSERT INTO studentdata (
        journal_id,
        student_id,
        lesson,
        mark,
        status,
        note
    )
    VALUES (
        p_journal_id,
        p_student_id,
        p_lesson,
        p_mark,
        p_status,
        p_note
    )
    RETURNING data_id INTO new_data_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('StudentData', 'INSERT', new_data_id::text, SESSION_USER, 'Created student data');
END;
$$;


-- Source: PROCEDURES/proc_create_teacher.sql
CREATE OR REPLACE PROCEDURE proc_create_teacher(
    IN p_name varchar(50),
    IN p_surname varchar(50),
    IN p_patronym varchar(50),
    IN p_phone varchar(20),
    IN p_user_id integer,
    OUT new_teacher_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    p_name := NULLIF(trim(p_name), '');
    p_surname := NULLIF(trim(p_surname), '');
    p_patronym := NULLIF(trim(p_patronym), '');
    p_phone := NULLIF(trim(p_phone), '');

    IF p_name IS NULL OR p_surname IS NULL OR p_phone IS NULL THEN
        RAISE EXCEPTION 'Required teacher fields cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF p_user_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_users WHERE user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'User % does not exist', p_user_id
        USING ERRCODE = '22003';
    END IF;

    INSERT INTO teacher (
        teacher_name,
        teacher_surname,
        teacher_patronym,
        teacher_phone,
        teacher_user_id
    )
    VALUES (
        p_name,
        p_surname,
        p_patronym,
        p_phone,
        p_user_id
    )
    RETURNING teacher_id INTO new_teacher_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Teacher', 'INSERT', new_teacher_id::text, SESSION_USER, 'Created teacher');
END;
$$;

-- Source: PROCEDURES/proc_create_user.sql
CREATE OR REPLACE PROCEDURE proc_create_user(
    IN p_username varchar(50),
    IN p_email varchar(60),
    IN p_password varchar(50),
    OUT new_user_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    p_username := NULLIF(trim(p_username), '');
    p_email := NULLIF(trim(p_email), '');
    p_password := NULLIF(trim(p_password), '');

    IF p_username IS NULL THEN
        RAISE EXCEPTION 'Username cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF p_email IS NULL THEN
        RAISE EXCEPTION 'Email cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF p_password IS NULL THEN
        RAISE EXCEPTION 'Password cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF EXISTS (
        SELECT 1 FROM vws_users WHERE username = p_username
    ) THEN
        RAISE EXCEPTION 'Username % already exists', p_username
        USING ERRCODE = '23505';
    END IF;

    IF EXISTS (
        SELECT 1 FROM vws_users WHERE email = p_email
    ) THEN
        RAISE EXCEPTION 'Email % already exists', p_email
        USING ERRCODE = '23505';
    END IF;

    INSERT INTO users (username, email, password)
    VALUES (p_username, p_email, p_password)
    RETURNING user_id INTO new_user_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Users', 'INSERT', new_user_id::text, SESSION_USER, 'Created user');
END;
$$;

-- Source: PROCEDURES/proc_delete_day.sql
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


-- Source: PROCEDURES/proc_delete_material.sql
CREATE OR REPLACE PROCEDURE proc_delete_material(
    IN p_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_materials WHERE material_id = p_id) THEN
        RAISE EXCEPTION 'Material % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    DELETE FROM material WHERE material_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Material', 'DELETE', p_id::text, SESSION_USER, 'Deleted material');
END;
$$;

-- Source: PROCEDURES/proc_delete_parent.sql
CREATE OR REPLACE PROCEDURE proc_delete_parent(
    IN p_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_user_id integer;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_parents WHERE parent_id = p_id) THEN
        RAISE EXCEPTION 'Parent % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    SELECT parent_user_id INTO v_user_id
    FROM vws_parents
    WHERE parent_id = p_id;

    DELETE FROM parents WHERE parent_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Parents', 'DELETE', p_id::text, SESSION_USER, 'Deleted parent');

    IF v_user_id IS NOT NULL THEN
        PERFORM proc_delete_user(v_user_id);
    END IF;
END;
$$;


-- Source: PROCEDURES/proc_delete_procedures.sql
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

-- Source: PROCEDURES/proc_delete_student.sql
CREATE OR REPLACE PROCEDURE proc_delete_student(
    IN p_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_user_id integer;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_students WHERE student_id = p_id) THEN
        RAISE EXCEPTION 'Student % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    SELECT student_user_id INTO v_user_id
    FROM vws_students
    WHERE student_id = p_id;

    DELETE FROM students WHERE student_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Students', 'DELETE', p_id::text, SESSION_USER, 'Deleted student');

    IF v_user_id IS NOT NULL THEN
        PERFORM proc_delete_user(v_user_id);
    END IF;
END;
$$;


-- Source: PROCEDURES/proc_delete_teacher.sql
CREATE OR REPLACE PROCEDURE proc_delete_teacher(
    IN p_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_user_id integer;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vws_teachers WHERE teacher_id = p_id) THEN
        RAISE EXCEPTION 'Teacher % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    SELECT teacher_user_id INTO v_user_id
    FROM vws_teachers
    WHERE teacher_id = p_id;

    DELETE FROM teacher WHERE teacher_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Teacher', 'DELETE', p_id::text, SESSION_USER, 'Deleted teacher');

    IF v_user_id IS NOT NULL THEN
        PERFORM proc_delete_user(v_user_id);
    END IF;
END;
$$;


-- Source: PROCEDURES/proc_register_user.sql
CREATE OR REPLACE PROCEDURE proc_register_user(
    IN  p_username VARCHAR(50),
    IN  p_email    VARCHAR(60),
    IN  p_password TEXT,
    OUT new_user_id INT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    /* ---------- Normalize ---------- */
    p_username := NULLIF(trim(p_username), '');
    p_email    := NULLIF(trim(p_email), '');
    p_password := NULLIF(trim(p_password), '');

    IF p_username IS NULL THEN
        RAISE EXCEPTION 'Username cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF p_email IS NULL THEN
        RAISE EXCEPTION 'Email cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF p_password IS NULL THEN
        RAISE EXCEPTION 'Password cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF EXISTS (SELECT 1 FROM vws_users WHERE username = p_username) THEN
        RAISE EXCEPTION 'Username % already exists', p_username
        USING ERRCODE = '23505';
    END IF;

    IF EXISTS (SELECT 1 FROM vws_users WHERE email = p_email) THEN
        RAISE EXCEPTION 'Email % already exists', p_email
        USING ERRCODE = '23505';
    END IF;

    /* ---------- Hash password ---------- */
    p_password := crypt(p_password, gen_salt('bf'));

    /* ---------- PASS OUT PARAM DIRECTLY ---------- */
    CALL proc_create_user(
        p_username,
        p_email,
        p_password,
        new_user_id
    );
END;
$$;


-- Source: PROCEDURES/proc_remove_role_from_user.sql
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


-- Source: PROCEDURES/proc_reset_user_password.sql
CREATE OR REPLACE PROCEDURE proc_reset_user_password(
    IN p_user_id integer,
    IN p_new_password varchar(50)
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_users WHERE user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'User % does not exist', p_user_id
        USING ERRCODE = '22003';
    END IF;

    p_new_password := NULLIF(trim(p_new_password), '');

    IF p_new_password IS NULL THEN
        RAISE EXCEPTION 'Password cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    UPDATE users
    SET password = p_new_password
    WHERE user_id = p_user_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Users', 'UPDATE', p_user_id::text, SESSION_USER, 'Reset user password');
END;
$$;


-- Source: PROCEDURES/proc_unassign_student_parent.sql
CREATE OR REPLACE PROCEDURE proc_unassign_student_parent(
    IN p_student_id integer,
    IN p_parent_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_student_parents
        WHERE student_id_ref = p_student_id AND parent_id_ref = p_parent_id
    ) THEN
        RAISE EXCEPTION 'No assignment exists between student % and parent %', p_student_id, p_parent_id
        USING ERRCODE = '22003';
    END IF;

    DELETE FROM studentparent
    WHERE student_id_ref = p_student_id AND parent_id_ref = p_parent_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('StudentParent', 'DELETE', p_student_id || ',' || p_parent_id, SESSION_USER, 'Unassigned student from parent');
END;
$$;


-- Source: PROCEDURES/proc_update_day.sql
CREATE OR REPLACE PROCEDURE proc_update_day
(
    IN p_id integer,
    IN p_subject integer,
	IN p_timetable integer,
    IN p_time time DEFAULT NULL,
    IN p_weekday varchar(20) DEFAULT NULL
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_days WHERE day_id = p_id
    ) THEN
        RAISE EXCEPTION 'Day % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;
	
	IF NOT EXISTS (
        SELECT 1 FROM vws_timetables WHERE timetable_id = p_timetable
    ) THEN
        RAISE EXCEPTION 'Timetable % does not exist', p_timetable
        USING ERRCODE = '22003';
    END IF;

	IF NOT EXISTS (
        SELECT 1 FROM vws_subjects WHERE subject_id = p_subject
    ) THEN
        RAISE EXCEPTION 'Subject % does not exist', p_subject
        USING ERRCODE = '22003';
    END IF;
    p_weekday := NULLIF(trim(p_weekday), '');

    IF p_weekday IS NOT NULL AND
       p_weekday NOT IN ('Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П’ятниця') THEN
        RAISE EXCEPTION 'Invalid weekday: %', p_weekday
        USING ERRCODE = '23514';
    END IF;

    UPDATE days
    SET
        day_timetable    = COALESCE(p_timetable, day_timetable),
		day_subject		= COALESCE(p_subject, day_subject),
        day_time    = COALESCE(p_time, day_time),
        day_weekday = COALESCE(p_weekday, day_weekday)
    WHERE day_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Days', 'UPDATE', p_id::text, SESSION_USER, 'Updated day');
END;
$$;

-- Source: PROCEDURES/proc_update_homework.sql
CREATE OR REPLACE PROCEDURE proc_update_homework(
    IN p_id integer,
    IN p_name varchar(100) DEFAULT NULL,
    IN p_teacher integer DEFAULT NULL,
    IN p_lesson integer DEFAULT NULL,
    IN p_duedate date DEFAULT NULL,
    IN p_desc text DEFAULT NULL,
    IN p_class varchar(10) DEFAULT NULL
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_homeworks WHERE homework_id = p_id
    ) THEN
        RAISE EXCEPTION 'Homework % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    p_name := NULLIF(trim(p_name), '');
    p_desc := NULLIF(trim(p_desc), '');
    p_class := NULLIF(trim(p_class), '');

    IF p_desc IS NOT NULL AND length(p_desc) = 0 THEN
        RAISE EXCEPTION 'Homework description cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF p_teacher IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_teachers WHERE teacher_id = p_teacher
    ) THEN
        RAISE EXCEPTION 'Teacher % does not exist', p_teacher
        USING ERRCODE = '22003';
    END IF;

    IF p_lesson IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_lessons WHERE lesson_id = p_lesson
    ) THEN
        RAISE EXCEPTION 'Lesson % does not exist', p_lesson
        USING ERRCODE = '22003';
    END IF;

    IF p_class IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1 FROM vws_classes WHERE class_name = p_class
        ) THEN
            RAISE EXCEPTION 'Class % does not exist', p_class
            USING ERRCODE = '22003';
        END IF;

        IF p_class !~ '^(?:[1-9]|1[0-2])-([А-ЩЬЮЯҐЄІЇ]|[а-щьюяґєії])$' THEN
            RAISE EXCEPTION 'Invalid class format: %', p_class
            USING ERRCODE = '23514';
        END IF;
    END IF;

    IF p_duedate IS NOT NULL AND p_duedate < CURRENT_DATE THEN
        RAISE EXCEPTION 'Due date (%) cannot be in the past', p_duedate
        USING ERRCODE = '22007';
    END IF;

    UPDATE homework
    SET
        homework_name    = COALESCE(p_name, homework_name),
        homework_teacher = COALESCE(p_teacher, homework_teacher),
        homework_lesson  = COALESCE(p_lesson, homework_lesson),
        homework_duedate = COALESCE(p_duedate, homework_duedate),
        homework_desc    = COALESCE(p_desc, homework_desc),
        homework_class   = COALESCE(p_class, homework_class)
    WHERE homework_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Homework', 'UPDATE', p_id::text, SESSION_USER, 'Updated homework');
END;
$$;


-- Source: PROCEDURES/proc_update_lesson.sql
CREATE OR REPLACE PROCEDURE public.proc_update_lesson(
	IN p_lesson_id integer,
	IN p_name character varying DEFAULT NULL::character varying,
	IN p_class character varying DEFAULT NULL::character varying,
	IN p_subject integer DEFAULT NULL::integer,
	IN p_material integer DEFAULT NULL::integer,
	IN p_teacher integer DEFAULT NULL::integer,
	IN p_date date DEFAULT NULL::date)
LANGUAGE 'plpgsql'
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_lessons WHERE lesson_id = p_lesson_id
    ) THEN
        RAISE EXCEPTION 'Lesson % does not exist', p_lesson_id
        USING ERRCODE = '22003';
    END IF;

    p_name := NULLIF(trim(p_name), '');

    IF p_material = 0 THEN
        p_material := NULL;
    END IF;

    IF p_teacher IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_teachers WHERE teacher_id = p_teacher
    ) THEN
        RAISE EXCEPTION 'Teacher % does not exist', p_teacher
        USING ERRCODE = '22003';
    END IF;

    IF p_class IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1 FROM vws_classes WHERE class_name = p_class
        ) THEN
            RAISE EXCEPTION 'Class % does not exist', p_class
            USING ERRCODE = '22003';
        END IF;

        IF p_class !~ '^(?:[1-9]|1[0-2])-([А-ЩЬЮЯҐЄІЇ]|[а-щьюяґєії])$' THEN
            RAISE EXCEPTION 'Invalid class format: %', p_class
            USING ERRCODE = '23514';
        END IF;
    END IF;

    IF p_subject IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_subjects WHERE subject_id = p_subject
    ) THEN
        RAISE EXCEPTION 'Subject % does not exist', p_subject
        USING ERRCODE = '22003';
    END IF;

    UPDATE lessons
    SET
        lesson_name     = COALESCE(p_name, lesson_name),
        lesson_class    = COALESCE(p_class, lesson_class),
        lesson_subject  = COALESCE(p_subject, lesson_subject),
        lesson_material = COALESCE(p_material, lesson_material),
        lesson_teacher  = COALESCE(p_teacher, lesson_teacher),
        lesson_date     = COALESCE(p_date, lesson_date)
    WHERE lesson_id = p_lesson_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Lessons', 'UPDATE', p_lesson_id::text, SESSION_USER, 'Updated lesson');
END;
$$;

-- Source: PROCEDURES/proc_update_material.sql
CREATE OR REPLACE PROCEDURE proc_update_material(
	IN p_id integer,
	IN p_name varchar(100),
    IN p_desc text,
    IN p_link text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
		SELECT 1 FROM vws_materials WHERE material_id = p_id
    ) THEN
        RAISE EXCEPTION 'Material % does not exist', p_id
        USING ERRCODE = '22003';
    END IF; 
	
	p_name := NULLIF(trim(p_name), '');
    p_desc := NULLIF(trim(p_desc), '');
    p_link := NULLIF(trim(p_link), '');

    IF p_name IS NOT NULL AND length(p_name) = 0 THEN
        RAISE EXCEPTION 'Material name cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    UPDATE material
	SET
		material_name	= COALESCE(p_name, material_name),
		material_desc	= COALESCE(p_desc, material_desc),
		material_link	= COALESCE(p_link, material_link)
	WHERE material_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Material', 'UPDATE', p_id::text, SESSION_USER, 'Updated material');
END;
$$;

	

-- Source: PROCEDURES/proc_update_parent.sql
CREATE OR REPLACE PROCEDURE proc_update_parent(
    IN p_id integer,
    IN p_name varchar(50),
    IN p_surname varchar(50),
    IN p_patronym varchar(50),
    IN p_phone varchar(20),
    IN p_user_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_parents WHERE parent_id = p_id
    ) THEN
        RAISE EXCEPTION 'Parent % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    p_name := NULLIF(trim(p_name), '');
    p_surname := NULLIF(trim(p_surname), '');
    p_patronym := NULLIF(trim(p_patronym), '');
    p_phone := NULLIF(trim(p_phone), '');

    IF p_user_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_users WHERE user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'User % does not exist', p_user_id
        USING ERRCODE = '22003';
    END IF;

    UPDATE parents
    SET
        parent_name      = COALESCE(p_name, parent_name),
        parent_surname   = COALESCE(p_surname, parent_surname),
        parent_patronym  = COALESCE(p_patronym, parent_patronym),
        parent_phone     = COALESCE(p_phone, parent_phone),
        parent_user_id   = COALESCE(p_user_id, parent_user_id)
    WHERE parent_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Parents', 'UPDATE', p_id::text, SESSION_USER, 'Updated parent');
END;
$$;

-- Source: PROCEDURES/proc_update_student.sql
CREATE OR REPLACE PROCEDURE proc_update_student(
    IN p_id integer,
    IN p_name varchar(50),
    IN p_surname varchar(50),
    IN p_patronym varchar(50),
    IN p_phone varchar(20),
    IN p_user_id integer,
    IN p_class varchar(10)
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_students WHERE student_id = p_id
    ) THEN
        RAISE EXCEPTION 'Student % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    p_name := NULLIF(trim(p_name), '');
    p_surname := NULLIF(trim(p_surname), '');
    p_patronym := NULLIF(trim(p_patronym), '');
    p_phone := NULLIF(trim(p_phone), '');

    IF p_class IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_classes WHERE class_name = p_class
    ) THEN
        RAISE EXCEPTION 'Class % does not exist', p_class
        USING ERRCODE = '22003';
    END IF;

    IF p_user_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_users WHERE user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'User % does not exist', p_user_id
        USING ERRCODE = '22003';
    END IF;

    UPDATE students
    SET
        student_name       = COALESCE(p_name, student_name),
        student_surname    = COALESCE(p_surname, student_surname),
        student_patronym   = COALESCE(p_patronym, student_patronym),
        student_phone      = COALESCE(p_phone, student_phone),
        student_user_id    = COALESCE(p_user_id, student_user_id),
        student_class      = COALESCE(p_class, student_class)
    WHERE student_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Students', 'UPDATE', p_id::text, SESSION_USER, 'Updated student');
END;
$$;

-- Source: PROCEDURES/proc_update_studentdata.sql
CREATE OR REPLACE PROCEDURE proc_update_studentdata(
    IN p_id integer,
    IN p_journal_id integer DEFAULT NULL,
    IN p_student_id integer DEFAULT NULL,
    IN p_lesson integer DEFAULT NULL,
    IN p_mark smallint DEFAULT NULL,
    IN p_status journal_status_enum DEFAULT NULL,
    IN p_note text DEFAULT NULL
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_student_data WHERE data_id = p_id
    ) THEN
        RAISE EXCEPTION 'Studentdata % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    p_note := NULLIF(trim(p_note), '');

    IF p_journal_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_journals WHERE journal_id = p_journal_id
    ) THEN
        RAISE EXCEPTION 'Journal % does not exist', p_journal_id
        USING ERRCODE = '22003';
    END IF;

    IF p_student_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_students WHERE student_id = p_student_id
    ) THEN
        RAISE EXCEPTION 'Student % does not exist', p_student_id
        USING ERRCODE = '22003';
    END IF;

    IF p_lesson IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_lessons WHERE lesson_id = p_lesson
    ) THEN
        RAISE EXCEPTION 'Lesson % does not exist', p_lesson
        USING ERRCODE = '22003';
    END IF;

    IF p_mark IS NOT NULL AND (p_mark < 1 OR p_mark > 12) THEN
        RAISE EXCEPTION 'Mark % is out of range (1–12)', p_mark
        USING ERRCODE = '22003';
    END IF;

    UPDATE studentdata
    SET
        journal_id = COALESCE(p_journal_id, journal_id),
        student_id = COALESCE(p_student_id, student_id),
        lesson     = COALESCE(p_lesson, lesson),
        mark       = COALESCE(p_mark, mark),
        status     = COALESCE(p_status, status),
        note       = COALESCE(p_note, note)
    WHERE data_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('StudentData', 'UPDATE', p_id::text, SESSION_USER, 'Updated student data');
END;
$$;


-- Source: PROCEDURES/proc_update_teacher.sql
CREATE OR REPLACE PROCEDURE proc_update_teacher(
    IN p_id integer,
    IN p_name varchar(50),
    IN p_surname varchar(50),
    IN p_patronym varchar(50),
    IN p_phone varchar(20),
    IN p_user_id integer
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_teachers WHERE teacher_id = p_id
    ) THEN
        RAISE EXCEPTION 'Teacher % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    p_name := NULLIF(trim(p_name), '');
    p_surname := NULLIF(trim(p_surname), '');
    p_patronym := NULLIF(trim(p_patronym), '');
    p_phone := NULLIF(trim(p_phone), '');

    IF p_user_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM vws_users WHERE user_id = p_user_id
    ) THEN
        RAISE EXCEPTION 'User % does not exist', p_user_id
        USING ERRCODE = '22003';
    END IF;

    UPDATE teacher
    SET
        teacher_name     = COALESCE(p_name, teacher_name),
        teacher_surname  = COALESCE(p_surname, teacher_surname),
        teacher_patronym = COALESCE(p_patronym, teacher_patronym),
        teacher_phone    = COALESCE(p_phone, teacher_phone),
        teacher_user_id  = COALESCE(p_user_id, teacher_user_id)
    WHERE teacher_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Teacher', 'UPDATE', p_id::text, SESSION_USER, 'Updated teacher');
END;
$$;


-- Source: PROCEDURES/proc_update_user.sql
CREATE OR REPLACE PROCEDURE proc_update_user(
    IN p_id integer,
    IN p_username varchar(50) DEFAULT NULL,
    IN p_email varchar(60) DEFAULT NULL,
    IN p_password varchar(50) DEFAULT NULL
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM vws_users WHERE user_id = p_id
    ) THEN
        RAISE EXCEPTION 'User % does not exist', p_id
        USING ERRCODE = 'P0002';
    END IF;

    p_username := NULLIF(trim(p_username), '');
    p_email := NULLIF(trim(p_email), '');
    p_password := NULLIF(trim(p_password), '');

    IF p_username IS NOT NULL AND EXISTS (
        SELECT 1 FROM vws_users WHERE username = p_username AND user_id <> p_id
    ) THEN
        RAISE EXCEPTION 'Username % already exists', p_username
        USING ERRCODE = '23505';
    END IF;

    IF p_email IS NOT NULL AND EXISTS (
        SELECT 1 FROM vws_users WHERE email = p_email AND user_id <> p_id
    ) THEN
        RAISE EXCEPTION 'Email % already exists', p_email
        USING ERRCODE = '23505';
    END IF;

    IF p_password IS NOT NULL THEN
	    p_password := crypt(p_password, gen_salt('bf'));
	END IF;

    UPDATE users
    SET
        username = COALESCE(p_username, username),
        email    = COALESCE(p_email, email),
        password = COALESCE(p_password, password)
    WHERE user_id = p_id;

    INSERT INTO AuditLog (table_name, operation, record_id, changed_by, details)
    VALUES ('Users', 'UPDATE', p_id::text, SESSION_USER, 'Updated user');
END;
$$;


