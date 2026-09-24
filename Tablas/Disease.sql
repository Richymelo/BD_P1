CREATE TABLE Disease (
    idDisease NUMBER(8),
    name VARCHAR(50)
);

ALTER TABLE Disease
    ADD CONSTRAINT diseasePk PRIMARY KEY (idDisease)
    USING INDEX TABLESPACE GEIndex;