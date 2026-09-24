CREATE TABLE Breed (
    idBreed NUMBER(8),
    petTypeId NUMBER(8), --FK
    name VARCHAR(50)
);

ALTER TABLE Breed
    ADD CONSTRAINT breedPk PRIMARY KEY (idBreed)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Breed
    ADD CONSTRAINT breedXPetTypeFK FOREIGN KEY (petTypeId) 
    REFERENCES PetType(idPetType);