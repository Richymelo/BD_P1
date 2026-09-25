CREATE TABLE AdoptionApplication (
    idAdoptionApplication NUMBER(8) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    date DATE NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    adopterId NUMBER(8) NOT NULL, --FK
    statusId NUMBER(8) NOT NULL --FK
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