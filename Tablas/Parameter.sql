CREATE TABLE Parameter (
    idParameter NUMBER(8),
    name VARCHAR(50),
    description VARCHAR(50),
    value VARCHAR(50)
);

ALTER TABLE Parameter
    ADD CONSTRAINT parameterPk PRIMARY KEY (idParameter)
    USING INDEX TABLESPACE GEIndex;