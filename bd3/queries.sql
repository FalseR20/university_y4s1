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
VALUES ('Иванов И.И.', true, '1987-04-02', 'Иванова 2'),
       ('Надоедыч Н.Н', true, '1967-01-14', 'Надоедова 23'),
       ('Пупкин В.В.', true, '1992-03-23', 'Пупкина 15'),
       ('Женщина Ж.Ж.', false, '1922-01-01', 'Женская 51');

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
       ('Простуда'),
       ('Фанат КиШа');

INSERT INTO visits (patient_id, doctor_id, begin_dt, end_dt, place, symptoms, diagnosis, drug_id)
VALUES (1, 2, '2019-01-04 14:30', '2019-01-04 14:40', 'Иванова 2', 'Болит нога', 1, 1),
       (3, 1, '2019-01-12 12:30', '2019-01-12 12:40', null, 'Бьет жену', 2, 2),
       (1, 2, '2019-01-15 12:30', '2019-01-15 12:40', 'Иванова 2', 'Ноет нога', 3, 3),
       (3, 2, '2019-01-22 12:00', '2019-01-22 12:07', null, 'Болит горло', 4, 4),
       (4, 1, '2019-01-25 12:00', '2019-01-25 12:10', null, 'Насморк', 4, 4),
       (2, 1, '2019-02-01 12:00', '2019-02-01 12:30', 'Надоедова 23', 'Течет кровь из руки', 1, 1),
       (2, 1, '2019-02-14 12:00', '2019-02-14 12:18', 'Надоедова 23', 'Болит рука', 3, 3),
       (2, 2, '2019-02-21 12:00', '2019-02-21 12:18', 'Надоедова 23', 'Резкая боль', 3, 3);

-- Selects

-- #1
-- Вывести данные о всех приемах (дату, продолжительность приема в минутах,
-- место осмотра, данные врача, данные пациента), которые были проведены между
-- датами 01.01.19 и 20.02.19 (привести два варианта решения задачи)

SELECT p.name                                                     as patient_name,
       d.name                                                     as doctor_name,
       date(begin_dt)                                             as date,
       timediff(end_dt, begin_dt)                                 as duration,
       round((JULIANDAY(end_dt) - JULIANDAY(begin_dt)) * 24 * 60) as duration_min,
       place
FROM visits
         JOIN patients p on p.id = visits.patient_id
         JOIN doctors d on d.id = visits.doctor_id
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

-- #4
-- Для каждого врача подсчитать общее время обслуживания пациентов в госпитале

SELECT name, common_time_min
FROM doctors
         JOIN (SELECT doctor_id, common_time_min
               FROM (select doctor_id,
                            SUM(round((JULIANDAY(end_dt) - JULIANDAY(begin_dt)) * 24 * 60)) as common_time_min
                     FROM visits
                     GROUP BY doctor_id)) ON doctor_id = doctors.id;

-- #5
--  Вывести диагнозы, которые не были поставлены ни одним врачом

SELECT name, 0 as count
FROM diagnoses
WHERE id NOT IN (SELECT diagnosis
                 FROM visits
                 GROUP BY diagnosis);

-- #6
-- В запросе для каждого врача подсчитать и вывести, начиная с даты 01.01.19,
-- количество пациентов каждого пола, а также количество пациентов, обслуженных не в госпитале

SELECT d.name,
       count(p.id)              as patient_count,
       sum(p.is_male)           as male_count,
       sum(not (p.is_male))     as female_count,
       sum(v.place IS NOT NULL) as at_home_count
FROM visits v
         JOIN patients p on p.id = v.patient_id
         JOIN doctors d on d.id = v.doctor_id
WHERE v.begin_dt > '2019-01-01'
GROUP BY d.id;

-- #7
-- Написать запрос, выводящий для каждого диагноза количество пациентов,
-- название самого диагноза, а также средний возраст пациентов диагноза

SELECT d.name,
       COUNT(p.id)                                                       as patient_count,
       round(floor((JULIANDAY('now') - JULIANDAY(p.birthday)) / 365.25)) as average_age
FROM diagnoses d
         JOIN visits v on d.id = v.diagnosis
         JOIN patients p on p.id = v.patient_id
GROUP BY d.id;

-- #8
-- Вывести данные о врачах, у которых существует хотя бы один пациент старше 100 лет

SELECT d.name, p.name, floor((JULIANDAY('now') - JULIANDAY(p.birthday)) / 365.25) as age
FROM doctors d
         JOIN visits v on d.id = v.doctor_id
         JOIN patients p on p.id = v.patient_id
WHERE age > 100
GROUP BY d.id;

-- #9
-- Вывести данные о самых молодых пациентах, которым прописано максимальное количество лекарств.

SELECT p.name, floor((JULIANDAY('now') - JULIANDAY(p.birthday)) / 365.25) as age, count(d.id) as drugs_count
FROM patients p
         JOIN visits v on p.id = v.patient_id
         JOIN drugs d on d.id = v.drug_id
-- WHERE not (p.is_male)
GROUP BY p.id
ORDER BY age, drugs_count;

-- #10
-- Вывести данные о пациентах, о которых точно известно, что они никогда не
-- обслуживались дома.

SELECT name, count_at_home
FROM (SELECT p.name, SUM(v.place IS NOT NULL) as count_at_home
      FROM patients p
               JOIN visits v on p.id = v.patient_id
      GROUP BY p.id)
WHERE count_at_home = 0;

-- #11
-- Для каждого врача вывести в минутах среднее время приёма,
-- данные отсортировать по убыванию значений среднего времени приема

SELECT name, avg_time_min
FROM doctors
         JOIN (SELECT doctor_id, avg_time_min
               FROM (select doctor_id,
                            avg(round((JULIANDAY(end_dt) - JULIANDAY(begin_dt)) * 24 * 60)) as avg_time_min
                     FROM visits
                     GROUP BY doctor_id)) ON doctor_id = doctors.id
ORDER BY avg_time_min;
