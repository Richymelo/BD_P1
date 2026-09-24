CREATE TABLE FormAnswer (
    idFormAnswer NUMBER(8),
    name VARCHAR(50),
    aplicationId NUMBER(8) --FK
);

ALTER TABLE FormAnswer
    ADD CONSTRAINT formAnswerPk PRIMARY KEY (idFormAnswer)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE FormAnswer
    ADD CONSTRAINT formAnswerXAdoptionApplicationFK FOREIGN KEY (aplicationId) 
    REFERENCES AdoptionApplication(idAdoptionApplication);