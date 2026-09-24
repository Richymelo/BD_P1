CREATE TABLE Trainability (
    idTrainability NUMBER(8),
    name VARCHAR(50)
);

ALTER TABLE Trainability
    ADD CONSTRAINT trainabilityPk PRIMARY KEY (idTrainability)
    USING INDEX TABLESPACE GEIndex;