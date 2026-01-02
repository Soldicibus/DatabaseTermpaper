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
