-- Base views for all tables to be used in procedures
CREATE OR REPLACE VIEW vws_users AS SELECT user_id, username, email FROM Users; -- Exclude password hash for security
CREATE OR REPLACE VIEW vws_roles AS SELECT * FROM Roles;
CREATE OR REPLACE VIEW vws_user_roles AS SELECT * FROM UserRole;
CREATE OR REPLACE VIEW vws_teachers AS SELECT * FROM Teacher;
CREATE OR REPLACE VIEW vws_subjects AS SELECT * FROM Subjects;
CREATE OR REPLACE VIEW vws_materials AS SELECT * FROM Material;
CREATE OR REPLACE VIEW vws_journals AS SELECT * FROM Journal;
CREATE OR REPLACE VIEW vws_days AS SELECT * FROM Days;
CREATE OR REPLACE VIEW vws_classes AS SELECT * FROM Class;
CREATE OR REPLACE VIEW vws_timetables AS SELECT * FROM Timetable;
CREATE OR REPLACE VIEW vws_lessons AS SELECT * FROM Lessons;
CREATE OR REPLACE VIEW vws_homeworks AS SELECT * FROM Homework;
CREATE OR REPLACE VIEW vws_students AS SELECT * FROM Students;
CREATE OR REPLACE VIEW vws_parents AS SELECT * FROM Parents;
CREATE OR REPLACE VIEW vws_student_parents AS SELECT * FROM StudentParent;
CREATE OR REPLACE VIEW vws_student_data AS SELECT * FROM StudentData;
CREATE OR REPLACE VIEW vws_audits AS SELECT * FROM AuditLog;
