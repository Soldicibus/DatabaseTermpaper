-- =================================================================================================
-- VIEW PRIVILEGES SCRIPT
-- Grants access to views for specific roles
-- =================================================================================================

-- =================================================================================================
-- TEACHER ROLE
-- =================================================================================================
-- Analytical and Class Management Views
GRANT SELECT ON vw_class_attendance_last_month TO teacher;
GRANT SELECT ON vw_class_ranking TO teacher;
GRANT SELECT ON vw_student_perfomance_matrix TO teacher;
GRANT SELECT ON vw_students_by_class TO teacher;
GRANT SELECT ON vw_teacher_analytics TO teacher;
GRANT SELECT ON vw_teacher_class_students TO teacher;
GRANT SELECT ON vw_teachers_with_classes TO teacher;

-- Operational Views
GRANT SELECT ON vw_homework_by_student_or_class TO teacher;
GRANT SELECT ON vw_homework_tomorrow TO teacher;
GRANT SELECT ON vw_view_timetable_week TO teacher;

-- Security Defining Views (Profile & Data Access)
GRANT SELECT ON vws_class_schedule TO teacher;
GRANT SELECT ON vws_full_journal TO teacher;
GRANT SELECT ON vws_teacher_profile TO teacher;
GRANT SELECT ON vws_student_profile TO teacher;

-- Base Views (Replaces vws_base_tables)
GRANT SELECT ON vws_users TO teacher;
GRANT SELECT ON vws_roles TO teacher;
GRANT SELECT ON vws_user_roles TO teacher;
GRANT SELECT ON vws_teachers TO teacher;
GRANT SELECT ON vws_subjects TO teacher;
GRANT SELECT ON vws_materials TO teacher;
GRANT SELECT ON vws_journals TO teacher;
GRANT SELECT ON vws_days TO teacher;
GRANT SELECT ON vws_classes TO teacher;
GRANT SELECT ON vws_timetables TO teacher;
GRANT SELECT ON vws_lessons TO teacher;
GRANT SELECT ON vws_homeworks TO teacher;
GRANT SELECT ON vws_students TO teacher;
GRANT SELECT ON vws_parents TO teacher;
GRANT SELECT ON vws_student_parents TO teacher;
GRANT SELECT ON vws_student_data TO teacher;

-- =================================================================================================
-- STUDENT ROLE
-- =================================================================================================
-- Operational Views
GRANT SELECT ON vw_homework_by_student_or_class TO student;
GRANT SELECT ON vw_homework_tomorrow TO student;
GRANT SELECT ON vw_view_timetable_week TO student;
GRANT SELECT ON vw_students_by_class TO student; -- Can see classmates

-- Performance Views (Usually filtered by RLS or view logic to own data)
GRANT SELECT ON vw_student_perfomance_matrix TO student;

-- Security Defining Views
GRANT SELECT ON vws_class_schedule TO student;
GRANT SELECT ON vws_student_profile TO student;
GRANT SELECT ON vws_full_journal TO student; -- Assuming view handles visibility

-- =================================================================================================
-- PARENT ROLE
-- =================================================================================================
-- Operational Views
GRANT SELECT ON vw_homework_by_student_or_class TO parent;
GRANT SELECT ON vw_homework_tomorrow TO parent;
GRANT SELECT ON vw_view_timetable_week TO parent;

-- Performance Views
GRANT SELECT ON vw_student_perfomance_matrix TO parent;

-- Security Defining Views
GRANT SELECT ON vws_class_schedule TO parent;
GRANT SELECT ON vws_student_profile TO parent;
GRANT SELECT ON vws_full_journal TO parent;

-- =================================================================================================
-- GUEST ROLE
-- =================================================================================================
-- Public Information
GRANT SELECT ON vw_teachers_with_classes TO guest;
GRANT SELECT ON vw_view_timetable_week TO guest;

-- =================================================================================================
-- ADMIN / SADMIN (Full Access)
-- =================================================================================================
GRANT SELECT ON ALL TABLES IN SCHEMA public TO admin;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO sadmin;

-- Grant access to auth info only to admins
GRANT SELECT ON vws_user_auth_info TO admin;
GRANT SELECT ON vws_user_auth_info TO sadmin;
