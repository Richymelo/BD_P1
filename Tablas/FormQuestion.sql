CREATE TABLE FormQuestion (
    idFormQuestion NUMBER(8),
    name VARCHAR(50),
    aplicationId NUMBER(8) --FK
);

ALTER TABLE FormQuestion
    ADD CONSTRAINT formQuestionPk PRIMARY KEY (idFormQuestion)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE FormQuestion
    ADD CONSTRAINT formQuestionXAdoptionApplicationFK FOREIGN KEY (aplicationId) 
    REFERENCES AdoptionApplication(idAdoptionApplication);