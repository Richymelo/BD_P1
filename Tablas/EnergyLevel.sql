CREATE TABLE EnergyLevel (
    idEnergyLevel NUMBER(8),
    name VARCHAR(50)
);

ALTER TABLE EnergyLevel
    ADD CONSTRAINT energyLevelPk PRIMARY KEY (idEnergyLevel)
    USING INDEX TABLESPACE GEIndex;