CREATE TABLE Medication (
    id NUMBER(8) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    treatmentId NUMBER(8) NOT NULL, --FK
    name VARCHAR2(50) NOT NULL
);

ALTER TABLE Medication
    ADD CONSTRAINT medicationPk PRIMARY KEY (idMedication)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Medication
    ADD CONSTRAINT medicationXTreatmentFK FOREIGN KEY (treatmentId) 
    REFERENCES Treatment(idTreatment);