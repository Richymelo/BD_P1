--
CREATE TABLE Association (

    idAssociation NUMBER(8),
    description VARCHAR(50),
    phone NUMBER(8),
    email VARCHAR(50) 
);

ALTER TABLE Association

    ADD CONSTRAINT associationPk PRIMARY KEY (idAssociation)
    USING INDEX TABLESPACE GEIndex;
    

    
    
