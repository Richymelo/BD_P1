CREATE TABLE Color (
    idColor NUMBER(8),
    name VARCHAR(50)
);

ALTER TABLE Color
    ADD CONSTRAINT colorPk PRIMARY KEY (idColor)
    USING INDEX TABLESPACE GEIndex;