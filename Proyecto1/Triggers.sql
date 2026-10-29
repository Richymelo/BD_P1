-----------------------------------
--Association triggers 
-----------------------------------
CREATE OR REPLACE TRIGGER beforeInsertAssociation
BEFORE INSERT
ON Association
FOR EACH ROW
BEGIN
    :new.createdBy  := USER;
    :new.createdAt  := SYSDATE;
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeInsertAssociation;
/
 
CREATE OR REPLACE TRIGGER beforeUpdateAssociation
BEFORE UPDATE
ON Association
FOR EACH ROW
BEGIN
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeUpdateAssociation;
/





-----------------------------------
--Donation triggers 
-----------------------------------

CREATE OR REPLACE TRIGGER beforeInsertDonation
BEFORE INSERT
ON Donation
FOR EACH ROW
BEGIN
    :new.createdBy  := USER;
    :new.createdAt  := SYSDATE;
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeInsertDonation;
/
CREATE OR REPLACE TRIGGER beforeUpdateDonation
BEFORE UPDATE
ON Donation
FOR EACH ROW
BEGIN
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeUpdateDonation;
/



-----------------------------------
--Currency triggers 
-----------------------------------

CREATE OR REPLACE TRIGGER beforeInsertCurrency
BEFORE INSERT
ON Currency
FOR EACH ROW
BEGIN
    :new.createdBy  := USER;
    :new.createdAt  := SYSDATE;
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeInsertCurrency;
/

CREATE OR REPLACE TRIGGER beforeUpdateCurrency
BEFORE UPDATE
ON Currency
FOR EACH ROW
BEGIN
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeUpdateCurrency;
/






-----------------------------------
--User triggers 
-----------------------------------

CREATE OR REPLACE TRIGGER beforeInsertAppUser
BEFORE INSERT
ON AppUser
FOR EACH ROW
BEGIN
    :new.createdBy  := USER;
    :new.createdAt  := SYSDATE;
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeInsertUser;
/
 
CREATE OR REPLACE TRIGGER beforeUpdateAppUser
BEFORE UPDATE
ON AppUser
FOR EACH ROW
BEGIN
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeUpdateUser;
/
 
 
-----------------------------------
--Person triggers 
-----------------------------------

CREATE OR REPLACE TRIGGER beforeInsertPerson
BEFORE INSERT
ON Person
FOR EACH ROW
BEGIN
    :new.createdBy  := USER;
    :new.createdAt  := SYSDATE;
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeInsertPerson;
/
 
CREATE OR REPLACE TRIGGER beforeUpdatePerson
BEFORE UPDATE
ON Person
FOR EACH ROW
BEGIN
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeUpdatePerson;
/



-----------------------------------
--SessionInfo triggers 
-----------------------------------

CREATE OR REPLACE TRIGGER beforeInsertSessionInfo
BEFORE INSERT
ON SessionInfo
FOR EACH ROW
BEGIN
    :new.createdBy  := USER;
    :new.createdAt  := SYSDATE;
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeInsertSessionInfo;
/

CREATE OR REPLACE TRIGGER beforeUpdateSessionInfo
BEFORE UPDATE
ON SessionInfo
FOR EACH ROW
BEGIN
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeUpdateSessionInfo;
/



CREATE OR REPLACE TRIGGER beforeInsertDonationType
BEFORE INSERT
ON DonationType
FOR EACH ROW
BEGIN
    :new.createdBy  := USER;
    :new.createdAt  := SYSDATE;
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeInsertDonationType;
/
 
 
CREATE OR REPLACE TRIGGER beforeUpdateDonationType
BEFORE UPDATE
ON DonationType
FOR EACH ROW
BEGIN
    :new.modifiedBy := USER;
    :new.modifiedAt := SYSDATE;
END beforeUpdateDonationType;
/


------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--Triggers para llamar a log
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--TODO: Faltan de correr:
-----------------------------------
-- Triggers that call insertLog 
-----------------------------------
CREATE OR REPLACE TRIGGER beforeUpdateDonationAmount
BEFORE UPDATE OF amount
ON Donation
FOR EACH ROW
DECLARE
    vIdUser NUMBER;
BEGIN
 
    BEGIN
        SELECT MAX(userId)
          INTO vIdUser
          FROM SessionInfo
         WHERE ROWNUM = 1;
    EXCEPTION WHEN OTHERS THEN
        vIdUser := NULL;
    END;
 
    BEGIN
        IF :old.amount <> :new.amount THEN
            insertLog('Donation', 'amount', TO_CHAR(:old.amount), TO_CHAR(:new.amount), 'UPDATE', vIdUser);
        END IF;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
 
END beforeUpdateDonationAmount;
/

CREATE OR REPLACE TRIGGER beforeUpdateUserPassword
BEFORE UPDATE OF password
ON AppUser
FOR EACH ROW
DECLARE
    vIdUser NUMBER;
