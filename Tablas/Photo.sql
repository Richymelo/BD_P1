CREATE TABLE Photo (
    idPhoto NUMBER(8),
    name VARCHAR(50),
    acceptedTypeId NUMBER(8), --FK
    typeId NUMBER(8) --FK
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