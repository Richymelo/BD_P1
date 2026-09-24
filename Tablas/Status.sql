CREATE TABLE Status (
    idStatus NUMBER(8),
    name VARCHAR(50)
);

ALTER TABLE Status
    ADD CONSTRAINT statusPk PRIMARY KEY (idStatus)
    USING INDEX TABLESPACE GEIndex;