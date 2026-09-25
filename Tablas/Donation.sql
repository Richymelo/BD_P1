CREATE TABLE Donation (
    id NUMBER(8) NOT NULL,
    amount NUMBER(8) NOT NULL,
    date DATE NOT NULL,
    donationType VARCHAR2(50) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL,
    donatorId NUMBER(8) NOT NULL, --FK
    associationId NUMBER(8) NOT NULL, --FK
    donationReportId NUMBER(8) NOT NULL, --FK
    currencyId NUMBER(8) NOT NULL --FK
);

ALTER TABLE Donation
    ADD CONSTRAINT donationPk PRIMARY KEY (idDonation)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Donation
    ADD CONSTRAINT donationXDonatorFK FOREIGN KEY (donatorId) 
    REFERENCES Donator(idDonator);

ALTER TABLE Donation
    ADD CONSTRAINT donationXAssociationFK FOREIGN KEY (associationId) 
    REFERENCES Association(idAssociation);

ALTER TABLE Donation
    ADD CONSTRAINT donationXDonationReportFK FOREIGN KEY (donationReportId) 
    REFERENCES DonationReport(idDonationReport);

ALTER TABLE Donation
    ADD CONSTRAINT donationXCurrencyFK FOREIGN KEY (currencyId) 
    REFERENCES Currency(idCurrency);