BEGIN
 
    BEGIN
        SELECT MAX(userId)
          INTO vIdUser
          FROM SessionInfo
         WHERE ROWNUM = 1;
    EXCEPTION WHEN OTHERS THEN
        vIdUser := NULL;
    END;
 
    BEGIN
        IF :old.password <> :new.password THEN
            insertLog('User', 'password', '***', '***', 'UPDATE', vIdUser);
        END IF;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
 
END beforeUpdateUserPassword;
/

CREATE OR REPLACE TRIGGER beforeUpdateAssociationIsActive
BEFORE UPDATE OF isActive
ON Association
FOR EACH ROW
DECLARE
    vIdUser NUMBER;
BEGIN
 
    BEGIN
        SELECT MAX(userId)
          INTO vIdUser
          FROM SessionInfo
         WHERE ROWNUM = 1;
    EXCEPTION WHEN OTHERS THEN
        vIdUser := NULL;
    END;
 
    BEGIN
        IF :old.isActive <> :new.isActive THEN
            insertLog('Association', 'isActive', TO_CHAR(:old.isActive), TO_CHAR(:new.isActive), 'UPDATE', vIdUser);
        END IF;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
 
END beforeUpdateAssociationIsActive;
/

CREATE OR REPLACE TRIGGER beforeUpdateAssociationName
BEFORE UPDATE OF name
ON Association
FOR EACH ROW
DECLARE
    vIdUser NUMBER;
BEGIN
 
    BEGIN
        SELECT MAX(userId)
          INTO vIdUser
          FROM SessionInfo
         WHERE ROWNUM = 1;
    EXCEPTION WHEN OTHERS THEN
        vIdUser := NULL;
    END;
 
    BEGIN
        IF :old.name <> :new.name THEN
            insertLog('Association', 'name', TO_CHAR(:old.name), TO_CHAR(:new.name), 'UPDATE', vIdUser);
        END IF;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
 
END beforeUpdateAssociationName;
/

--TODO: FALTA AGREGAR UNOS FALTANTES Y CON UNAS EXCEPCIONES 





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*==============================================
Triggers de bitacora
Author: Ricardo
==============================================*/

--getSessionUserId*****************************************************************
/*
Description: returns the id of the logged user (client identifier if set, otherwise the user in SessionInfo); NULL if nobody is logged
Author: Ricardo
*/
CREATE OR REPLACE FUNCTION getSessionUserId
RETURN NUMBER
IS
    vnUserId NUMBER;
BEGIN
    vnUserId := TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'));
    IF vnUserId IS NULL THEN
        SELECT MAX(userId)
        INTO vnUserId
        FROM SessionInfo;
    END IF;
    RETURN vnUserId;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END getSessionUserId;
/

/*
Description: logs every change of Adoption.rating and Adoption.notes in Log
Author: Ricardo
*/
CREATE OR REPLACE TRIGGER trg_adoption_log
AFTER UPDATE OF rating, notes ON Adoption
FOR EACH ROW
DECLARE
    vnUserId NUMBER := getSessionUserId;
BEGIN
    IF NVL(:OLD.rating, -1) <> NVL(:NEW.rating, -1) THEN
        INSERT INTO Log (id, affectedTable, affectedSlot, lastValue, newValue, logDate, operationType, createdBy, modifiedBy, modifiedAt, userId)
        VALUES (s_log.NEXTVAL, 'Adoption', 'rating', NVL(TO_CHAR(:OLD.rating), 'null'), NVL(TO_CHAR(:NEW.rating), 'null'), SYSDATE, 'UPDATE', USER, USER, SYSDATE, vnUserId);
    END IF;
    IF NVL(:OLD.notes, ' ') <> NVL(:NEW.notes, ' ') THEN
        INSERT INTO Log (id, affectedTable, affectedSlot, lastValue, newValue, logDate, operationType, createdBy, modifiedBy, modifiedAt, userId)
        VALUES (s_log.NEXTVAL, 'Adoption', 'notes', NVL(SUBSTR(:OLD.notes, 1, 50), 'null'), NVL(SUBSTR(:NEW.notes, 1, 50), 'null'), SYSDATE, 'UPDATE', USER, USER, SYSDATE, vnUserId);
    END IF;
END trg_adoption_log;
/

--trg_application_log*****************************************************************
/*
Description: logs every change of AdoptionApplication.statusId in Log
Author: Ricardo
*/
CREATE OR REPLACE TRIGGER trg_application_log
AFTER UPDATE OF statusId ON AdoptionApplication
FOR EACH ROW
DECLARE
    vnUserId NUMBER := getSessionUserId;
BEGIN
    IF :OLD.statusId <> :NEW.statusId THEN
        INSERT INTO Log (id, affectedTable, affectedSlot, lastValue, newValue, logDate, operationType, createdBy, modifiedBy, modifiedAt, userId)
        VALUES (s_log.NEXTVAL, 'AdoptionApplication', 'statusId', TO_CHAR(:OLD.statusId), TO_CHAR(:NEW.statusId), SYSDATE, 'UPDATE', USER, USER, SYSDATE, vnUserId);
    END IF;
END trg_application_log;
/

