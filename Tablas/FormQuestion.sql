CREATE TABLE FormQuestion (
    id NUMBER(8) NOT NULL,
    name VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    aplicationId NUMBER(8) NOT NULL --FK
);

ALTER TABLE FormQuestion
    ADD CONSTRAINT formQuestionPk PRIMARY KEY (idFormQuestion)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE FormQuestion
    ADD CONSTRAINT formQuestionXAdoptionApplicationFK FOREIGN KEY (aplicationId) 
    REFERENCES AdoptionApplication(idAdoptionApplication);