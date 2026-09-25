CREATE TABLE Match (
    id NUMBER(8) NOT NULL,
    percentaje NUMBER(8) NOT NULL,
    date DATE NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    lostPetId NUMBER(8) NOT NULL, --FK
    foundPetId NUMBER(8) NOT NULL --FK
);

ALTER TABLE Match
    ADD CONSTRAINT matchPk PRIMARY KEY (idMatch)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Match
    ADD CONSTRAINT matchXLostPetFK FOREIGN KEY (lostPetId) 
    REFERENCES Pet(idPet);

ALTER TABLE Match
    ADD CONSTRAINT matchXFoundPetFK FOREIGN KEY (foundPetId) 
    REFERENCES Pet(idPet);