/*
INSERT INTO SessionInfo (userId, createdBy, modifiedBy, modifiedAt) VALUES (1, USER, USER, SYSDATE);
COMMIT;
EXEC pkg_adoption.rateAdoption(1, 3, 'prueba trigger');
SELECT affectedTable, affectedSlot, lastValue, newValue, logDate, operationType, userId FROM Log ORDER BY id;

DELETE FROM SessionInfo WHERE userId = 1;
COMMIT;
*/






------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




ALTER TABLE Log MODIFY (lastValue VARCHAR2(500), newValue VARCHAR2(500));


CREATE OR REPLACE TRIGGER TRG_LOG_PET
AFTER INSERT OR UPDATE OR DELETE ON PET
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO LOG (ID, AFFECTEDTABLE, AFFECTEDSLOT, OPERATIONTYPE, LASTVALUE, NEWVALUE, LOGDATE, CREATEDBY, CREATEDAT, MODIFIEDBY, MODIFIEDAT, USERID)
    VALUES (S_LOG.NEXTVAL, 'PET', 'PET', 'INSERT', 'N/A', 'PET_ID=' || :NEW.ID || ', NAME=' || :NEW.NAME, SYSDATE, USER, SYSTIMESTAMP, USER, SYSTIMESTAMP, 1);
  
  ELSIF UPDATING THEN
    INSERT INTO LOG (ID, AFFECTEDTABLE, AFFECTEDSLOT, OPERATIONTYPE, LASTVALUE, NEWVALUE, LOGDATE, CREATEDBY, CREATEDAT, MODIFIEDBY, MODIFIEDAT, USERID)
    VALUES (S_LOG.NEXTVAL, 'PET', 'PET', 'UPDATE', 'PET_ID=' || :OLD.ID || ', NAME=' || :OLD.NAME, 'PET_ID=' || :NEW.ID || ', NAME=' || :NEW.NAME, SYSDATE, USER, SYSTIMESTAMP, USER, SYSTIMESTAMP, 1);
  
  ELSIF DELETING THEN
    INSERT INTO LOG (ID, AFFECTEDTABLE, AFFECTEDSLOT, OPERATIONTYPE, LASTVALUE, NEWVALUE, LOGDATE, CREATEDBY, CREATEDAT, MODIFIEDBY, MODIFIEDAT, USERID)
    VALUES (S_LOG.NEXTVAL, 'PET', 'PET', 'DELETE', 'PET_ID=' || :OLD.ID || ', NAME=' || :OLD.NAME, 'N/A', SYSDATE, USER, SYSTIMESTAMP, USER, SYSTIMESTAMP, 1);
  END IF;
END;
/


CREATE OR REPLACE TRIGGER TRG_LOG_MATCH
AFTER INSERT OR UPDATE OR DELETE ON MATCH
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO LOG (ID, AFFECTEDTABLE, AFFECTEDSLOT, OPERATIONTYPE, LASTVALUE, NEWVALUE, LOGDATE, CREATEDBY, CREATEDAT, MODIFIEDBY, MODIFIEDAT, USERID)
    VALUES (S_LOG.NEXTVAL, 'MATCH', 'MATCH', 'INSERT', 'N/A', 'MATCH_ID=' || :NEW.ID || ', LOSTPETID=' || :NEW.LOSTPETID || ', FOUNDPETID=' || :NEW.FOUNDPETID || ', PERCENTAJE=' || :NEW.PERCENTAJE, SYSDATE, USER, SYSTIMESTAMP, USER, SYSTIMESTAMP, 1);
  
  ELSIF UPDATING THEN
    INSERT INTO LOG (ID, AFFECTEDTABLE, AFFECTEDSLOT, OPERATIONTYPE, LASTVALUE, NEWVALUE, LOGDATE, CREATEDBY, CREATEDAT, MODIFIEDBY, MODIFIEDAT, USERID)
    VALUES (S_LOG.NEXTVAL, 'MATCH', 'MATCH', 'UPDATE', 'MATCH_ID=' || :OLD.ID || ', PERCENTAJE=' || :OLD.PERCENTAJE, 'MATCH_ID=' || :NEW.ID || ', PERCENTAJE=' || :NEW.PERCENTAJE, SYSDATE, USER, SYSTIMESTAMP, USER, SYSTIMESTAMP, 1);
  
  ELSIF DELETING THEN
    INSERT INTO LOG (ID, AFFECTEDTABLE, AFFECTEDSLOT, OPERATIONTYPE, LASTVALUE, NEWVALUE, LOGDATE, CREATEDBY, CREATEDAT, MODIFIEDBY, MODIFIEDAT, USERID)
    VALUES (S_LOG.NEXTVAL, 'MATCH', 'MATCH', 'DELETE', 'MATCH_ID=' || :OLD.ID || ', LOSTPETID=' || :OLD.LOSTPETID || ', FOUNDPETID=' || :OLD.FOUNDPETID, 'N/A', SYSDATE, USER, SYSTIMESTAMP, USER, SYSTIMESTAMP, 1);
  END IF;
END;
/





