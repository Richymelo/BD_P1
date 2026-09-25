CREATE TABLE Blacklist (
    id NUMBER(8) NOT NULL,
    reason VARCHAR2(50) NOT NULL,
    date DATE NOT NULL,
    grade VARCHAR2(50) NOT NULL,
    notes VARCHAR2(50) NOT NULL,
    reportedby VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    userId NUMBER(8) NOT NULL --FK
);

ALTER TABLE Blacklist
    ADD CONSTRAINT blacklistPk PRIMARY KEY (idBlacklist)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Blacklist
    ADD CONSTRAINT blacklistXUserFK FOREIGN KEY (userId) 
    REFERENCES User(idUser);