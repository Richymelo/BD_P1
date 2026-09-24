CREATE TABLE User (
    idUser NUMBER(8), --FK
    userName VARCHAR(50),
    password VARCHAR(50)
);

ALTER TABLE User
    ADD CONSTRAINT userPk PRIMARY KEY (idUser)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE User
    ADD CONSTRAINT userXPersonFK FOREIGN KEY (idUser) 
    REFERENCES Person(idPerson);