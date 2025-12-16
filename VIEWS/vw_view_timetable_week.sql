CREATE OR REPLACE VIEW vw_view_timetable_week AS
SELECT
    tt.timetable_class        AS class_name,
    d.day_weekday             AS weekday,
    d.day_time                AS lesson_time,
    s.subject_name            AS subject
FROM Timetable tt
JOIN Days d
    ON d.day_timetable = tt.timetable_id
JOIN Subjects s
    ON d.day_subject = s.subject_id
ORDER BY
    tt.timetable_class,
    CASE d.day_weekday
        WHEN 'Понеділок' THEN 1
        WHEN 'Вівторок'  THEN 2
        WHEN 'Середа'    THEN 3
        WHEN 'Четвер'    THEN 4
        WHEN 'П’ятниця'  THEN 5
    END,
    d.day_time;
