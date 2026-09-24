CREATE TABLE Currency (
    idCurrency NUMBER(8),
    code VARCHAR(50),
    name VARCHAR(50)
);

ALTER TABLE Currency
    ADD CONSTRAINT currencyPk PRIMARY KEY (idCurrency)
    USING INDEX TABLESPACE GEIndex;