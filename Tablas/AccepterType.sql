CREATE TABLE AcceptedType (
    idAcceptedType NUMBER(8),
    name VARCHAR(50),
    fosterHomeId NUMBER(8) --FK
);

ALTER TABLE AcceptedType
    ADD CONSTRAINT acceptedTypePk PRIMARY KEY (idAcceptedType)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE AcceptedType
    ADD CONSTRAINT acceptedTypeXFosterHomeFK FOREIGN KEY (fosterHomeId) 
    REFERENCES FosterHome(idFosterHome);