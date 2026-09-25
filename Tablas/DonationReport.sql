CREATE TABLE DonationReport (
    id NUMBER(8) NOT NULL,
    description VARCHAR2(50) NOT NULL,
    amount NUMBER(8) NOT NULL,
    date DATE NOT NULL,
    donationType VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    currencyId NUMBER(8) NOT NULL --FK
);

ALTER TABLE DonationReport
    ADD CONSTRAINT donationReportPk PRIMARY KEY (idDonationReport)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE DonationReport
    ADD CONSTRAINT donationReportXCurrencyFK FOREIGN KEY (currencyId) 
    REFERENCES Currency(idCurrency);