CREATE TABLE Adoption (
    idAdoption NUMBER(8) NOT NULL,
    rating NUMBER(8) NOT NULL,
    date DATE NOT NULL,
    notes VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    givePersonId NUMBER(8) NOT NULL, --FK
    adopterId NUMBER(8) NOT NULL, --FK
    petId NUMBER(8) NOT NULL --FK
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