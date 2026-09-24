CREATE TABLE AdoptionApplication (
    idAdoptionApplication NUMBER(8),
    name VARCHAR(50),
    date DATE,
    adopterId NUMBER(8), --FK
    statusId NUMBER(8) --FK
);

ALTER TABLE AdoptionApplication
    ADD CONSTRAINT adoptionApplicationPk PRIMARY KEY (idAdoptionApplication)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE AdoptionApplication
    ADD CONSTRAINT adoptionApplicationXAdopterFK FOREIGN KEY (AdopterId) 
    REFERENCES Adopter(idAdopter);

ALTER TABLE AdoptionApplication
    ADD CONSTRAINT adoptionApplicationXStatusFK FOREIGN KEY (statusId) 
    REFERENCES Status(idStatus);