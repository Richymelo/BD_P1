-- ===================== INDICES =====================
-- Oracle indexa solo las PK automaticamente; las FK NO. Se indexan las FK que
-- se usan en JOIN/WHERE de las consultas (5c, 8c, formulario 4o).
-- Van en el tablespace de indices del proyecto (GEIndex).
CREATE INDEX idx_adoption_adopter    ON adoption(adopterId)             TABLESPACE GEIndex;
CREATE INDEX idx_adoption_pet        ON adoption(petId)                 TABLESPACE GEIndex;
CREATE INDEX idx_adoption_giveperson ON adoption(givePersonId)          TABLESPACE GEIndex;
CREATE INDEX idx_adoptapp_adopter    ON adoptionapplication(adopterId)  TABLESPACE GEIndex;
CREATE INDEX idx_adoptapp_status     ON adoptionapplication(statusId)   TABLESPACE GEIndex;
CREATE INDEX idx_formquestion_app    ON formquestion(aplicationId)      TABLESPACE GEIndex;
CREATE INDEX idx_formanswer_app      ON formanswer(aplicationId)        TABLESPACE GEIndex;
CREATE INDEX idx_fosterhome_user     ON fosterhome(userId)              TABLESPACE GEIndex;
CREATE INDEX idx_blacklist_user      ON blacklist(userId)               TABLESPACE GEIndex;
CREATE INDEX idx_acceptedtype_fh     ON acceptedtype(fosterHomeId)      TABLESPACE GEIndex;
CREATE INDEX idx_acceptedsize_fh     ON acceptedsize(fosterHomeId)      TABLESPACE GEIndex;
CREATE INDEX idx_donation_appuser      ON Donation(appUserId)      TABLESPACE GEIndex;
CREATE INDEX idx_donation_association  ON Donation(associationId)  TABLESPACE GEIndex;
CREATE INDEX idx_donation_date         ON Donation(donationDate)   TABLESPACE GEIndex;
CREATE INDEX idx_log_user              ON Log(userId)              TABLESPACE GEIndex;