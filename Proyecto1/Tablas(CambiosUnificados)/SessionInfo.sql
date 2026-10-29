CREATE TABLE SessionInfo (
    userId NUMBER(8) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL
);
 
ALTER TABLE SessionInfo
 
    ADD CONSTRAINT sessionInfoPk PRIMARY KEY (userId)
    USING INDEX TABLESPACE GEIndex;
 
ALTER TABLE SessionInfo
 
    ADD CONSTRAINT sessionInfoUserFk FOREIGN KEY (userId)
    REFERENCES AppUser (id);
 