CREATE OR REPLACE PROCEDURE proc_create_day(
    IN p_day_name varchar(255),
    IN p_day_time time,
    IN p_day_weekday varchar(20),
    OUT new_day_id integer
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_day_name varchar(255);
BEGIN
    v_day_name := NULLIF(trim(p_day_name), '');
    IF v_day_name IS NULL THEN
        RAISE EXCEPTION 'Day name cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF p_day_time IS NULL THEN
        RAISE EXCEPTION 'Day time cannot be NULL'
        USING ERRCODE = '23502';
    END IF;

    IF NOT p_day_weekday IN ('Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П''ятниця') THEN
        RAISE EXCEPTION 'Invalid weekday: %', p_day_weekday
        USING ERRCODE = '23514';
    END IF;

    INSERT INTO Days(day_name, day_time, day_weekday)
    VALUES (v_day_name, p_day_time, p_day_weekday)
    RETURNING day_id INTO new_day_id;
END;
$$;
