CREATE TABLE Province (
    idProvince NUMBER(8),
    countryId NUMBER(8), --FK
    name VARCHAR(50)
);

ALTER TABLE Province
    ADD CONSTRAINT provincePk PRIMARY KEY (idProvince)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Province
    ADD CONSTRAINT provinceXCountryFK FOREIGN KEY (countryId) 
    REFERENCES Country(idCountry);