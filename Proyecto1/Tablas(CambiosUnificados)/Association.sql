CREATE TABLE Association (
    id NUMBER(8) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    description VARCHAR2(50) NOT NULL,
    phone NUMBER(8) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    isActive NUMBER(1) DEFAULT 1 NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL
);

ALTER TABLE Association

    ADD CONSTRAINT associationPk PRIMARY KEY (id)
    USING INDEX TABLESPACE GEIndex;
    
ALTER TABLE Association

    ADD CONSTRAINT chkAssociationIsActive CHECK (isActive IN (0, 1));

    
    
