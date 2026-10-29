CREATE TABLE Log (
    id NUMBER(8) NOT NULL,
    affectedTable VARCHAR2(50) NOT NULL,
    affectedSlot VARCHAR2(50) NOT NULL,
    lastValue VARCHAR2(500) NOT NULL,
    newValue VARCHAR2(500) NOT NULL,
    logDate DATE NOT NULL,
    operationType VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) ,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    modifiedBy VARCHAR2(50),
    modifiedAt TIMESTAMP(6),
    userId NUMBER(8) NOT NULL --FK
);

ALTER TABLE Log
    ADD CONSTRAINT logPk PRIMARY KEY (id)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Log
    ADD CONSTRAINT logXUserFK FOREIGN KEY (userId) 
    REFERENCES AppUser(id);
    
