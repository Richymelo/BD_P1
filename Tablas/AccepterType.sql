CREATE TABLE AcceptedType (
    idAcceptedType NUMBER(8) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    fosterHomeId NUMBER(8) NOT NULL --FK
);

ALTER TABLE AcceptedType
    ADD CONSTRAINT acceptedTypePk PRIMARY KEY (idAcceptedType)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE AcceptedType
    ADD CONSTRAINT acceptedTypeXFosterHomeFK FOREIGN KEY (fosterHomeId) 
    REFERENCES FosterHome(idFosterHome);