CREATE TABLE Person (
    id NUMBER(8) NOT NULL,
    firstName VARCHAR2(50) NOT NULL,
    secondName VARCHAR2(50) NOT NULL,
    firstSurname VARCHAR2(50) NOT NULL,
    secondSurname VARCHAR2(50) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    phone NUMBER(8) NOT NULL
);

ALTER TABLE Person
    ADD CONSTRAINT personPk PRIMARY KEY (idPerson)
    USING INDEX TABLESPACE GEIndex;