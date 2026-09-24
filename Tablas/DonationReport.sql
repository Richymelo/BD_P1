CREATE TABLE DonationReport (
    idDonationReport NUMBER(8),
    description VARCHAR(50),
    amount NUMBER(8),
    date DATE,
    donationType VARCHAR(50),
    currencyId NUMBER(8) --FK
);

ALTER TABLE DonationReport
    ADD CONSTRAINT donationReportPk PRIMARY KEY (idDonationReport)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE DonationReport
    ADD CONSTRAINT donationReportXCurrencyFK FOREIGN KEY (currencyId) 
    REFERENCES Currency(idCurrency);