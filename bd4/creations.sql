-- Drop tables previous tables

DROP TABLE universities;
DROP TABLE subjects;
DROP TABLE students;
DROP TABLE exam_notes;


-- Create tables

CREATE TABLE universities
(
    id     INTEGER PRIMARY KEY AUTOINCREMENT,
    name   TEXT    NOT NULL,
    rating INTEGER NOT NULL,
    place  TEXT    NOT NULL
);

CREATE TABLE subjects
(
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT    NOT NULL,
    time          INTEGER NOT NULL,
    semester      INTEGER NOT NULL,
    university_id INTEGER NOT NULL REFERENCES universities
);

CREATE TABLE students
(
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    firstname     TEXT    NOT NULL,
    lastname      TEXT    NOT NULL,
    stipend       REAL, -- 0 means stripped, NULL means he has not
    university_id INTEGER NOT NULL REFERENCES universities
);

CREATE TABLE exam_notes
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL REFERENCES students,
    subject_id INTEGER NOT NULL REFERENCES subjects,
    note       INTEGER NOT NULL,
    date       DATE    NOT NULL
);
