CREATE OR REPLACE FUNCTION get_homework_by_date_class(
    p_class VARCHAR,
    p_date DATE
)
RETURNS TABLE(name VARCHAR, description TEXT)
LANGUAGE sql
AS $$
	SELECT homework_name, homework_desc
	FROM Homework
	WHERE homework_class = p_class
	AND homework_duedate = p_date;
$$;

CREATE OR REPLACE FUNCTION student_attendance_report(
    p_student_id INT,
    p_from DATE,
    p_to DATE
)
RETURNS TABLE(present INT, absent INT, present_percent NUMERIC)
LANGUAGE plpgsql
AS $$
	DECLARE total INT;
	BEGIN
	    SELECT COUNT(*) INTO total FROM StudentData
	    WHERE student_id = p_student_id;
	
	    RETURN QUERY
	    SELECT
	      COUNT(*) FILTER (WHERE status IN ('П','Присутній')),
	      COUNT(*) FILTER (WHERE status IN ('Н','Не присутній')),
	      (COUNT(*) FILTER (WHERE status IN ('П','Присутній'))::NUMERIC / total) * 100
	    FROM StudentData
	    WHERE student_id = p_student_id;
	END;
$$;

CREATE OR REPLACE FUNCTION student_day_plan(
    p_student_id INT,
    p_date DATE
)
RETURNS TABLE(lesson VARCHAR, mark SMALLINT, homework TEXT)
LANGUAGE sql
AS $$
	SELECT l.lesson_name, sd.mark, h.homework_desc
	FROM Students s
	JOIN Lessons l ON l.lesson_class = s.student_class
	LEFT JOIN StudentData sd ON sd.student_id = s.student_id
	LEFT JOIN Homework h ON h.homework_class = s.student_class
	WHERE s.student_id = p_student_id
	AND l.lesson_date = p_date;
$$;

CREATE OR REPLACE FUNCTION homework_by_date_subject(
    p_date DATE,
    p_subject INT DEFAULT NULL
)
RETURNS TABLE(homework TEXT)
LANGUAGE sql
AS $$
	SELECT h.homework_desc
	FROM Homework h
	JOIN Lessons l ON h.homework_lesson = l.lesson_id
	WHERE h.homework_duedate = p_date
	AND (p_subject IS NULL OR l.lesson_subject = p_subject);
$$;

CREATE OR REPLACE FUNCTION get_children_by_parent(
    p_parent_id INT
)
RETURNS TABLE(student_name VARCHAR)
LANGUAGE sql
AS $$
	SELECT s.student_name
	FROM StudentParent sp
	JOIN Students s ON sp.student_id_ref = s.student_id
	WHERE sp.parent_id_ref = p_parent_id;
$$;

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

CREATE OR REPLACE FUNCTION absents_more_than_x(
    p_class VARCHAR,
    p_x INT
)
RETURNS TABLE(student_id INT, absents INT)
LANGUAGE sql
AS $$
	SELECT s.student_id, COUNT(*)
	FROM Students s
	JOIN StudentData sd ON s.student_id = sd.student_id
	WHERE s.student_class = p_class
	AND sd.status IN ('Н','Не присутній')
	GROUP BY s.student_id
	HAVING COUNT(*) > p_x;
$$;