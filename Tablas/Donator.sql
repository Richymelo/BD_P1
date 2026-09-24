CREATE TABLE Donator (
    userId NUMBER(8) --PK, FK
);

ALTER TABLE Donator
    ADD CONSTRAINT donatorPk PRIMARY KEY (userId)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Donator
    ADD CONSTRAINT donatorXUserFK FOREIGN KEY (userId) 
    REFERENCES User(idUser);