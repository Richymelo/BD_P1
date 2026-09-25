CREATE TABLE Canton (
    id NUMBER(8) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    provinceId NUMBER(8) NOT NULL, --FK
    name VARCHAR2(50) NOT NULL
);

ALTER TABLE Canton
    ADD CONSTRAINT cantonPk PRIMARY KEY (idCanton)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Canton
    ADD CONSTRAINT cantonXProvinceFK FOREIGN KEY (provinceId) 
    REFERENCES Province(idProvince);