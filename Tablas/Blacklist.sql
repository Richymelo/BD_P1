CREATE TABLE Blacklist (
    idBlacklist NUMBER(8),
    reason VARCHAR(50),
    date DATE,
    grade VARCHAR(50),
    notes VARCHAR(50),
    reportedby VARCHAR(50),
    userId NUMBER(8) --FK
);

ALTER TABLE Blacklist
    ADD CONSTRAINT blacklistPk PRIMARY KEY (idBlacklist)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Blacklist
    ADD CONSTRAINT blacklistXUserFK FOREIGN KEY (userId) 
    REFERENCES User(idUser);