CREATE TABLE Veterinarian (
    userId NUMBER(8) --PK, FK
);

ALTER TABLE Veterinarian
    ADD CONSTRAINT veterinarianPk PRIMARY KEY (userId)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Veterinarian
    ADD CONSTRAINT veterinarianXUserFK FOREIGN KEY (userId) 
    REFERENCES User(idUser);