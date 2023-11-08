-- 1.
-- Написать команду, которая вводит в таблицу SUBJECT строку для нового предмета обучения под названием “Алгебра”.
-- Читается этот предмет в четвертом семестре, отводится на него 72 часа, ID этого предмета 201.

INSERT INTO subjects (id, name, time, semester, university_id)
VALUES (201, 'Алгебра', 72, 4, 1);

-- 2.
-- Напишите команду, которая увеличивает на 5% значения всех рейтингов университетов,
-- в которых учатся более 1000 студентов.

UPDATE universities
SET rating = rating * 1.05
WHERE id IN
      (SELECT university_id
       FROM students
       GROUP BY university_id
       HAVING COUNT(*) > 1000);

-- 3. Напишите команду, удаляющую записи обо всех оценках студентов, среднее значение оценок которых ниже тройки

delete
from exam_notes
where exam_notes.student_id in
      (select student_id
       from exam_notes
       group by student_id
       having avg(note) < 3);

-- 4.
-- Создать представление, позволяющее следить на каждый день сдачи экзаменов за количеством сданных экзаменов,
-- количеством студентов, сдавших эти экзамены и средним баллом

-- CREATE VIEW CHECK_EXAMS
-- AS
-- SELECT A.date,
--        A.subj                                                  subject,
--        CASE WHEN B.stud IS NULL THEN 0 ELSE B.avg_note END     students,
--        CASE WHEN B.avg_note IS NULL THEN 0 ELSE B.avg_note END note
-- FROM (SELECT date, COUNT(*) subj
--       FROM exam_notes
--       GROUP BY date) A
--          JOIN
--      (SELECT B.date, COUNT(*) stud, AVG(note) avg_note
--       FROM exam_notes B
--       WHERE note >= 4
--       GROUP BY B.date) B ON A.date = B.date;
--
-- SELECT *
-- FROM CHECK_EXAMS;


CREATE VIEW checks
AS
SELECT date,
       COUNT(subject_id) as subjects_count,
       COUNT(student_id) as students_count
FROM exam_notes
group by date;

-- 5. Создать представление, которое показывает имена и названия сданных предметов для каждого студента

CREATE VIEW exams_done
AS
SELECT s.firstname, sub.name
FROM exam_notes
         JOIN students s ON exam_notes.student_id = s.id
         JOIN subjects sub ON exam_notes.student_id = sub.id
WHERE note >= 4;

SELECT *
FROM exams_done;

-- 6. Создать представление, отображающее фамилию, имя, балл и дату получения оценки студентов,
-- имеющих самый высокий балл на каждую дату сдачи экзаменов

CREATE VIEW TASK6
AS
SELECT s.firstname, s.lastname, exam_notes.note, exam_notes.date
FROM exam_notes
         JOIN students s ON s.id = Student_id,
     (SELECT date, MAX(note) mark
      FROM exam_notes
      GROUP BY date) A
WHERE exam_notes.date = A.date
  AND exam_notes.note = A.mark;

SELECT *
FROM TASK6;

-- 7. На основе предыдущего представления, создать новое представление,
-- выводящее фамилии студентов, имеющих самый высокий балл как минимум 3 раза

CREATE VIEW TASK7
AS
SELECT s.lastname
FROM exam_notes
         JOIN students s ON s.id = exam_notes.student_id,
     (SELECT date, MAX(note) max_note
      FROM exam_notes
      GROUP BY date) A
WHERE exam_notes.date = A.date
  AND exam_notes.note = A.max_note
GROUP BY s.lastname
HAVING COUNT(*) >= 3;

SELECT *
FROM TASK7;

-- 8. Создать представление, выводящее фамилии, имена и стипендии студентов, имеющих величину стипендии в пределах
-- от 100 до 600, и позволяющее изменять и вводить значение стипендии только в этом интервале

CREATE VIEW task8
AS
SELECT firstname, lastname, stipend
FROM students
WHERE Stipend BETWEEN 100 AND 600;


SELECT *
FROM TASK8;
