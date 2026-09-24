CREATE TABLE Rescuer (
    userId NUMBER(8) --PK, FK
);

ALTER TABLE Rescuer
    ADD CONSTRAINT rescuerPk PRIMARY KEY (userId)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Rescuer
    ADD CONSTRAINT rescuerXUserFK FOREIGN KEY (userId) 
    REFERENCES User(idUser);