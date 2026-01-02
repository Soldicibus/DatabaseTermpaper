CREATE OR REPLACE VIEW vw_student_performance_matrix AS
WITH 
-- 1. STATISTICS: ACADEMIC (Grades)
AcademicStats AS (
    SELECT 
        sd.student_id,
        COUNT(sd.mark) AS count_marks,
        ROUND(AVG(sd.mark), 2) AS avg_grade,
        -- Count bad marks (assuming 1-3 is 'Initial' level/Fail in 12-point system)
        COUNT(CASE WHEN sd.mark BETWEEN 1 AND 3 THEN 1 END) AS count_failures,
        MAX(l.lesson_date) AS last_graded_date
    FROM StudentData sd
    JOIN Lessons l ON sd.lesson = l.lesson_id
    WHERE sd.mark IS NOT NULL
    GROUP BY sd.student_id
),

-- 2. STATISTICS: DISCIPLINE (Attendance)
AttendanceStats AS (
    SELECT 
        sd.student_id,
        COUNT(*) AS total_entries,
        -- Count absences (checking both short 'Н' and full 'Не присутній')
        COUNT(CASE WHEN sd.status IN ('Не присутній', 'Н') THEN 1 END) AS count_absences,
        MAX(l.lesson_date) AS last_seen_date
    FROM StudentData sd
    JOIN Lessons l ON sd.lesson = l.lesson_id
    GROUP BY sd.student_id
)

-- 3. DATA MERGE & SEGMENTATION
SELECT 
    s.student_id,
    s.student_name || ' ' || s.student_surname || ' ' || s.student_patronym AS student_full_name,
    s.student_class,
    
    -- Performance Metrics
    COALESCE(acad.avg_grade, 0) AS gpa,
    COALESCE(acad.count_marks, 0) AS total_marks_received,
    COALESCE(acad.count_failures, 0) AS total_failed_marks,
    
    -- Attendance Metrics
    COALESCE(att.count_absences, 0) AS total_absences,
    CASE 
        WHEN COALESCE(att.total_entries, 0) = 0 THEN 0 
        ELSE ROUND((COALESCE(att.count_absences, 0)::DECIMAL / att.total_entries) * 100, 1)
    END AS absence_percentage,

    -- Recency (Days since last activity)
    GREATEST(acad.last_graded_date, att.last_seen_date) AS last_activity_date,
    CASE 
        WHEN GREATEST(acad.last_graded_date, att.last_seen_date) IS NOT NULL 
        THEN (CURRENT_DATE - GREATEST(acad.last_graded_date, att.last_seen_date))
        ELSE NULL 
    END AS days_since_last_activity,

    -- SEGMENTATION (The "Tier" Logic)
    CASE 
        -- 1. High Risk: Failing grades OR High absence rate (> 30%)
        WHEN (COALESCE(acad.avg_grade, 0) > 0 AND acad.avg_grade < 4) 
             OR (CASE WHEN att.total_entries > 0 THEN (att.count_absences::DECIMAL / att.total_entries) ELSE 0 END > 0.30)
             THEN 'В зоні ризику' -- At Risk
             
        -- 2. High Achiever: GPA > 10 AND Low Absences
        WHEN acad.avg_grade >= 10 AND COALESCE(att.count_absences, 0) < 3
             THEN 'Відмінник' -- Excellent
             
        -- 3. Good Standing: GPA 7-10
        WHEN acad.avg_grade >= 7 
             THEN 'Хорошист' -- Good
             
        -- 4. Inactive: No marks or entries yet
        WHEN acad.avg_grade IS NULL AND att.total_entries IS NULL
             THEN 'Новий/Без активності' -- New/Inactive
             
        -- 5. Default
        ELSE 'Середній рівень' -- Average
    END AS student_status_tier

FROM Students s
LEFT JOIN AcademicStats acad ON s.student_id = acad.student_id
LEFT JOIN AttendanceStats att ON s.student_id = att.student_id
ORDER BY 
    student_class, 
    gpa DESC;