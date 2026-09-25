CREATE TABLE Veterinarian (
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    userId NUMBER(8) NOT NULL --PK, FK
);

ALTER TABLE Veterinarian
    ADD CONSTRAINT veterinarianPk PRIMARY KEY (userId)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Veterinarian
    ADD CONSTRAINT veterinarianXUserFK FOREIGN KEY (userId) 
    REFERENCES User(idUser);