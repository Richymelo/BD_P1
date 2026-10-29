CREATE TABLE Pet (
    id NUMBER(8) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    chipId VARCHAR2(50),
    dateOfBirth DATE,
    age NUMBER(8) NOT NULL,
    eventDate DATE NOT NULL,
    rewardAmount NUMBER(8),
    needsSpace VARCHAR2(50),
    place VARCHAR2(50),
    description VARCHAR2(50),
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    districtId NUMBER(8) NOT NULL, --FK
    breedId NUMBER(8) NOT NULL, --FK
    statusId NUMBER(8) NOT NULL, --FK
    colorId NUMBER(8) NOT NULL, --FK
    sizeId NUMBER(8) NOT NULL, --FK
    energyLevelId NUMBER(8) NOT NULL, --FK
    trainabilityId NUMBER(8) NOT NULL, --FK
    veterinarianId NUMBER(8), --FK
    diseaseId NUMBER(8), --FK
    fosterHomeId NUMBER(8), --FK
    rescuerId NUMBER(8), --FK
    severityId NUMBER(8) --FK
);



ALTER TABLE Pet
    ADD CONSTRAINT petPk PRIMARY KEY (id)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Pet
    ADD CONSTRAINT petXDistrictFK FOREIGN KEY (districtId) 
    REFERENCES District(id);

ALTER TABLE Pet
    ADD CONSTRAINT petXBreedFK FOREIGN KEY (breedId) 
    REFERENCES Breed(id);

ALTER TABLE Pet
    ADD CONSTRAINT petXStatusFK FOREIGN KEY (statusId) 
    REFERENCES Status(id);

ALTER TABLE Pet
    ADD CONSTRAINT petXColorFK FOREIGN KEY (colorId) 
    REFERENCES Color(id);

ALTER TABLE Pet
    ADD CONSTRAINT petXSizeFK FOREIGN KEY (sizeId) 
    REFERENCES PetSize(id);

ALTER TABLE Pet
    ADD CONSTRAINT petXEnergyLevelFK FOREIGN KEY (energyLevelId) 
    REFERENCES EnergyLevel(id);

ALTER TABLE Pet
    ADD CONSTRAINT petXTrainabilityFK FOREIGN KEY (trainabilityId) 
    REFERENCES Trainability(id);

ALTER TABLE Pet
    ADD CONSTRAINT petXVeterinarianFK FOREIGN KEY (veterinarianId) 
    REFERENCES Veterinarian(userId);

ALTER TABLE Pet
    ADD CONSTRAINT petXDiseaseFK FOREIGN KEY (diseaseId) 
    REFERENCES Disease(id);

ALTER TABLE Pet
    ADD CONSTRAINT petXFosterHomeFK FOREIGN KEY (fosterHomeId) 
    REFERENCES FosterHome(id);

ALTER TABLE Pet
    ADD CONSTRAINT petXRescuerFK FOREIGN KEY (rescuerId) 
    REFERENCES Rescuer(userId);

ALTER TABLE Pet
    ADD CONSTRAINT petXSeverityFK FOREIGN KEY (severityId) 
    REFERENCES Severity(id);