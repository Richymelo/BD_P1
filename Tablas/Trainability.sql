CREATE TABLE Trainability (
    id NUMBER(8) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    name VARCHAR2(50) NOT NULL
);

ALTER TABLE Trainability
    ADD CONSTRAINT trainabilityPk PRIMARY KEY (idTrainability)
    USING INDEX TABLESPACE GEIndex;