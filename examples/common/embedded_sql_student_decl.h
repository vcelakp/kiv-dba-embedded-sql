/* common/embedded_sql_student_decl.h */

EXEC SQL DECLARE embedded_sql_student TABLE
(
    student_id NUMBER        NOT NULL,
    name  VARCHAR2(100) NOT NULL,
    city       VARCHAR2(50)  NOT NULL,
    grade      NUMBER(3,1),
    note       VARCHAR2(100)
);
