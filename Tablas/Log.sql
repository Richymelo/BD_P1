CREATE TABLE Log (
    idLog NUMBER(8),
    affectedTable VARCHAR(50),
    affectedSlot VARCHAR(50),
    lastValue VARCHAR(50),
    newValue VARCHAR(50),
    date DATE,
    operationType VARCHAR(50),
    userId NUMBER(8) --FK
);

ALTER TABLE Log
    ADD CONSTRAINT logPk PRIMARY KEY (idLog)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Log
    ADD CONSTRAINT logXUserFK FOREIGN KEY (userId) 
    REFERENCES User(idUser);