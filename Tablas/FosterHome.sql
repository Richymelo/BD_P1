CREATE TABLE FosterHome (
    id NUMBER(8) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    requiresFood VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    userId NUMBER(8) NOT NULL --FK
);

ALTER TABLE FosterHome
    ADD CONSTRAINT fosterHomePk PRIMARY KEY (idFosterHome)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE FosterHome
    ADD CONSTRAINT fosterHomeXUserFK FOREIGN KEY (userId) 
    REFERENCES User(idUser);