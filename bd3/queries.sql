-- Drop tables previous tables

DROP TABLE visits;
DROP TABLE doctors;
DROP TABLE patients;
DROP TABLE drugs;
DROP TABLE diagnoses;


-- Create tables

CREATE TABLE patients
(
    id       INTEGER PRIMARY KEY AUTOINCREMENT,
    name     TEXT    NOT NULL,
    is_male  BOOLEAN NOT NULL,
    birthday DATE    NOT NULL,
    address  TEXT    NOT NULL
);

CREATE TABLE doctors
(
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE drugs
(
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT NOT NULL,
    method       TEXT NOT NULL,
    description  TEXT NOT NULL,
    side_effects TEXT NOT NULL
);

CREATE TABLE diagnoses
(
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE visits
(
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER REFERENCES patients (id)  NOT NULL,
    doctor_id  INTEGER REFERENCES doctors (id)   NOT NULL,
    begin_dt   DATETIME                          NOT NULL,
    end_dt     DATETIME                          NOT NULL,
    place      TEXT                              NULL, -- null means at hospital
    symptoms   TEXT                              NULL,
    diagnosis  INTEGER REFERENCES diagnoses (id) NULL,
    drug_id    INTEGER REFERENCES drugs (id)     NULL
);

-- Insert values

INSERT INTO patients (name, is_male, birthday, address)
VALUES ('Иванов И.И.', true, '02.04.1987', 'Иванова 2'),
       ('Надоедыч Н.Н', true, '14.01.1967', 'Надоедова 23'),
       ('Пупкин В.В.', true, '23.03.1992', 'Пупкина 15'),
       ('Женщина Ж.Ж.', false, '01.01.1951', 'Женская 51');

INSERT INTO doctors (name)
VALUES ('Гиппократова Г.Г.'),
       ('Шприцева Ш.Ш.');

INSERT INTO drugs (name, method, description, side_effects)
VALUES ('Болеутолин 3%', 'внутренний', 'Снимает боль', 'Наркотическая зависимость'),
       ('Поспибро 100мг', 'внутренний', 'Снотворное', 'Наркотическая зависимость'),
       ('Вкуснопахнин', 'внешний', 'Мазь успокаивающая', 'Чувство холода'),
       ('Алкобухлин 3%', 'внутренний', 'Сироп от кашля', 'Алкогольная зависимость');

INSERT INTO diagnoses (name)
VALUES ('Открытый перелом'),
       ('Лунатизм'),
       ('Воспаление колена'),
       ('Простуда');

INSERT INTO visits (patient_id, doctor_id, begin_dt, end_dt, place, symptoms, diagnosis, drug_id)
VALUES (1, 2, '2019-01-04 14:30', '2019-01-04 14:40', 'Иванова 2', 'Болит нога', 1, 1),
       (3, 1, '2019-01-12 12:30', '2019-01-12 12:40', null, 'Бьет жену', 2, 2),
       (1, 2, '2019-01-15 12:30', '2019-01-15 12:40', 'Иванова 2', 'Ноет нога', 3, 3),
       (3, 2, '2019-01-22 12:00', '2019-01-22 12:07', null, 'Болит горло', 4, 4),
       (4, 1, '2019-01-25 12:00', '2019-01-25 12:10', null, 'Насморк', 4, 4),
       (2, 1, '2019-02-01 12:00', '2019-02-01 12:30', 'Надоедова 23', 'Течет кровь из руки', 1, 1),
       (2, 1, '2019-02-12 12:00', '2019-02-14 12:18', 'Надоедова 23', 'Болит рука', 3, 3),
       (2, 2, '2019-02-21 12:00', '2019-02-21 12:18', 'Надоедова 23', 'Резкая боль', 3, 3);

-- Selects

-- #1
-- Вывести данные о всех приемах (дату, продолжительность приема в минутах,
-- место осмотра, данные врача, данные пациента), которые были проведены между
-- датами 01.01.19 и 20.02.19 (привести два варианта решения задачи)

SELECT id,
       patient_id,
       doctor_id,
       date(begin_dt)             as date,
       timediff(end_dt, begin_dt) as duration,
       place,
       symptoms,
       diagnosis,
       drug_id
FROM visits
WHERE '2019-01-01' < begin_dt
  AND end_dt < '2019-02-20';

-- #2
-- Вывести названия всех лекарств, у которых в названии присутствует “3%”

SELECT name
FROM drugs
WHERE instr(name, '3%');

-- #3
-- Вывести данные о врачах, обслуживших максимальное количество пациентов на дому

SELECT name, count
FROM doctors
         JOIN (SELECT doctor_id, count
               FROM (select doctor_id, COUNT(*) as count
                     FROM visits
                     GROUP BY doctor_id)
               LIMIT 1) ON doctor_id = doctors.id;


-- SELECT name, count
-- FROM doctors
--          LEFT JOIN (SELECT doctor_id, count
--                     FROM (select doctor_id, COUNT(*) as count
--                           FROM visits
--                           GROUP BY doctor_id)
--                     WHERE count = (SELECT max(count)
--                                    from (select COUNT(*) as count
--                                          FROM visits
--                                          GROUP BY doctor_id))) ON doctor_id = doctors.id

-- #4
-- Для каждого врача подсчитать общее время обслуживания пациентов в госпитале

SELECT name, common_time
FROM doctors
         JOIN (SELECT doctor_id, common_time
               FROM (select doctor_id, SUM(julianday(end_dt) - julianday(begin_dt)) as common_time
                     FROM visits
                     GROUP BY doctor_id)) ON doctor_id = doctors.id;
