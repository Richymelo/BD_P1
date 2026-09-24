CREATE TABLE Adoption (
    idAdoption NUMBER(8),
    rating NUMBER(8),
    date DATE,
    notes VARCHAR(50),
    givePersonId NUMBER(8), --FK
    adopterId NUMBER(8), --FK
    petId NUMBER(8) --FK
);

ALTER TABLE Adoption
    ADD CONSTRAINT adoptionPk PRIMARY KEY (idAdoption)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Adoption
    ADD CONSTRAINT adoptionXPersonFK FOREIGN KEY (givePersonId) 
    REFERENCES Person(idPerson);

ALTER TABLE Adoption
    ADD CONSTRAINT adoptionXAdopterFK FOREIGN KEY (AdopterId) 
    REFERENCES Adopter(idAdopter);

ALTER TABLE Adoption
    ADD CONSTRAINT adoptionXPetFK FOREIGN KEY (petId) 
    REFERENCES Pet(idPet);