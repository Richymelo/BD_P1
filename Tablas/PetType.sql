CREATE TABLE PetType (
    idPetType NUMBER(8),
    name VARCHAR(50)
);

ALTER TABLE PetType
    ADD CONSTRAINT petTypePk PRIMARY KEY (idPetType)
    USING INDEX TABLESPACE GEIndex;