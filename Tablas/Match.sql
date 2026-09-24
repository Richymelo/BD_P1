CREATE TABLE Match (
    idMatch NUMBER(8),
    percentaje NUMBER(8),
    date DATE,
    lostPetId NUMBER(8), --FK
    foundPetId NUMBER(8) --FK
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