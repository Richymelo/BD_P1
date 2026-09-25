CREATE TABLE Photo (
    id NUMBER(8) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    acceptedTypeId NUMBER(8) NOT NULL, --FK
    typeId NUMBER(8) NOT NULL --FK
);

ALTER TABLE Photo
    ADD CONSTRAINT photoPk PRIMARY KEY (idPhoto)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Photo
    ADD CONSTRAINT photoXAcceptedTypeFK FOREIGN KEY (acceptedTypeId) 
    REFERENCES AcceptedType(idAcceptedType);

ALTER TABLE Photo
    ADD CONSTRAINT photoXTypeFK FOREIGN KEY (typeId) 
    REFERENCES type(idType);