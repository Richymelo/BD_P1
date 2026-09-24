CREATE TABLE Severity (
    idSeverity NUMBER(8),
    name VARCHAR(50)
);

ALTER TABLE Severity
    ADD CONSTRAINT severityPk PRIMARY KEY (idSeverity)
    USING INDEX TABLESPACE GEIndex;