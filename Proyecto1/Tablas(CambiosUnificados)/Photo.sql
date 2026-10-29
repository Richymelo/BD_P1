CREATE TABLE Photo (
    id NUMBER(8) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    image BLOB NOT NULL,
    photoType VARCHAR2(20) NOT NULL,
    petId NUMBER(8) NOT NULL, --FK -> Pet(id), 1 Pet -> N Photos
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    acceptedTypeId NUMBER(8), --FK
    typeId NUMBER(8) --FK
);

ALTER TABLE Photo
    ADD CONSTRAINT photoPk PRIMARY KEY (id)
    USING INDEX TABLESPACE GEIndex;

-- Recordar borrar la anterior antes de crear de nuevo


ALTER TABLE Photo ADD CONSTRAINT photoXPetFK FOREIGN KEY (petId) REFERENCES Pet(id);

    
ALTER TABLE Photo
    ADD CONSTRAINT photoXAcceptedTypeFK FOREIGN KEY (acceptedTypeId) 
    REFERENCES AcceptedType(id);

ALTER TABLE Photo
    ADD CONSTRAINT photoXTypeFK FOREIGN KEY (typeId) 
    REFERENCES type(id);
    
    
    




ALTER TABLE Photo MODIFY (acceptedTypeId NULL, typeId NULL);