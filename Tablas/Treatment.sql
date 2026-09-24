CREATE TABLE Treatment (
    idTreatment NUMBER(8),
    diseaseId NUMBER(8), --FK
    name VARCHAR(50)
);

ALTER TABLE Treatment
    ADD CONSTRAINT treatmentPk PRIMARY KEY (idTreatment)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Treatment
    ADD CONSTRAINT treatmentXDiseaseFK FOREIGN KEY (diseaseId) 
    REFERENCES Disease(idDisease);