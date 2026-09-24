CREATE TABLE Pet (
    idPet NUMBER(8),
    name VARCHAR(50),
    chipId VARCHAR(50),
    dateOfBirth DATE,
    age NUMBER(8),
    date DATE,
    rewardAmount NUMBER(8),
    needsSpace VARCHAR(50),
    place VARCHAR(50),
    description VARCHAR(50),
    districtId NUMBER(8), --FK
    breedId NUMBER(8), --FK
    stateId NUMBER(8), --FK
    colorId NUMBER(8), --FK
    sizeId NUMBER(8), --FK
    energyLevelId NUMBER(8), --FK
    trainabilityId NUMBER(8), --FK
    veterinarianId NUMBER(8), --FK
    diseaseId NUMBER(8), --FK
    fosterHomeId NUMBER(8), --FK
    rescuerId NUMBER(8), --FK
    severityId NUMBER(8) --FK
);

ALTER TABLE Pet
    ADD CONSTRAINT petPk PRIMARY KEY (idPet)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Pet
    ADD CONSTRAINT petXDistrictFK FOREIGN KEY (districtId) 
    REFERENCES District(idDistrict);

ALTER TABLE Pet
    ADD CONSTRAINT petXBreedFK FOREIGN KEY (breedId) 
    REFERENCES Breed(idBreed);

ALTER TABLE Pet
    ADD CONSTRAINT petXStateFK FOREIGN KEY (stateId) 
    REFERENCES State(idState);

ALTER TABLE Pet
    ADD CONSTRAINT petXColorFK FOREIGN KEY (colorId) 
    REFERENCES Color(idColor);

ALTER TABLE Pet
    ADD CONSTRAINT petXSizeFK FOREIGN KEY (sizeId) 
    REFERENCES Size(idSize);

ALTER TABLE Pet
    ADD CONSTRAINT petXEnergyLevelFK FOREIGN KEY (energyLevelId) 
    REFERENCES EnergyLevel(idEnergyLevel);

ALTER TABLE Pet
    ADD CONSTRAINT petXTrainabilityFK FOREIGN KEY (trainabilityId) 
    REFERENCES Trainability(idTrainability);

ALTER TABLE Pet
    ADD CONSTRAINT petXVeterinarianFK FOREIGN KEY (veterinarianId) 
    REFERENCES Veterinarian(personId);

ALTER TABLE Pet
    ADD CONSTRAINT petXDiseaseFK FOREIGN KEY (diseaseId) 
    REFERENCES Disease(idDisease);

ALTER TABLE Pet
    ADD CONSTRAINT petXFosterHomeFK FOREIGN KEY (fosterHomeId) 
    REFERENCES FosterHome(idFosterHome);

ALTER TABLE Pet
    ADD CONSTRAINT petXRescuerFK FOREIGN KEY (rescuerId) 
    REFERENCES Rescuer(personId);

ALTER TABLE Pet
    ADD CONSTRAINT petXSeverityFK FOREIGN KEY (severityId) 
    REFERENCES Severity(idSeverity);