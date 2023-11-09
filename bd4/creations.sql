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


INSERT INTO universities(id, name, rating, place)
VALUES (1, 'Belarusian State University', 9.8, 'Minsk'),
       (2, 'Gomel State University', 8.8, 'Gomel'),
       (3, 'Yanka Kupala State University of Grodno', 8.5, 'Grodno'),
       (4, 'Belarusian State University of Informatics and Radioelectronics', 8.2, 'Minsk'),
       (5, 'Brest state technical university', 6.6, 'Brest');


