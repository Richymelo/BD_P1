CREATE TABLE Person (
    idPerson NUMBER(8),
    firstName VARCHAR(50),
    secondName VARCHAR(50),
    firstSurname VARCHAR(50),
    secondSurname VARCHAR(50),
    email VARCHAR(50),
    phone NUMBER(8)
);

ALTER TABLE Person
    ADD CONSTRAINT personPk PRIMARY KEY (idPerson)
    USING INDEX TABLESPACE GEIndex;