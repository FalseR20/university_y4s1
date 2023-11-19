CREATE TABLE Контрагенты
(
    КодКонтраг  INTEGER PRIMARY KEY,
    НаимКонтраг TEXT NOT NULL
);

CREATE TABLE МестаХранения
(
    КодМестаХран  INTEGER PRIMARY KEY,
    НаимМестаХран TEXT NOT NULL,
    АдрМестаХран  TEXT NOT NULL
);

CREATE TABLE Должности
(
    КодДолжн  INTEGER PRIMARY KEY,
    НаимДолжн TEXT NOT NULL
);

CREATE TABLE Сотрудники
(
    КодСотруд  INTEGER PRIMARY KEY,
    НаимСотруд TEXT    NOT NULL,
    КодДолжн   INTEGER NOT NULL REFERENCES Должности
);


CREATE TABLE РеализацияТовара
(
    КодРеализТов INTEGER PRIMARY KEY,
    КодКонтраг   INTEGER NOT NULL REFERENCES Контрагенты,
    КодСотруд    INTEGER NOT NULL REFERENCES Сотрудники,
    Дата         DATE    NOT NULL,
    КодМестаХран INTEGER NOT NULL REFERENCES МестаХранения
);

CREATE TABLE ПеремещениеМежСкладами
(
    КодПеремещМежСклад INTEGER PRIMARY KEY,
    КодКонтраг         INTEGER NOT NULL REFERENCES Контрагенты,
    КодСотруд          INTEGER NOT NULL REFERENCES Сотрудники,
    Дата               DATE    NOT NULL,
    КодМестаХран       INTEGER NOT NULL REFERENCES МестаХранения,
    ФИОПринял          TEXT    NOT NULL,
    ФИОСдал            TEXT    NOT NULL
);


CREATE TABLE ЕдиницаХранения
(
    КодЕдХран INTEGER PRIMARY KEY,
    ЕдХран    TEXT NOT NULL
);


CREATE TABLE Номенклатура
(
    КодТовара   INTEGER PRIMARY KEY,
    НаимТовара  TEXT NOT NULL,
    ПроизводТов TEXT NOT NULL,
    Описание    TEXT NOT NULL
);


CREATE TABLE РеализацияТовара_ТаблЧасть
(
    Код          INTEGER PRIMARY KEY,
    КодТовара    INTEGER NOT NULL REFERENCES Номенклатура,
    КодЕдХран    INTEGER NOT NULL REFERENCES ЕдиницаХранения,
    КодРеализТов INTEGER NOT NULL REFERENCES РеализацияТовара,
    Цена         MONEY   NOT NULL,
    Стоимость    MONEY   NOT NULL,
    Колво        INTEGER NOT NULL
);


CREATE TABLE ПеремещениеМежСкладами_ТаблЧасть
(
    Код                INTEGER PRIMARY KEY,
    КодПеремещМежСклад INTEGER NOT NULL REFERENCES ПеремещениеМежСкладами,
    КодЕдХранения      INTEGER NOT NULL REFERENCES ЕдиницаХранения,
    КодТовара          INTEGER NOT NULL REFERENCES Номенклатура,
    Колво              INTEGER NOT NULL,
    Цена               MONEY   NOT NULL,
    Стоимость          MONEY   NOT NULL
);
