CREATE TABLE District (
    idDistrict NUMBER(8),
    cantonId NUMBER(8), --FK
    name VARCHAR(50)
);

ALTER TABLE District
    ADD CONSTRAINT districtPk PRIMARY KEY (idDistrict)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE District
    ADD CONSTRAINT districtXCantonFK FOREIGN KEY (cantonId) 
    REFERENCES Canton(idCanton);