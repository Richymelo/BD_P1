CREATE TABLE Canton (
    idCanton NUMBER(8),
    provinceId NUMBER(8), --FK
    name VARCHAR(50)
);

ALTER TABLE Canton
    ADD CONSTRAINT cantonPk PRIMARY KEY (idCanton)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Canton
    ADD CONSTRAINT cantonXProvinceFK FOREIGN KEY (provinceId) 
    REFERENCES Province(idProvince);