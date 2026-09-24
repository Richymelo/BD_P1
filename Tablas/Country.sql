CREATE TABLE Country (
    idCountry NUMBER(8),
    name VARCHAR(50)
);

ALTER TABLE Country
    ADD CONSTRAINT countryPk PRIMARY KEY (idCountry)
    USING INDEX TABLESPACE GEIndex;