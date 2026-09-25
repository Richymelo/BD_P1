--
CREATE TABLE Association (
    id NUMBER(8) NOT NULL,
    description VARCHAR2(50) NOT NULL,
    phone NUMBER(8) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL
);

ALTER TABLE Association

    ADD CONSTRAINT associationPk PRIMARY KEY (idAssociation)
    USING INDEX TABLESPACE GEIndex;
    

    
    
