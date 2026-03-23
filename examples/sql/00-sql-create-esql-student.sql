-- Common table for all Embedded SQL examples

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE esql_student PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE esql_student (
    student_id NUMBER PRIMARY KEY,
    full_name  VARCHAR2(100) NOT NULL,
    city       VARCHAR2(50)  NOT NULL,
    grade      NUMBER(3,1),
    note       VARCHAR2(100)
);

INSERT INTO esql_student (student_id, full_name, city, grade, note)
VALUES (1, 'Alice', 'Praha', 1.5, 'excellent');

INSERT INTO esql_student (student_id, full_name, city, grade, note)
VALUES (2, 'Bob', 'Brno', 2.0, NULL);

INSERT INTO esql_student (student_id, full_name, city, grade, note)
VALUES (3, 'Tomas', 'Ostrava', NULL, 'needs topic');

INSERT INTO esql_student (student_id, full_name, city, grade, note)
VALUES (4, 'Jana', 'Brno', 2.7, NULL);

COMMIT;
