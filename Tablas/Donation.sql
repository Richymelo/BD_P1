CREATE TABLE Donation (
    id NUMBER(8) NOT NULL,
    amount NUMBER NOT NULL,
    "date" DATE NOT NULL,
    donatorId NUMBER(8) NOT NULL,
    associationId NUMBER(8) NOT NULL,
    donationTypeId NUMBER(8) NOT NULL,
    currencyId NUMBER(8) NOT NULL,
    createdBy VARCHAR2(50) NOT NULL,
    createdAt TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modifiedBy VARCHAR2(50) NOT NULL,
    modifiedAt TIMESTAMP(6) NOT NULL
);

ALTER TABLE Donation
    ADD CONSTRAINT donationPk PRIMARY KEY (id)
    USING INDEX TABLESPACE GEIndex;

ALTER TABLE Donation
    ADD CONSTRAINT fkDonationAssociation FOREIGN KEY (associationId) 
    REFERENCES Association(id);

ALTER TABLE Donation
    ADD CONSTRAINT fkDonationDonationType FOREIGN KEY (donationTypeId) 
    REFERENCES DonationType(id);

ALTER TABLE Donation
    ADD CONSTRAINT fkDonationCurrency FOREIGN KEY (currencyId) 
    REFERENCES Currency(id);