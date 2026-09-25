CREATE TABLE Province (
    id NUMBER(8) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    countryId NUMBER(8) NOT NULL, --FK
    name VARCHAR2(50) NOT NULL
);

ALTER TABLE Province
    ADD CONSTRAINT provincePk PRIMARY KEY (idProvince)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Province
    ADD CONSTRAINT provinceXCountryFK FOREIGN KEY (countryId) 
    REFERENCES Country(idCountry);