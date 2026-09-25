CREATE TABLE District (
    id NUMBER(8) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    cantonId NUMBER(8) NOT NULL, --FK
    name VARCHAR2(50) NOT NULL
);

ALTER TABLE District
    ADD CONSTRAINT districtPk PRIMARY KEY (idDistrict)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE District
    ADD CONSTRAINT districtXCantonFK FOREIGN KEY (cantonId) 
    REFERENCES Canton(idCanton);