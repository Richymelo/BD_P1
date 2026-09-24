CREATE TABLE FosterHome (
    idFosterHome NUMBER(8),
    name VARCHAR(50),
    requiresFood VARCHAR(50),
    userId NUMBER(8) --FK
);

ALTER TABLE FosterHome
    ADD CONSTRAINT fosterHomePk PRIMARY KEY (idFosterHome)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE FosterHome
    ADD CONSTRAINT fosterHomeXUserFK FOREIGN KEY (userId) 
    REFERENCES User(idUser);