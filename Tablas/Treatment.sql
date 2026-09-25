CREATE TABLE Treatment (
    id NUMBER(8) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    diseaseId NUMBER(8) NOT NULL, --FK
    name VARCHAR2(50) NOT NULL
);

ALTER TABLE Treatment
    ADD CONSTRAINT treatmentPk PRIMARY KEY (idTreatment)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Treatment
    ADD CONSTRAINT treatmentXDiseaseFK FOREIGN KEY (diseaseId) 
    REFERENCES Disease(idDisease);