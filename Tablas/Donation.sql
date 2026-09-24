CREATE TABLE Donation (
    idDonation NUMBER(8),
    amount NUMBER(8),
    date DATE,
    donationType VARCHAR(50),
    donatorId NUMBER(8), --FK
    associationId NUMBER(8), --FK
    donationReportId NUMBER(8), --FK
    currencyId NUMBER(8) --FK
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