/* common/esql_student_decl.h */

EXEC SQL DECLARE esql_student TABLE
(
    student_id NUMBER        NOT NULL,
    full_name  VARCHAR2(100) NOT NULL,
    city       VARCHAR2(50)  NOT NULL,
    grade      NUMBER(3,1),
    note       VARCHAR2(100)
);
