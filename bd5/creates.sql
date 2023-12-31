CREATE TABLE UNIVERSITY
(
    Univ_id   SERIAL PRIMARY KEY,
    Univ_name TEXT  NOT NULL,
    Rating    FLOAT NOT NULL,
    City      TEXT  NOT NULL
);

CREATE TABLE STUDENTS
(
    Student_id SERIAL PRIMARY KEY,
    Surname    TEXT    NOT NULL,
    Name       TEXT    NOT NULL,
    Stipend    FLOAT   NOT NULL,
    Kurs       INTEGER NOT NULL,
    City       TEXT    NOT NULL,
    Birhday    DATE    NOT NULL,
    Univ_id    INTEGER NOT NULL REFERENCES UNIVERSITY ON DELETE CASCADE
);

CREATE TABLE LECTURER
(
    Lecturer_id SERIAL PRIMARY KEY,
    Surname     TEXT    NOT NULL,
    Name        TEXT    NOT NULL,
    City        TEXT    NOT NULL,
    Univ_id     INTEGER NOT NULL REFERENCES UNIVERSITY ON DELETE CASCADE
);

CREATE TABLE SUBJECT
(
    Subj_id   SERIAL PRIMARY KEY,
    Subj_name TEXT    NOT NULL,
    Hour      INTEGER NOT NULL,
    Semester  INTEGER NOT NULL
);

CREATE TABLE EXAM_MARKS
(
    Exam_id    SERIAL PRIMARY KEY,
    Student_id INTEGER NOT NULL REFERENCES Students ON DELETE CASCADE,
    Subj_id    INTEGER NOT NULL REFERENCES SUBJECT ON DELETE CASCADE,
    Mark       INTEGER NOT NULL,
    Exam_date  DATE    NOT NULL
);

CREATE TABLE SUBJ_LECT
(
    Lecture_id SERIAL PRIMARY KEY,
    Subj_id    INTEGER NOT NULL REFERENCES SUBJECT ON DELETE CASCADE
);
