CREATE TABLE Adopter (
    userId NUMBER(8) --PK, FK
);

ALTER TABLE Adopter
    ADD CONSTRAINT adopterPk PRIMARY KEY (userId)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Adopter
    ADD CONSTRAINT adopterXUserFK FOREIGN KEY (userId) 
    REFERENCES User(idUser);