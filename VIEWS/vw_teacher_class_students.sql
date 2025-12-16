CREATE OR REPLACE VIEW vw_teacher_class_students AS
SELECT
    c.class_name,
    s.student_name,
    s.student_surname
FROM Class c
JOIN Teacher t
    ON c.class_mainTeacher = t.teacher_id
LEFT JOIN Students s
    ON s.student_class = c.class_name
ORDER BY
    c.class_name,
    s.student_surname,
    s.student_name;
