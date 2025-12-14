CREATE OR REPLACE PROCEDURE proc_update_day
(
    IN p_id integer,
    IN p_name varchar(255) DEFAULT NULL,
    IN p_time time DEFAULT NULL,
    IN p_weekday varchar(20) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM days WHERE day_id = p_id
    ) THEN
        RAISE EXCEPTION 'Day % does not exist', p_id
        USING ERRCODE = '22003';
    END IF;

    p_name := NULLIF(trim(p_name), '');
    p_weekday := NULLIF(trim(p_weekday), '');

    -- validate name if provided
    IF p_name IS NOT NULL AND length(p_name) = 0 THEN
        RAISE EXCEPTION 'Day name cannot be empty'
        USING ERRCODE = '23514';
    END IF;

    IF p_weekday IS NOT NULL AND
       p_weekday NOT IN ('Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П’ятниця') THEN
        RAISE EXCEPTION 'Invalid weekday: %', p_weekday
        USING ERRCODE = '23514';
    END IF;

    UPDATE days
    SET
        day_name    = COALESCE(p_name, day_name),
        day_time    = COALESCE(p_time, day_time),
        day_weekday = COALESCE(p_weekday, day_weekday)
    WHERE day_id = p_id;
END;
$$;
