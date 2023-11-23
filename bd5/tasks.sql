-- 1
CREATE
    OR REPLACE PROCEDURE task1()
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF TO_CHAR(current_date, 'MM') NOT BETWEEN '07' AND '08' THEN
        RAISE EXCEPTION 'Дата не входит в диапазон 1 июля - 31 августа.';
    END IF;

    UPDATE students
    SET Kurs = Kurs + 1;

    DELETE
    FROM students
    WHERE Kurs > 5;
END;
$$;

CALL task1();


-- 2
CREATE OR REPLACE PROCEDURE task2()
    LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE students
    SET stipend = stipend + stipend * 10 * (e.avg_mark - 5) / 100
    FROM (SELECT EM.student_id, AVG(EM.mark) AS avg_mark
          FROM exam_marks EM
          GROUP BY EM.student_id) e
    WHERE students.student_id = e.student_id;
END;
$$;


-- 3
CREATE OR REPLACE PROCEDURE task3(
    IN ID INT,
    INOUT FIO TEXT,
    INOUT Course INT,
    INOUT Stipendia NUMERIC,
    INOUT SrBall NUMERIC
)
AS
$$
DECLARE
    sb FLOAT;
BEGIN
    SELECT AVG(Mark)
    INTO sb
    FROM EXAM_MARKS
    WHERE Student_id = ID;

    SELECT Name || ' ' || Surname, Kurs, Stipend, sb
    INTO FIO, Course, Stipendia, SrBall
    FROM Students
    WHERE Student_id = ID;
END;
$$ LANGUAGE plpgsql;

DO
$$
    DECLARE
        fio       TEXT;
        kurs      INT;
        stipendia NUMERIC;
        srball    numeric;
    BEGIN
        CALL task3(1, fio, kurs, stipendia, srball);
        -- Выводим значения переменных на экран (можно закомментировать, если не нужно)
        RAISE NOTICE 'FIO %', fio;
        RAISE NOTICE 'Kurs %', kurs;
        RAISE NOTICE 'Stipendia %', stipendia;
        RAISE NOTICE 'Ball %', srball;
    END
$$;


-- 4
ALTER TABLE university
    ADD COLUMN comment TEXT NULL;

CREATE OR REPLACE PROCEDURE task4(
    p_univ_id INTEGER,
    p_univ_name TEXT,
    p_rating DOUBLE PRECISION,
    p_city TEXT
)
AS
$$
DECLARE
    p_comment TEXT;
BEGIN
    INSERT INTO University (Univ_id, Univ_name, Rating, City, Comment)
    VALUES (p_univ_id, p_univ_name, p_rating, p_city,
            CASE
                WHEN p_rating > 7 THEN 'Высокий'
                WHEN p_rating < 5 THEN 'Низкий'
                ELSE 'Средний'
                END)
    RETURNING Comment INTO p_comment;

    -- Выводим комментарий в консоль
    RAISE NOTICE 'Комментарий: %', p_comment;
END;
$$ LANGUAGE plpgsql;

-- Пример вызова хранимой процедуры
CALL task4(4, 'test', 6, 'test');
CALL task4(5, 'Good place', 10, 'Utopia');


-- 5
ALTER TABLE university
    ADD COLUMN IF NOT EXISTS students_count INTEGER NULL,
    ADD COLUMN IF NOT EXISTS avg_mark       NUMERIC NULL;


CREATE OR REPLACE FUNCTION task5_students_trigger_function()
    RETURNS trigger
AS
$$
BEGIN
    UPDATE university
    SET students_count = st.students_count
    FROM (SELECT s.univ_id, count(s.student_id) AS students_count
          FROM students s
          GROUP BY s.univ_id) st
    WHERE st.univ_id = university.univ_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER task5_trigger
    AFTER INSERT OR UPDATE OR DELETE
    ON students
    FOR EACH STATEMENT
EXECUTE FUNCTION task5_students_trigger_function();


CREATE OR REPLACE FUNCTION task5_exam_marks_trigger_function()
    RETURNS trigger
AS
$$
BEGIN
    UPDATE university
    SET avg_mark = st.avg_mark
    FROM (SELECT s.univ_id, avg(em.mark) AS avg_mark
          FROM students s
                   JOIN public.exam_marks em on s.student_id = em.student_id
          GROUP BY s.univ_id) st
    WHERE st.univ_id = university.univ_id;

    UPDATE university
    SET rating = ROUND(avg_mark);

    UPDATE university
    SET comment = CASE
                      WHEN rating > 7 THEN 'Высокий'
                      WHEN rating < 5 THEN 'Низкий'
                      ELSE 'Средний'
        END;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER task5_trigger
    AFTER INSERT OR UPDATE OR DELETE
    ON exam_marks
    FOR EACH STATEMENT
EXECUTE FUNCTION task5_exam_marks_trigger_function();
