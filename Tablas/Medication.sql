CREATE TABLE Medication (
    idMedication NUMBER(8),
    treatmentId NUMBER(8), --FK
    name VARCHAR(50)
);

ALTER TABLE Medication
    ADD CONSTRAINT medicationPk PRIMARY KEY (idMedication)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Medication
    ADD CONSTRAINT medicationXTreatmentFK FOREIGN KEY (treatmentId) 
    REFERENCES Treatment(idTreatment);