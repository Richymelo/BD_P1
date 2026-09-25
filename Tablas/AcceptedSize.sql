CREATE TABLE AcceptedSize (
    idAcceptedSize NUMBER(8) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    fosterHomeId NUMBER(8) NOT NULL--FK
);

ALTER TABLE AcceptedSize
    ADD CONSTRAINT acceptedSizePk PRIMARY KEY (idAcceptedSize)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE AcceptedSize
    ADD CONSTRAINT acceptedSizeXFosterHomeFK FOREIGN KEY (fosterHomeId) 
    REFERENCES FosterHome(idFosterHome);
    
    
    