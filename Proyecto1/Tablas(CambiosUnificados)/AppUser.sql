CREATE TABLE AppUser (
    id NUMBER(8) NOT NULL, 
    username VARCHAR2(50) NOT NULL,
    isAdmin NUMBER(1) DEFAULT 0 NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    password VARCHAR2(64) NOT NULL
);

ALTER TABLE AppUser
    ADD CONSTRAINT appUserPk PRIMARY KEY (id)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE AppUser
    ADD CONSTRAINT appUserXPersonFK FOREIGN KEY (id) 
    REFERENCES Person(id);
    
ALTER TABLE
    AppUser ADD CONSTRAINT userUsernameUnique UNIQUE (username);
    
