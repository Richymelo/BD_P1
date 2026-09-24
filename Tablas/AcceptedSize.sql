CREATE TABLE AcceptedSize (
    idAcceptedSize NUMBER(8),
    name VARCHAR(50),
    fosterHomeId NUMBER(8) --FK
);

ALTER TABLE AcceptedSize
    ADD CONSTRAINT acceptedSizePk PRIMARY KEY (idAcceptedSize)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE AcceptedSize
    ADD CONSTRAINT acceptedSizeXFosterHomeFK FOREIGN KEY (fosterHomeId) 
    REFERENCES FosterHome(idFosterHome);