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
	FROM vws.students s
	JOIN vws.student_data sd ON s.student_id = sd.student_id
	WHERE s.student_class = p_class
	AND sd.status IN ('Н','Не присутній')
	GROUP BY s.student_id
	HAVING COUNT(*) > p_x;
$$;
