--------------------------------
--User functions and procedures
--------------------------------

-- Description: Registers a new user. Creates a person first then the user with the same id
-- Author:      Gabriel Zuñiga
-- Date:        30/9/2026
CREATE OR REPLACE PROCEDURE insertUser (
    pFirstName IN VARCHAR2,
    pSecondName IN VARCHAR2,
    pFirstSurname IN VARCHAR2,
    pSecondSurname  IN VARCHAR2,
    pEmail IN VARCHAR2,
    pPhone IN VARCHAR2,
    pUsername IN VARCHAR2,
    pPassword IN VARCHAR2,
    pIsAdmin IN NUMBER)
IS
    vIdPerson NUMBER; 
BEGIN
    vIdPerson := s_person.NEXTVAL;
 
    INSERT INTO Person (id, firstName, secondName, firstSurname, secondSurname, email, phone)
    VALUES (vIdPerson, pFirstName, pSecondName, pFirstSurname, pSecondSurname, pEmail, pPhone);
 
    INSERT INTO AppUser (id, username, password, isAdmin )
    VALUES (vIdPerson, pUsername,RAWTOHEX(STANDARD_HASH(pPassword, 'SHA256')), pIsAdmin); 
 
    COMMIT;
END insertUser;
/
-- Description: Verifies if the user credentials are in the DB and are correct and lets in if yes. If not found returns NULL
-- Author:      Gabriel Zuñiga
-- Date:        30/9/2026

CREATE OR REPLACE FUNCTION loginUser (
    pUsername IN VARCHAR2,
    pPassword IN VARCHAR2)
RETURN NUMBER
IS
    vIdUser NUMBER;
    
BEGIN
    
    SELECT id
      INTO vIdUser
      FROM AppUser
     WHERE username = pUsername
       AND password = RAWTOHEX(STANDARD_HASH(pPassword, 'SHA256'));
 
    RETURN (vIdUser);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END loginUser;
/
-- Description: Changes a users password
-- Author:      Gabriel Zuñiga
-- Date:        30/9/2026
CREATE OR REPLACE PROCEDURE changePassword(
    pId IN  NUMBER,
    pPassword IN VARCHAR2)
IS
BEGIN
    UPDATE AppUser
           SET password =  RAWTOHEX(STANDARD_HASH(pPassword, 'SHA256'))
            WHERE id = pId;
     
        COMMIT;
END changePassword;
/
-- Description: Searches users. Every filter is optional.
-- Author:      Gabriel Zuñiga
-- Date:        21/10/2026
CREATE OR REPLACE PROCEDURE searchUsers (
    pName IN VARCHAR2,
    pUsername IN VARCHAR2,
    pEmail IN VARCHAR2,
    pPhone IN VARCHAR2,
    pCursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN pCursor FOR
        SELECT u.id AS idUser,
            p.firstName,
            p.secondName,
            p.firstSurname,
            p.secondSurname,
            p.email,
            p.phone,
            u.userName,
            u.isAdmin
        FROM Person p
        INNER JOIN AppUser u
            ON u.id = p.id
            WHERE (pName IS NULL OR UPPER(p.firstName || ' ' || NVL(p.secondName || ' ', '') || p.firstSurname || ' ' || NVL(p.secondSurname, '')) LIKE '%' || UPPER(pName) || '%')
            AND (pUsername IS NULL OR UPPER(u.username) LIKE '%' || UPPER(pUsername) || '%')
            AND (pEmail IS NULL OR UPPER(p.email) LIKE '%' || UPPER(pEmail) || '%')
            AND (pPhone IS NULL OR p.phone LIKE '%' || pPhone || '%')
         ORDER BY p.firstSurname, p.firstName;
         
END searchUsers;
/

-- Description: Returns all the data of a single user
-- Author:      Gabriel Zuñiga
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE getUserById (
    pId IN NUMBER,
    pCursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN pCursor FOR
        SELECT u.id AS idUser,
               p.firstName,
               p.secondName,
               p.firstSurname,
               p.secondSurname,
               p.email,
               p.phone,
               u.userName,
               u.isAdmin
          FROM Person p
         INNER JOIN AppUser u
            ON u.id = p.id
         WHERE u.id = pId;
END getUserById;
/
-- Description: Checks if a user is an Admin
-- Author:      Gabriel Zuñiga
-- Date:        22/10/2026
CREATE OR REPLACE FUNCTION isUserAdmin (pId IN NUMBER)
RETURN NUMBER
IS
    vIsAdmin NUMBER;
BEGIN
    SELECT isAdmin INTO vIsAdmin FROM AppUser WHERE id = pId;
    RETURN vIsAdmin;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END isUserAdmin;
/

--------------------------------------
--Association functions and procedures 
--------------------------------------
-- Description: Creates a new Association.
-- Author:      Gabriel Zuñiga
-- Date:        30/9/2026
CREATE OR REPLACE PROCEDURE insertAssociation (
    pDescription IN VARCHAR2,
    pName IN VARCHAR2,
    pPhone IN VARCHAR2,
    pEmail IN VARCHAR2)
IS
BEGIN
    INSERT INTO Association (id,name, description, phone, email)
    VALUES (s_association.NEXTVAL,pName, pDescription, pPhone, pEmail);
 
    COMMIT;
END insertAssociation;
/
-- Description: Modifies an existing Association.
-- Author:      Gabriel Zuñiga
-- Date:        30/9/2026
CREATE OR REPLACE PROCEDURE updateAssociation (
    pId IN NUMBER,
    pDescription IN VARCHAR2,
    pName IN VARCHAR2,
    pPhone IN VARCHAR2,
    pEmail IN VARCHAR2)
IS
BEGIN
    UPDATE Association
       SET name = pName,
            description = pDescription,
            phone = pPhone,
            email = pEmail
     WHERE id = pId;
 
    COMMIT;
END updateAssociation;
/
-- Description: Deletes an Association. It changes isActive to 0 (false)
-- Author:      Gabriel Zuñiga
-- Date:        4/10/2026
CREATE OR REPLACE PROCEDURE deleteAssociation (
    pId IN NUMBER)
IS
BEGIN
    UPDATE Association
       SET isActive = 0
     WHERE id = pId;
 
    COMMIT;
END deleteAssociation;
/

-- Description: Returns the total amount donated to each association. Every filter is optional
-- Author:      Gabriel Zuñiga
-- Date:        3/10/2026
CREATE OR REPLACE PROCEDURE totalByAssociation (
    pIdAssociation IN NUMBER,
    pFrom IN DATE,
    pUpTo IN DATE,
    pCurrencyId IN NUMBER,
    pCursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN pCursor FOR
        SELECT a.id AS idAssociation,
               a.name AS association,
               a.isActive AS isActive,
               c.id AS idCurrency,
               c.code AS currency,
               SUM(d.amount) AS totalAmount
          FROM Donation d
         INNER JOIN Association a
            ON d.associationId = a.id
         INNER JOIN Currency c
            ON d.currencyId = c.id
         WHERE (pIdAssociation IS NULL OR d.associationId = pIdAssociation)
            AND a.isActive = 1
            AND (pFrom IS NULL OR d.donationDate >= pFrom)
            AND (pUpTo IS NULL OR d.donationDate < pUpTo + 1)
            AND (pCurrencyId IS NULL OR d.currencyId = pCurrencyId)
         GROUP BY a.id, a.name, a.isActive, c.id, c.code
         ORDER BY c.code, totalAmount DESC;
END totalByAssociation;
/

-- Description: Returns the total amount, the highest and the lowest donation received by each association. Every filter is optional
-- Author:      Gabriel Zuñiga
-- Date:        23/10/2026
CREATE OR REPLACE PROCEDURE donationHighestLowestByAssociation (
    pIdAssociation IN NUMBER,
    pFrom IN DATE,
    pUpTo IN DATE,
    pCurrencyId IN NUMBER,
    pCursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN pCursor FOR
        SELECT a.id AS idAssociation,
               a.name AS association,
               c.id AS idCurrency,
               c.code AS currency,
               SUM(d.amount) AS totalAmount,
               MAX(d.amount) AS highestDonation,
               MIN(d.amount) AS lowestDonation
          FROM Donation d
         INNER JOIN Association a
            ON d.associationId = a.id
         INNER JOIN Currency c
            ON d.currencyId = c.id
         WHERE (pIdAssociation IS NULL OR d.associationId = pIdAssociation)
           AND a.isActive = 1
           AND (pFrom IS NULL OR d.donationDate >= pFrom)
           AND (pUpTo IS NULL OR d.donationDate < pUpTo + 1)
           AND (pCurrencyId IS NULL OR d.currencyId = pCurrencyId)
         GROUP BY a.id, a.name, c.id, c.code
         ORDER BY c.code, totalAmount DESC;
END donationHighestLowestByAssociation;
/




-----------------------------------
--Donation functions and procedures
-----------------------------------
-- Description: Creates a new Donation.
-- Author:      Gabriel Zuñiga
-- Date:        30/9/2026
CREATE OR REPLACE PROCEDURE insertDonation (
    pAmount IN NUMBER,
    pDonationTypeId IN NUMBER,
    pAppUserId IN NUMBER,
    pAssociationId IN NUMBER,
    pCurrencyId IN NUMBER)
IS
BEGIN
    INSERT INTO Donation (id, amount, donationDate, donationTypeId, appUserId, associationId, currencyId)
    VALUES (s_donation.NEXTVAL, pAmount, SYSDATE, pDonationTypeId, pAppUserId, pAssociationId, pCurrencyId);
END insertDonation;
/


-- Description: Registers a donation split among up to 3 associations.
--              The first association is required; the second and the third are optional
-- Author:      Gabriel Zuñiga
-- Date:        19/10/2026
CREATE OR REPLACE PROCEDURE insertMultipleDonations (
    pDonatorId IN NUMBER,
    pCurrencyId IN NUMBER,
    pTotalAmount IN NUMBER,
    pDonationTypeId IN NUMBER,
    pAssociation1 IN NUMBER,
    pPercentage1 IN NUMBER,
    pAssociation2 IN NUMBER,
    pPercentage2 IN NUMBER,
    pAssociation3 IN NUMBER,
    pPercentage3 IN NUMBER)
IS
BEGIN
    insertDonation(pTotalAmount * pPercentage1 / 100, pDonationTypeId, pDonatorId, pAssociation1, pCurrencyId);

    IF pAssociation2 IS NOT NULL THEN
        insertDonation(pTotalAmount * pPercentage2 / 100, pDonationTypeId, pDonatorId, pAssociation2, pCurrencyId);
    END IF;

    IF pAssociation3 IS NOT NULL THEN
        insertDonation(pTotalAmount * pPercentage3 / 100, pDonationTypeId, pDonatorId, pAssociation3, pCurrencyId);
    END IF;

    COMMIT;
END insertMultipleDonations;
/
-- Description: Modifies an existing Donation.
-- Author:      Gabriel Zuñiga
-- Date:        30/9/2026
CREATE OR REPLACE PROCEDURE updateDonation (
    pId IN NUMBER,
    pAmount IN NUMBER,
    pDate IN DATE,
    pDonationTypeId IN NUMBER,
    pDonatorId IN NUMBER,
    pAssociationId IN NUMBER,
    pCurrencyId IN NUMBER)
IS
BEGIN
    UPDATE Donation
       SET amount = pAmount,
           donationDate = pDate,
           donationTypeId = pDonationTypeId,
           appUserId = pDonatorId,
           associationId = pAssociationId,
           currencyId = pCurrencyId
     WHERE id = pId;

    COMMIT;
END updateDonation;
/
-- Description: Counts the donations that match the filters. Filters are optional
--              Returns 0 when no donation matches.
-- Author:      Gabriel Zuñiga
-- Date:        3/10/2026
CREATE OR REPLACE PROCEDURE countDonations (
    pIdUser IN NUMBER,
    pIdAssociation IN NUMBER,
    pAmount IN NUMBER,
    pFrom IN DATE,
    pUpTo IN DATE,
    pTotal OUT NUMBER)
IS
BEGIN
    SELECT COUNT(*)
      INTO pTotal
      FROM Donation d
     INNER JOIN Association a
        ON d.associationId = a.id
     WHERE (pIdUser IS NULL OR d.appUserId = pIdUser)
        AND a.isActive = 1
        AND (pIdAssociation IS NULL OR d.associationId = pIdAssociation)
        AND (pAmount IS NULL OR d.amount = pAmount)
        AND (pFrom IS NULL OR d.donationDate >= pFrom)
        AND (pUpTo IS NULL OR d.donationDate < pUpTo + 1);
END countDonations;
/
-- Description: Searches donations. Every filter is optional
-- Author:      Gabriel Zuñiga
-- Date:        5/10/2026
CREATE OR REPLACE PROCEDURE searchDonations (
    pIdUser IN NUMBER,
    pIdAssociation IN NUMBER,
    pAmount IN NUMBER,
    pFrom IN DATE,
    pUpTo IN DATE,
    pCursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN pCursor FOR
        SELECT d.id AS idDonation,
            d.amount,
            d.donationDate,
            dt.id AS idDonationType,
            dt.name AS donationType,
            a.id AS idAssociation,
            a.name AS association,
            p.id AS idUser,
            p.firstName || ' ' ||
            NVL(p.secondName || ' ', '') ||
            p.firstSurname || ' ' ||
            NVL(p.secondSurname, '') AS fullName
        FROM Donation d
        INNER JOIN Person p
        ON d.appUserId = p.id
        INNER JOIN Association a
        ON d.associationId = a.id
        INNER JOIN DonationType dt
        ON d.donationTypeId = dt.id
        WHERE (pIdUser IS NULL OR d.appUserId = pIdUser)
            AND a.isActive = 1
            AND (pIdAssociation IS NULL OR d.associationId = pIdAssociation)
            AND (pAmount IS NULL OR d.amount = pAmount)
            AND (pFrom IS NULL OR d.donationDate >= pFrom)
            AND (pUpTo IS NULL OR d.donationDate < pUpTo + 1)
        ORDER BY d.donationDate DESC;
         
END searchDonations;
/


-- Description: Calculates the total amount of the donations. Every filter is optional.
-- Author:      Gabriel Zuñiga
-- Date:        5/10/2026
CREATE OR REPLACE PROCEDURE sumDonations (
    pIdUser IN NUMBER,
    pIdAssociation IN NUMBER,
    pAmount IN NUMBER,
    pFrom IN DATE,
    pUpTo IN DATE,
    pCurrencyId IN NUMBER,
    pTotal OUT NUMBER)
IS
BEGIN
    SELECT NVL(SUM(d.amount), 0)
    INTO pTotal
    FROM Donation d
    INNER JOIN Association a
    ON d.associationId = a.id
    WHERE (pIdUser IS NULL OR d.appUserId = pIdUser)
        AND a.isActive = 1
        AND (pIdAssociation IS NULL OR d.associationId = pIdAssociation)
        AND (pAmount IS NULL OR d.amount = pAmount)
        AND (pFrom IS NULL OR d.donationDate >= pFrom)
        AND (pUpTo IS NULL OR d.donationDate < pUpTo + 1)
        AND (pCurrencyId IS NULL OR d.currencyId = pCurrencyId);
END sumDonations;
/


-- Description: Verifies if the sum of the percentages is 100%.
-- Author:      Gabriel Zuñiga
-- Date:        30/9/2026
CREATE OR REPLACE FUNCTION sumPercentages (pPercentages IN SYS.ODCINUMBERLIST)
RETURN NUMBER
IS
    vTotal  NUMBER := 0;   
    vResult NUMBER;
BEGIN
    FOR i IN 1 .. pPercentages.COUNT LOOP
        vTotal := vTotal + NVL(pPercentages(i), 0);
    END LOOP;
 
    IF vTotal = 100 THEN
        vResult := 100;
    ELSE
        vResult := NULL;
    END IF;
 
    RETURN (vResult);
END sumPercentages;
/

-----------------------------------
--Log Functions and Procedures
-----------------------------------

-- Description: Inserts a record in the log.
-- Author:      Gabriel Zuñiga
-- Date:        4/10/2026
CREATE OR REPLACE PROCEDURE insertLog (
    pAffectedTable IN VARCHAR2,
    pAffectedSlot IN VARCHAR2,
    pLastValue IN VARCHAR2,
    pNewValue IN VARCHAR2,
    pOperationType IN VARCHAR2,
    pIdUser IN NUMBER)
IS
BEGIN
    INSERT INTO Log (id, affectedTable, affectedSlot, lastValue, newValue, logDate, operationType, userId)
    VALUES (s_log.NEXTVAL, pAffectedTable, pAffectedSlot, pLastValue, pNewValue, SYSDATE, pOperationType, pIdUser);
    
END insertLog;
/
-- Description: Searches the log. Every filter is optional
-- Author:      Gabriel Zuñiga
-- Date:        3/10/2026
CREATE OR REPLACE PROCEDURE searchLog (
    pAffectedTable IN VARCHAR2,
    pAffectedSlot IN VARCHAR2,
    pLastValue IN VARCHAR2,
    pNewValue IN VARCHAR2,
    pFrom IN DATE,
    pUpTo IN DATE,
    pOperationType IN VARCHAR2,
    pIdUser IN NUMBER,
    pCursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN pCursor FOR
        SELECT l.id AS idLog,
               l.affectedTable,
               l.affectedSlot,
               l.lastValue,
               l.newValue,
               l.logDate,
               l.operationType,
               l.userId
        FROM Log l
        WHERE (pAffectedTable IS NULL OR UPPER(l.affectedTable) = UPPER(pAffectedTable))
            AND (pAffectedSlot IS NULL OR UPPER(l.affectedSlot) = UPPER(pAffectedSlot))
            AND (pLastValue IS NULL OR UPPER(l.lastValue) LIKE '%' || UPPER(pLastValue) || '%')
            AND (pNewValue IS NULL OR UPPER(l.newValue) LIKE '%' || UPPER(pNewValue) || '%')
            AND (pFrom IS NULL OR l.logDate >= pFrom)
            AND (pUpTo IS NULL OR l.logDate < pUpTo + 1)
            AND (pOperationType IS NULL OR UPPER(l.operationType) = UPPER(pOperationType))
            AND (pIdUser IS NULL OR l.userId = pIdUser)
         ORDER BY l.logDate DESC;
END searchLog;
/
-- Description: Counts the log records that match the filters.
-- Author:      Gabriel Zuñiga
-- Date:        3/10/2026
CREATE OR REPLACE PROCEDURE countLog (
    pAffectedTable IN VARCHAR2,
    pAffectedSlot IN VARCHAR2,
    pLastValue IN VARCHAR2,
    pNewValue IN VARCHAR2,
    pFrom IN DATE,
    pUpTo IN DATE,
    pOperationType IN VARCHAR2,
    pIdUser IN NUMBER,
    pTotal OUT NUMBER)
IS
BEGIN
    SELECT COUNT(*)
      INTO pTotal
      FROM Log l
     WHERE (pAffectedTable IS NULL OR UPPER(l.affectedTable) = UPPER(pAffectedTable))
        AND (pAffectedSlot IS NULL OR UPPER(l.affectedSlot) = UPPER(pAffectedSlot))
        AND (pLastValue IS NULL OR UPPER(l.lastValue) LIKE '%' || UPPER(pLastValue) || '%')
        AND (pNewValue IS NULL OR UPPER(l.newValue) LIKE '%' || UPPER(pNewValue) || '%')
        AND (pFrom IS NULL OR l.logDate >= pFrom)
        AND (pUpTo IS NULL OR l.logDate < pUpTo + 1)
        AND (pOperationType IS NULL OR UPPER(l.operationType) = UPPER(pOperationType))
        AND (pIdUser IS NULL OR l.userId = pIdUser);
END countLog;
/
-----------------------------------
--Currency functions and procedures 
-----------------------------------
-- Description: Creates a new Currency.
-- Author:      Gabriel Zuñiga
-- Date:        11/10/2026
CREATE OR REPLACE PROCEDURE insertCurrency (
    pCode IN VARCHAR2,
    pName IN VARCHAR2)
IS
BEGIN
    INSERT INTO Currency (id, code, name)
    VALUES (s_currency.NEXTVAL, pCode, pName);
 
    COMMIT;
END insertCurrency;
/
 
 
-- Description: Modifies an existing Currency.
-- Author:      Gabriel Zuñiga
-- Date:        11/10/2026
CREATE OR REPLACE PROCEDURE updateCurrency (
    pId IN NUMBER,
    pCode IN VARCHAR2,
    pName IN VARCHAR2)
IS
BEGIN
    UPDATE Currency
       SET code = pCode,
           name = pName
     WHERE id = pId;
 
    COMMIT;
END updateCurrency;
/
-- Description: Searches currencies. Every filter is optional
--              Returns the result through an output cursor.
-- Author:      Gabriel Zuñiga
-- Date:        11/10/2026
CREATE OR REPLACE PROCEDURE searchCurrencies (
    pCode IN VARCHAR2,
    pName IN VARCHAR2,
    pCursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN pCursor FOR
        SELECT c.id AS idCurrency,
               c.code,
               c.name
        FROM Currency c
        WHERE (pCode IS NULL OR UPPER(c.code) LIKE '%' || UPPER(pCode) || '%')
        AND c.isActive = 1
        AND (pName IS NULL OR UPPER(c.name) LIKE '%' || UPPER(pName) || '%')
        ORDER BY c.name;
END searchCurrencies;
/
-- Description: Deletes a Currency. It changes isActive to 0 (false)
-- Author:      Gabriel Zuñiga
-- Date:        21/10/2026
CREATE OR REPLACE PROCEDURE deleteCurrency (
    pId IN NUMBER)
IS
BEGIN
    UPDATE Currency
       SET isActive = 0
     WHERE id = pId;

    COMMIT;
END deleteCurrency;
/





-----------------------------------
--SessionInfo functions and procedures  
-----------------------------------
-- Description: Registers the user who has just logged in
-- Author:      Gabriel Zuñiga
-- Date:        14/10/2026
CREATE OR REPLACE PROCEDURE insertSessionInfo (
    pIdUser IN NUMBER)
IS
BEGIN
    DELETE FROM SessionInfo; 

    INSERT INTO SessionInfo (userId)
    VALUES (pIdUser);

    COMMIT;
END insertSessionInfo;
/


-- Description: Removes the session of a user when they log out.
-- Author:      Gabriel Zuñiga
-- Date:        14/10/2026
CREATE OR REPLACE PROCEDURE deleteSessionInfo (
    pIdUser IN NUMBER)
IS
BEGIN
    DELETE FROM SessionInfo
    WHERE userId = pIdUser;

    COMMIT;
END deleteSessionInfo;
/














-----------------------------------
--DonationType functions and procedures  
-----------------------------------
-- Description: Creates a new DonationType.
-- Author:      Gabriel Zuñiga
-- Date:        21/10/2026
CREATE OR REPLACE PROCEDURE insertDonationType (
    pName IN VARCHAR2)
IS
BEGIN
    INSERT INTO DonationType (id, name)
    VALUES (s_donationType.NEXTVAL, pName);

    COMMIT;
END insertDonationType;
/
-- Description: Modifies an existing DonationType.
-- Author:      Gabriel Zuñiga
-- Date:        21/10/2026
CREATE OR REPLACE PROCEDURE updateDonationType (
    pId IN NUMBER,
    pName IN VARCHAR2)
IS
BEGIN
    UPDATE DonationType
       SET name = pName
     WHERE id = pId;

    COMMIT;
END updateDonationType;
/
-- Description: Deletes a DonationType. It changes isActive to 0 (false)
-- Author:      Gabriel Zuñiga
-- Date:        21/10/2026
CREATE OR REPLACE PROCEDURE deleteDonationType (
    pId IN NUMBER)
IS
BEGIN
    UPDATE DonationType
       SET isActive = 0
     WHERE id = pId;

    COMMIT;
END deleteDonationType;
/
-- Description: Searches donation types. Every filter is optional
--              Returns the result through an output cursor.
-- Author:      Gabriel Zuñiga
-- Date:        21/10/2026
CREATE OR REPLACE PROCEDURE searchDonationTypes (
    pName IN VARCHAR2,
    pCursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN pCursor FOR
        SELECT dt.id AS idDonationType,
               dt.name,
               dt.isActive
          FROM DonationType dt
         WHERE (pName IS NULL OR UPPER(dt.name) LIKE '%' || UPPER(pName) || '%')
           AND dt.isActive = 1
         ORDER BY dt.name;
END searchDonationTypes;
/


--TODO: CHEACKEAR SI HAY QUE CAMBIAR PROCEDURES CON S_ACCEPTERTYPE EN VEZ DE s_acceptedType
--TODO: TAMBIEN s_size -> s_petsize SI SE HIZO CAMBIO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------











/*==============================================
Package pkg_adoption
Description: adoptions, applications, foster homes and blacklist
==============================================*/

CREATE OR REPLACE PACKAGE pkg_adoption IS
    PROCEDURE registerAdoption(pnPetId IN NUMBER, pnAdopterId IN NUMBER, pnGiverId IN NUMBER, pdAdoptionDate IN DATE, pnRating IN NUMBER, pcNotes IN VARCHAR2);
    PROCEDURE rateAdoption(pnAdoptionId IN NUMBER, pnRating IN NUMBER, pcNotes IN VARCHAR2);
    PROCEDURE addToBlacklist(pnUserId IN NUMBER, pcReason IN VARCHAR2, pdReportDate IN DATE, pcGrade IN VARCHAR2, pcNotes IN VARCHAR2, pcReportedBy IN VARCHAR2);
    PROCEDURE registerFosterHome(pcName IN VARCHAR2, pcRequiresFood IN VARCHAR2, pnUserId IN NUMBER);
    PROCEDURE addAcceptedType(pnFosterHomeId IN NUMBER, pcName IN VARCHAR2);
    PROCEDURE addAcceptedSize(pnFosterHomeId IN NUMBER, pcName IN VARCHAR2);
    PROCEDURE createApplication(pnAdopterId IN NUMBER, pcName IN VARCHAR2, pdApplicationDate IN DATE, pnStatusId IN NUMBER);
    PROCEDURE addFormQuestion(pnApplicationId IN NUMBER, pcName IN VARCHAR2);
    PROCEDURE addFormAnswer(pnApplicationId IN NUMBER, pcName IN VARCHAR2);
    PROCEDURE updateApplicationStatus(pnApplicationId IN NUMBER, pnStatusId IN NUMBER);

    FUNCTION getBlacklistReport(pnUserId IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION getFosterHomes(pcType IN VARCHAR2, pcSize IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION getAdoptions(pdStartDate IN DATE, pdEndDate IN DATE, pnAdopterId IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION getApplications(pnAdopterId IN NUMBER, pnStatusId IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION getAdoptionStats(pcType IN VARCHAR2, pcBreed IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION isBlacklisted(pnUserId IN NUMBER) RETURN NUMBER;
    FUNCTION getAverageRating(pnAdopterId IN NUMBER) RETURN NUMBER;
END pkg_adoption;
/

CREATE OR REPLACE PACKAGE BODY pkg_adoption AS

    /*
    Description: registers an adoption and marks the pet as adopted
    */
    PROCEDURE registerAdoption(
        pnPetId IN NUMBER,
        pnAdopterId IN NUMBER,
        pnGiverId IN NUMBER,
        pdAdoptionDate IN DATE,
        pnRating IN NUMBER,
        pcNotes IN VARCHAR2
    )
    AS
    BEGIN
        INSERT INTO Adoption (
            id, 
            rating, 
            adoptionDate, 
            notes, 
            createdBy, 
            modifiedBy, 
            modifiedAt, 
            givePersonId, 
            adopterId, 
            petId
        )

        VALUES (
            s_adoption.NEXTVAL, 
            pnRating, 
            pdAdoptionDate, 
            pcNotes, 
            USER, 
            USER, 
            SYSDATE, 
            pnGiverId, 
            pnAdopterId, 
            pnPetId
        );
        UPDATE Pet
        SET statusId = (SELECT id FROM Status WHERE name = 'adoptado')
        WHERE id = pnPetId;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Could not register the adoption: ' || SQLERRM);
    END registerAdoption;

    /*
    Description: updates the rating and notes of an adoption
    */
    PROCEDURE rateAdoption(
        pnAdoptionId IN NUMBER, 
        pnRating IN NUMBER,
        pcNotes IN VARCHAR2
    )
    AS
        e_invalid_adoption EXCEPTION;
    BEGIN
        UPDATE Adoption
        SET rating = pnRating,
            notes = pcNotes,
            modifiedBy = USER,
            modifiedAt = SYSDATE
        WHERE  id=pnAdoptionId;
        IF SQL%NOTFOUND THEN
            RAISE e_invalid_adoption;
        END IF;

        COMMIT;
    EXCEPTION
    WHEN e_invalid_adoption THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No such adoption');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Could not rate the adoption: ' || SQLERRM);
    END rateAdoption;

    /*
    Description: adds a user to the blacklist
    */
    PROCEDURE addToBlacklist(
        pnUserId IN NUMBER,
        pcReason IN VARCHAR2,
        pdReportDate IN DATE,
        pcGrade IN VARCHAR2,
        pcNotes IN VARCHAR2,
        pcReportedBy IN VARCHAR2
    )
    AS
        e_invalid_user EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_invalid_user, -2291);
    BEGIN
        INSERT INTO Blacklist (
            id,
            reason,
            reportDate,
            grade,
            notes,
            reportedBy,
            createdBy,
            createdAt,
            modifiedBy,
            modifiedAt,
            userId
        )

        VALUES (
            s_blacklist.NEXTVAL,
            pcReason,
            pdReportDate,
            pcGrade,
            pcNotes,
            pcReportedBy,
            USER,
            SYSDATE,
            USER,
            SYSDATE,
            pnUserId
        );
        COMMIT;
    EXCEPTION
        WHEN e_invalid_user THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No such user');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Could not add the blacklist: ' || SQLERRM);
    END addToBlacklist;

    /*
    Description: registers a foster home for a user
    */
    PROCEDURE registerFosterHome(
        pcName IN VARCHAR2,
        pcRequiresFood IN VARCHAR2,
        pnUserId IN NUMBER
    )
    AS
        e_invalid_user EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_invalid_user, -2291);
    BEGIN
        INSERT INTO FosterHome(
            id,
            name,
            requiresFood,
            createdBy,
            createdAt,
            modifiedBy,
            modifiedAt,
            userId
        )

        VALUES(
            s_fosterhome.NEXTVAL,
            pcName,
            pcRequiresFood,
            USER,
            SYSDATE,
            USER,
            SYSDATE,
            pnUserId
        );
        COMMIT;
    EXCEPTION
        WHEN e_invalid_user THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No such user');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Could not add the foster home: ' || SQLERRM);
    END registerFosterHome;

    /*
    Description: adds an accepted pet type to a foster home
    */
    PROCEDURE addAcceptedType(
        pnFosterHomeId IN NUMBER,
        pcName IN VARCHAR2
    )
    AS
        e_invalid_fosterHome EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_invalid_fosterHome, -2291);
    BEGIN
        INSERT INTO AcceptedType(
            id,
            name,
            createdBy,
            createdAt,
            modifiedBy,
            modifiedAt,
            fosterHomeId
        )

        VALUES(
            s_acceptedtype.NEXTVAL,
            pcName,
            USER,
            SYSDATE,
            USER,
            SYSDATE,
            pnFosterHomeId
        );
        COMMIT;
    EXCEPTION
        WHEN e_invalid_fosterHome THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No such foster home');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Could not add the type: ' || SQLERRM);

    END addAcceptedType;

    /*
    Description: adds an accepted pet size to a foster home
    */
    PROCEDURE addAcceptedSize(
        pnFosterHomeId IN NUMBER,
        pcName IN VARCHAR2
    )
    AS
        e_invalid_fosterHome EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_invalid_fosterHome, -2291);
    BEGIN
        INSERT INTO AcceptedSize(
            id,
            name,
            createdBy,
            createdAt,
            modifiedBy,
            modifiedAt,
            fosterHomeId
        )

        VALUES(
            s_acceptedsize.NEXTVAL,
            pcName,
            USER,
            SYSDATE,
            USER,
            SYSDATE,
            pnFosterHomeId
        );
        COMMIT;
    EXCEPTION
        WHEN e_invalid_fosterHome THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No such foster home');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Could not add the size: ' || SQLERRM);
    END addAcceptedSize;

    /*
    Description: creates an adoption application
    */
    PROCEDURE createApplication(
        pnAdopterId IN NUMBER,
        pcName IN VARCHAR2,
        pdApplicationDate IN DATE,
        pnStatusId IN NUMBER
    )
    AS
        e_invalid_reference EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_invalid_reference, -2291);
    BEGIN
        INSERT INTO AdoptionApplication(
            id,
            name,
            applicationDate,
            createdBy,
            createdAt,
            modifiedBy,
            modifiedAt,
            adopterId,
            statusId
        )

        VALUES(
            s_adoptionApplication.NEXTVAL,
            pcName,
            pdApplicationDate,
            USER,
            SYSDATE,
            USER,
            SYSDATE,
            pnAdopterId,
            pnStatusId
        );
        COMMIT;
    EXCEPTION
        WHEN e_invalid_reference THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No such adopter or status');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Could not add the application: ' || SQLERRM);

    END createApplication;

    /*
    Description: adds a question to an adoption application form
    */
    PROCEDURE addFormQuestion(
        pnApplicationId IN NUMBER,
        pcName IN VARCHAR2
    )
    AS
        e_invalid_applicationId EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_invalid_applicationId, -2291);
    BEGIN
        INSERT INTO FormQuestion(
            id,
            name,
            createdBy,
            createdAt,
            modifiedBy,
            modifiedAt,
            aplicationId
        )

        VALUES(
            s_formQuestion.NEXTVAL,
            pcName,
            USER,
            SYSDATE,
            USER,
            SYSDATE,
            pnApplicationId
        );
        COMMIT;
    EXCEPTION
        WHEN e_invalid_applicationId THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No such application');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Could not add the Form question: ' || SQLERRM);
    END addFormQuestion;

    /*
    Description: adds an answer to an adoption application form
    */
    PROCEDURE addFormAnswer(
        pnApplicationId IN NUMBER,
        pcName IN VARCHAR2
    )
    AS
        e_invalid_applicationId EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_invalid_applicationId, -2291);
    BEGIN
        INSERT INTO FormAnswer(
            id,
            name,
            createdBy,
            createdAt,
            modifiedBy,
            modifiedAt,
            aplicationId
        )

        VALUES(
            s_formAnswer.NEXTVAL,
            pcName,
            USER,
            SYSDATE,
            USER,
            SYSDATE,
            pnApplicationId
        );
        COMMIT;
    EXCEPTION
        WHEN e_invalid_applicationId THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No such application');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Could not add the form answer: ' || SQLERRM);
    END addFormAnswer;

    /*
    Description: changes the status of an adoption application
    */
    PROCEDURE updateApplicationStatus(
        pnApplicationId IN NUMBER,
        pnStatusId IN NUMBER
    )
    AS
        e_invalid_application EXCEPTION;
        e_invalid_status EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_invalid_status, -2291);
    BEGIN
        UPDATE AdoptionApplication
        SET statusId = pnStatusId,
            modifiedBy = USER,
            modifiedAt = SYSDATE
        WHERE id = pnApplicationId;

        IF SQL%NOTFOUND THEN
            RAISE e_invalid_application;
        END IF;

        COMMIT;
    EXCEPTION
        WHEN e_invalid_application THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No such application');
        WHEN e_invalid_status THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('No such status');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Could not update the application status: ' || SQLERRM);
    END updateApplicationStatus;

    /*
    Description: returns the blacklist report, optionally filtered by user
    */
    FUNCTION getBlacklistReport(
        pnUserId IN NUMBER
    )
    RETURN SYS_REFCURSOR
    IS
        vrcResult SYS_REFCURSOR;
    BEGIN
        OPEN vrcResult FOR
            SELECT p.firstName, p.firstSurname, b.reason, b.reportDate, b.grade, b.notes, b.reportedBy, COUNT(*) OVER () total_registros
            FROM Blacklist b
            JOIN Person p
            ON b.userId = p.id
            WHERE (pnUserId IS NULL OR b.userId = pnUserId)
            ORDER BY b.reportDate DESC;

        RETURN vrcResult;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Could not get the blacklist report: ' || SQLERRM);
            RETURN NULL;
    END getBlacklistReport;

    /*
    Description: returns the foster homes with their accepted types and sizes, optionally filtered by type and size
    */
    FUNCTION getFosterHomes(
        pcType IN VARCHAR2,
        pcSize IN VARCHAR2
    )
    RETURN SYS_REFCURSOR
    IS
        vrcResult SYS_REFCURSOR;
    BEGIN
        OPEN vrcResult FOR
            SELECT p.firstName, p.firstSurname, p.email, p.phone, ty.types, sz.sizes, f.name, f.requiresFood, COUNT(*) OVER () total_registros
            FROM FosterHome f
            JOIN Person p
            ON p.id = f.userId
            LEFT JOIN (SELECT fosterHomeId, listagg(name, ', ') WITHIN GROUP (ORDER BY name) AS types FROM AcceptedType GROUP BY fosterHomeId) ty
            ON ty.fosterHomeId = f.id
            LEFT JOIN (SELECT fosterHomeId, listagg(name, ', ') WITHIN GROUP (ORDER BY name) AS sizes FROM AcceptedSize GROUP BY fosterHomeId) sz
            ON sz.fosterHomeId = f.id
            WHERE (pcType IS NULL OR EXISTS (SELECT 1 FROM AcceptedType t WHERE t.fosterHomeId = f.id AND LOWER(t.name) = LOWER(pcType)))
            AND (pcSize IS NULL OR EXISTS (SELECT 1 FROM AcceptedSize s WHERE s.fosterHomeId = f.id AND LOWER(s.name) = LOWER(pcSize)));

        RETURN vrcResult;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Could not get the foster homes: ' || SQLERRM);
            RETURN NULL;
    END getFosterHomes;

    /*
    Description: returns the adoptions, optionally filtered by date range and adopter
    */
    FUNCTION getAdoptions(
        pdStartDate IN DATE,
        pdEndDate IN DATE,
        pnAdopterId IN NUMBER
    )
    RETURN SYS_REFCURSOR
    IS
        vrcResult SYS_REFCURSOR;
    BEGIN
        OPEN vrcResult FOR
            SELECT a.adoptionDate, a.rating, a.notes, p.name, p.chipId, ad.firstName adopter_firstName, ad.firstSurname adopter_firstSurname, gv.firstName giver_firstName, gv.firstSurname giver_firstSurname, COUNT(*) OVER () total_registros
            FROM Adoption a
            JOIN Pet p
            ON p.id = a.petId
            JOIN Person ad
            ON ad.id = a.adopterId
            JOIN Person gv
            ON gv.id = a.givePersonId
            WHERE (pdStartDate IS NULL OR a.adoptionDate >= pdStartDate)
            AND (pdEndDate IS NULL OR a.adoptionDate <= pdEndDate)
            AND (pnAdopterId IS NULL OR a.adopterId = pnAdopterId)
            ORDER BY a.adoptionDate DESC;

        RETURN vrcResult;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Could not get the adoptions: ' || SQLERRM);
            RETURN NULL;
    END getAdoptions;

    /*
    Description: returns the adoption applications with their questions and answers, optionally filtered by adopter and status
    */
    FUNCTION getApplications(
        pnAdopterId IN NUMBER,
        pnStatusId IN NUMBER
    )
    RETURN SYS_REFCURSOR
    IS
        vrcResult SYS_REFCURSOR;
    BEGIN
        OPEN vrcResult FOR
            SELECT a.name, a.applicationDate, s.name status, p.firstName, p.firstSurname, fq.questions, fa.answers, COUNT(*) OVER () total_registros
            FROM AdoptionApplication a
            JOIN Status s
            ON s.id = a.statusId
            JOIN Person p
            ON p.id = a.adopterId
            LEFT JOIN (SELECT aplicationId, listagg(name, ' | ') WITHIN GROUP (ORDER BY id) AS questions FROM FormQuestion GROUP BY aplicationId) fq
            ON fq.aplicationId = a.id
            LEFT JOIN (SELECT aplicationId, listagg(name, ' | ') WITHIN GROUP (ORDER BY id) AS answers FROM FormAnswer GROUP BY aplicationId) fa
            ON fa.aplicationId = a.id
            WHERE (pnAdopterId IS NULL OR a.adopterId = pnAdopterId)
            AND (pnStatusId IS NULL OR a.statusId = pnStatusId);

        RETURN vrcResult;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Could not get the applications: ' || SQLERRM);
            RETURN NULL;
    END getApplications;

    /*
    Description: returns adopted vs waiting pets and the adoption percentage, optionally filtered by pet type and breed
    */
    FUNCTION getAdoptionStats(
        pcType IN VARCHAR2,
        pcBreed IN VARCHAR2
    )
    RETURN SYS_REFCURSOR
    IS
        vrcResult SYS_REFCURSOR;
    BEGIN
        OPEN vrcResult FOR
            SELECT SUM(CASE WHEN s.name = 'adoptado' THEN 1 ELSE 0 END) adoptadas,
            SUM(CASE WHEN s.name = 'disponible' THEN 1 ELSE 0 END) en_espera,
            ROUND(SUM(CASE WHEN s.name = 'adoptado' THEN 1 ELSE 0 END) * 100 / NULLIF(SUM(CASE WHEN s.name IN ('adoptado', 'disponible') THEN 1 ELSE 0 END), 0), 2) porcentaje_adoptadas
            FROM Pet p
            JOIN Status s
            ON s.id = p.statusId
            JOIN Breed b
            ON b.id = p.breedId
            JOIN PetType pt
            ON pt.id = b.petTypeId
            WHERE (pcType IS NULL OR LOWER(pt.name) = LOWER(pcType))
            AND (pcBreed IS NULL OR LOWER(b.name) = LOWER(pcBreed));

        RETURN vrcResult;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Could not get the adoption stats: ' || SQLERRM);
            RETURN NULL;
    END getAdoptionStats;

    /*
    Description: returns 1 if the user is on the blacklist, 0 if not
    */
    FUNCTION isBlacklisted(
        pnUserId IN NUMBER
    )
    RETURN NUMBER
    IS
        vnCount NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO vnCount
        FROM Blacklist
        WHERE userId = pnUserId;

        IF vnCount > 0 THEN
            RETURN 1;
        END IF;
        RETURN 0;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Could not check the blacklist: ' || SQLERRM);
            RETURN NULL;
    END isBlacklisted;

    /*
    Description: returns the average adoption rating of an adopter
    */
    FUNCTION getAverageRating(
        pnAdopterId IN NUMBER
    )
    RETURN NUMBER
    IS
        vnAverage NUMBER;
    BEGIN
        SELECT AVG(rating)
        INTO vnAverage
        FROM Adoption
        WHERE adopterId = pnAdopterId;

        RETURN vnAverage;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Could not check the rating: ' || SQLERRM);
            RETURN NULL;
    END getAverageRating;

END pkg_adoption;
/






------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Description: Lists all animal sizes for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETANIMALSIZES (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT * FROM PetSize; END GETANIMALSIZES;
/
-- Description: Lists all breeds with pet type name for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETBREEDS (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT b.*, pt.name AS petTypeName FROM Breed b LEFT JOIN PetType pt ON b.petTypeId = pt.id; END GETBREEDS;
/
-- Description: Lists all colors for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETCOLORS (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT * FROM Color; END GETCOLORS;
/
-- Description: Lists all statuses for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETSTATUSES (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT * FROM Status; END GETSTATUSES;
/
-- Description: Lists all energy levels for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETENERGYLEVELS (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT * FROM EnergyLevel; END GETENERGYLEVELS;
/
-- Description: Lists all trainabilities for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETTRAINABILITIES (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT * FROM Trainability; END GETTRAINABILITIES;
/
-- Description: Lists all diseases for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETDISEASES (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT * FROM Disease; END GETDISEASES;
/
-- Description: Lists all severities for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETSEVERITIES (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT * FROM Severity; END GETSEVERITIES;
/
-- Description: Lists all pet types for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETPETTYPES (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT * FROM PetType; END GETPETTYPES;
/
-- Description: Lists all districts with canton name for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETDISTRICTS (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT d.*, c.name AS cantonName FROM District d LEFT JOIN Canton c ON d.cantonId = c.id; END GETDISTRICTS;
/
-- Description: Lists all rescuers with full name for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETRESCUERS (p_cursor OUT SYS_REFCURSOR) AS
BEGIN
    OPEN p_cursor FOR
    SELECT r.userId AS id,
           p.firstName || ' ' || p.firstSurname AS name
    FROM Rescuer r
    JOIN Person p ON r.userId = p.id;
END GETRESCUERS;
/
-- Description: Lists all foster homes for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETFOSTERHOMES (p_cursor OUT SYS_REFCURSOR) AS BEGIN OPEN p_cursor FOR SELECT * FROM FosterHome; END GETFOSTERHOMES;
/
-- Description: Lists all veterinarians with full name for parametrized combos.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETVETERINARIANS (p_cursor OUT SYS_REFCURSOR) AS
BEGIN
    OPEN p_cursor FOR
    SELECT v.userId AS id,
           p.firstName || ' ' || p.firstSurname AS name
    FROM Veterinarian v
    JOIN Person p ON v.userId = p.id;
END GETVETERINARIANS;
/



-- Description: Matches LOST vs FOUND pets scoring >= 60 percent.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GENERATE_AUTOMATIC_MATCHES
AS
    CURSOR c_lost IS
        SELECT p.id, p.dateOfBirth,
               pt.id AS petTypeIdCat, b.id AS breedIdCat, c.id AS colorIdCat, sz.id AS sizeIdCat,
               d.id AS districtIdCat, el.id AS energyLevelIdCat, t.id AS trainabilityIdCat,
               dis.id AS diseaseIdCat, sev.id AS severityIdCat
        FROM Pet p
        JOIN Status st ON p.statusId = st.id
        LEFT JOIN Breed b ON p.breedId = b.id
        LEFT JOIN PetType pt ON b.petTypeId = pt.id
        LEFT JOIN Color c ON p.colorId = c.id
        LEFT JOIN PetSize sz ON p.sizeId = sz.id
        LEFT JOIN District d ON p.districtId = d.id
        LEFT JOIN EnergyLevel el ON p.energyLevelId = el.id
        LEFT JOIN Trainability t ON p.trainabilityId = t.id
        LEFT JOIN Disease dis ON p.diseaseId = dis.id
        LEFT JOIN Severity sev ON p.severityId = sev.id
        WHERE UPPER(st.name) = 'LOST';

    CURSOR c_found IS
        SELECT p.id, p.dateOfBirth,
               pt.id AS petTypeIdCat, b.id AS breedIdCat, c.id AS colorIdCat, sz.id AS sizeIdCat,
               d.id AS districtIdCat, el.id AS energyLevelIdCat, t.id AS trainabilityIdCat,
               dis.id AS diseaseIdCat, sev.id AS severityIdCat
        FROM Pet p
        JOIN Status st ON p.statusId = st.id
        LEFT JOIN Breed b ON p.breedId = b.id
        LEFT JOIN PetType pt ON b.petTypeId = pt.id
        LEFT JOIN Color c ON p.colorId = c.id
        LEFT JOIN PetSize sz ON p.sizeId = sz.id
        LEFT JOIN District d ON p.districtId = d.id
        LEFT JOIN EnergyLevel el ON p.energyLevelId = el.id
        LEFT JOIN Trainability t ON p.trainabilityId = t.id
        LEFT JOIN Disease dis ON p.diseaseId = dis.id
        LEFT JOIN Severity sev ON p.severityId = sev.id
        WHERE UPPER(st.name) = 'FOUND';

    v_percent NUMBER := 0;
    v_matchId NUMBER;
    v_exists  NUMBER;
    v_ageDiff NUMBER;
BEGIN
    FOR lost_rec IN c_lost LOOP
        FOR found_rec IN c_found LOOP
            v_percent := 0;

            IF lost_rec.petTypeIdCat IS NOT NULL AND found_rec.petTypeIdCat IS NOT NULL AND lost_rec.petTypeIdCat = found_rec.petTypeIdCat THEN
                v_percent := v_percent + 20;
            END IF;

            IF lost_rec.breedIdCat IS NOT NULL AND found_rec.breedIdCat IS NOT NULL AND lost_rec.breedIdCat = found_rec.breedIdCat THEN
                v_percent := v_percent + 18;
            END IF;

            IF lost_rec.colorIdCat IS NOT NULL AND found_rec.colorIdCat IS NOT NULL AND lost_rec.colorIdCat = found_rec.colorIdCat THEN
                v_percent := v_percent + 12;
            END IF;

            IF lost_rec.sizeIdCat IS NOT NULL AND found_rec.sizeIdCat IS NOT NULL AND lost_rec.sizeIdCat = found_rec.sizeIdCat THEN
                v_percent := v_percent + 10;
            END IF;

            IF lost_rec.districtIdCat IS NOT NULL AND found_rec.districtIdCat IS NOT NULL AND lost_rec.districtIdCat = found_rec.districtIdCat THEN
                v_percent := v_percent + 10;
            END IF;

            IF lost_rec.energyLevelIdCat IS NOT NULL AND found_rec.energyLevelIdCat IS NOT NULL AND lost_rec.energyLevelIdCat = found_rec.energyLevelIdCat THEN
                v_percent := v_percent + 8;
            END IF;

            IF lost_rec.trainabilityIdCat IS NOT NULL AND found_rec.trainabilityIdCat IS NOT NULL AND lost_rec.trainabilityIdCat = found_rec.trainabilityIdCat THEN
                v_percent := v_percent + 7;
            END IF;

            IF lost_rec.diseaseIdCat IS NOT NULL AND found_rec.diseaseIdCat IS NOT NULL AND lost_rec.diseaseIdCat = found_rec.diseaseIdCat THEN
                v_percent := v_percent + 5;
            END IF;

            IF lost_rec.severityIdCat IS NOT NULL AND found_rec.severityIdCat IS NOT NULL AND lost_rec.severityIdCat = found_rec.severityIdCat THEN
                v_percent := v_percent + 5;
            END IF;

            IF lost_rec.dateOfBirth IS NOT NULL AND found_rec.dateOfBirth IS NOT NULL THEN
                v_ageDiff := ABS(MONTHS_BETWEEN(lost_rec.dateOfBirth, found_rec.dateOfBirth) / 12);
                IF v_ageDiff <= 1 THEN
                    v_percent := v_percent + 5;
                ELSIF v_ageDiff <= 2 THEN
                    v_percent := v_percent + 2.5;
                END IF;
            END IF;

            IF v_percent >= 60 THEN
                SELECT COUNT(*)
                  INTO v_exists
                  FROM Match
                 WHERE (lostPetId = lost_rec.id AND foundPetId = found_rec.id)
                    OR (lostPetId = found_rec.id AND foundPetId = lost_rec.id);

                IF v_exists = 0 THEN
                    v_matchId := S_MATCH.NEXTVAL;

                    INSERT INTO Match (id, percentaje, matchDate, createdBy, createdAt, modifiedBy, modifiedAt, lostPetId, foundPetId)
                    VALUES (v_matchId, ROUND(v_percent), SYSDATE, 'AutoJob', CURRENT_TIMESTAMP, 'AutoJob', CURRENT_TIMESTAMP, lost_rec.id, found_rec.id);

                    INSERT INTO Log (id, affectedTable, affectedSlot, lastValue, newValue, logDate, operationType, createdBy, createdAt, modifiedBy, modifiedAt, userId)
                    VALUES (S_LOG.NEXTVAL, 'MATCH', 'AUTO_MATCH', 'N/A', 'AUTO_MATCH_GENERATED', SYSDATE, 'INSERT', 'AutoJob', CURRENT_TIMESTAMP, 'AutoJob', CURRENT_TIMESTAMP, 1);
                END IF;
            END IF;
        END LOOP;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END GENERATE_AUTOMATIC_MATCHES;
/

-- Description: Inserts a new match and returns the generated id.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE INSERTMATCH (
    p_lostPetId NUMBER,
    p_foundPetId NUMBER,
    p_percentaje NUMBER,
    p_recordDate DATE,
    p_createdBy VARCHAR2,
    p_modifiedBy VARCHAR2,
    p_userId NUMBER,
    p_id OUT NUMBER
)
AS
BEGIN
    p_id := S_MATCH.NEXTVAL;
    INSERT INTO Match (id, percentaje, matchDate, createdBy, createdAt, modifiedBy, modifiedAt, lostPetId, foundPetId)
    VALUES (p_id, p_percentaje, p_recordDate, p_createdBy, CURRENT_TIMESTAMP, p_modifiedBy, CURRENT_TIMESTAMP, p_lostPetId, p_foundPetId);
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END INSERTMATCH;
/

-- Description: Lists matches for a given pet id.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETMATCHESBYPET (
    p_petId NUMBER,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
    SELECT m.*,
           lp.name AS lostPetName, fp.name AS foundPetName
    FROM Match m
    LEFT JOIN Pet lp ON m.lostPetId = lp.id
    LEFT JOIN Pet fp ON m.foundPetId = fp.id
    WHERE m.lostPetId = p_petId OR m.foundPetId = p_petId;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END GETMATCHESBYPET;
/
-- Description: Lists all matches with lost and found pet names.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETALLMATCHES (
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
    SELECT m.*,
           lp.name AS lostPetName, fp.name AS foundPetName
    FROM Match m
    LEFT JOIN Pet lp ON m.lostPetId = lp.id
    LEFT JOIN Pet fp ON m.foundPetId = fp.id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END GETALLMATCHES;
/
-- Description: Updates the percentage of a match by id.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE UPDATEMATCH (
    p_id NUMBER,
    p_percentaje NUMBER,
    p_modifiedBy VARCHAR2,
    p_userId NUMBER
)
AS
BEGIN
    UPDATE Match SET
        percentaje = p_percentaje,
        modifiedBy = p_modifiedBy,
        modifiedAt = CURRENT_TIMESTAMP
    WHERE id = p_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END UPDATEMATCH;
/
-- Description: Deletes a match by id.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE DELETEMATCH (
    p_id NUMBER,
    p_userId NUMBER
)
AS
BEGIN
    DELETE FROM Match WHERE id = p_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END DELETEMATCH;
/




-- Description: Inserts a new pet and returns the generated id.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE INSERTPET (
    p_name VARCHAR2,
    p_chipId VARCHAR2,
    p_dateOfBirth DATE,
    p_age NUMBER,
    p_recordDate DATE,
    p_rewardAmount NUMBER,
    p_needsSpace VARCHAR2,
    p_place VARCHAR2,
    p_description VARCHAR2,
    p_createdBy VARCHAR2,
    p_modifiedBy VARCHAR2,
    p_districtId NUMBER,
    p_breedId NUMBER,
    p_statusId NUMBER,
    p_colorId NUMBER,
    p_sizeId NUMBER,
    p_energyLevelId NUMBER,
    p_trainabilityId NUMBER,
    p_veterinarianId NUMBER,
    p_diseaseId NUMBER,
    p_fosterHomeId NUMBER,
    p_rescuerId NUMBER,
    p_severityId NUMBER,
    p_userId NUMBER,
    p_id OUT NUMBER
)
AS
BEGIN
    p_id := S_PET.NEXTVAL;
    INSERT INTO Pet (
        id, name, chipId, dateOfBirth, age, eventDate, rewardAmount, needsSpace, place, description,
        createdBy, createdAt, modifiedBy, modifiedAt,
        districtId, breedId, statusId, colorId, sizeId, energyLevelId, trainabilityId,
        veterinarianId, diseaseId, fosterHomeId, rescuerId, severityId
    ) VALUES (
        p_id, p_name, p_chipId, p_dateOfBirth, p_age, p_recordDate, p_rewardAmount, p_needsSpace, p_place, p_description,
        p_createdBy, CURRENT_TIMESTAMP, p_modifiedBy, CURRENT_TIMESTAMP,
        p_districtId, p_breedId, p_statusId, p_colorId, p_sizeId, p_energyLevelId, p_trainabilityId,
        p_veterinarianId, p_diseaseId, p_fosterHomeId, p_rescuerId, p_severityId
    );
   
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END INSERTPET;
/



-- Description: Updates all editable fields of a pet by id.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE UPDATEPET (
    p_id NUMBER,
    p_name VARCHAR2,
    p_chipId VARCHAR2,
    p_dateOfBirth DATE,
    p_age NUMBER,
    p_recordDate DATE,
    p_rewardAmount NUMBER,
    p_needsSpace VARCHAR2,
    p_place VARCHAR2,
    p_description VARCHAR2,
    p_modifiedBy VARCHAR2,
    p_districtId NUMBER,
    p_breedId NUMBER,
    p_statusId NUMBER,
    p_colorId NUMBER,
    p_sizeId NUMBER,
    p_energyLevelId NUMBER,
    p_trainabilityId NUMBER,
    p_veterinarianId NUMBER,
    p_diseaseId NUMBER,
    p_fosterHomeId NUMBER,
    p_rescuerId NUMBER,
    p_severityId NUMBER,
    p_userId NUMBER
)
AS
BEGIN
    UPDATE Pet SET
        name = p_name,
        chipId = p_chipId,
        dateOfBirth = p_dateOfBirth,
        age = p_age,
        eventDate = p_recordDate,
        rewardAmount = p_rewardAmount,
        needsSpace = p_needsSpace,
        place = p_place,
        description = p_description,
        modifiedBy = p_modifiedBy,
        modifiedAt = CURRENT_TIMESTAMP,
        districtId = p_districtId,
        breedId = p_breedId,
        statusId = p_statusId,
        colorId = p_colorId,
        sizeId = p_sizeId,
        energyLevelId = p_energyLevelId,
        trainabilityId = p_trainabilityId,
        veterinarianId = p_veterinarianId,
        diseaseId = p_diseaseId,
        fosterHomeId = p_fosterHomeId,
        rescuerId = p_rescuerId,
        severityId = p_severityId
    WHERE id = p_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END UPDATEPET;
/
-- Description: Returns a pet by id with catalog display names.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETPETBYID (
    p_id NUMBER,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
    SELECT p.*,
           b.name AS breedName, pt.name AS petTypeName,
           s.name AS statusName,
           c.name AS colorName,
           sz.name AS sizeName,
           el.name AS energyLevelName,
           t.name AS trainabilityName,
           d.name AS diseaseName,
           sev.name AS severityName,
           dis.name AS districtName,
           r.userId AS rescuerUserId,
           v.userId AS veterinarianUserId
    FROM Pet p
    LEFT JOIN Breed b ON p.breedId = b.id
    LEFT JOIN PetType pt ON b.petTypeId = pt.id
    LEFT JOIN Status s ON p.statusId = s.id
    LEFT JOIN Color c ON p.colorId = c.id
    LEFT JOIN PetSize sz ON p.sizeId = sz.id
    LEFT JOIN EnergyLevel el ON p.energyLevelId = el.id
    LEFT JOIN Trainability t ON p.trainabilityId = t.id
    LEFT JOIN Disease d ON p.diseaseId = d.id
    LEFT JOIN Severity sev ON p.severityId = sev.id
    LEFT JOIN District dis ON p.districtId = dis.id
    LEFT JOIN Rescuer r ON p.rescuerId = r.userId
    LEFT JOIN FosterHome fh ON p.fosterHomeId = fh.id
    LEFT JOIN Veterinarian v ON p.veterinarianId = v.userId
    WHERE p.id = p_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END GETPETBYID;
/



-- Description: Searches pets by optional filters, ordered by recordDate DESC.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE SEARCHPETS (
    p_name VARCHAR2 DEFAULT NULL,
    p_statusId NUMBER DEFAULT NULL,
    p_petTypeId NUMBER DEFAULT NULL,
    p_districtId NUMBER DEFAULT NULL,
    p_rescuerId NUMBER DEFAULT NULL,
    p_chipId VARCHAR2 DEFAULT NULL,
    p_breedId NUMBER DEFAULT NULL,
    p_place VARCHAR2 DEFAULT NULL,
    p_dateFrom DATE DEFAULT NULL,
    p_dateTo DATE DEFAULT NULL,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
    SELECT p.*,
           b.name AS breedName, pt.name AS petTypeName,
           s.name AS statusName,
           c.name AS colorName,
           sz.name AS sizeName,
           el.name AS energyLevelName,
           t.name AS trainabilityName,
           d.name AS diseaseName,
           sev.name AS severityName,
           dis.name AS districtName
    FROM Pet p
    LEFT JOIN Breed b ON p.breedId = b.id
    LEFT JOIN PetType pt ON b.petTypeId = pt.id
    LEFT JOIN Status s ON p.statusId = s.id
    LEFT JOIN Color c ON p.colorId = c.id
    LEFT JOIN PetSize sz ON p.sizeId = sz.id
    LEFT JOIN EnergyLevel el ON p.energyLevelId = el.id
    LEFT JOIN Trainability t ON p.trainabilityId = t.id
    LEFT JOIN Disease d ON p.diseaseId = d.id
    LEFT JOIN Severity sev ON p.severityId = sev.id
    LEFT JOIN District dis ON p.districtId = dis.id
    WHERE (p_name IS NULL OR UPPER(p.name) LIKE '%' || UPPER(p_name) || '%')
      AND (p_statusId IS NULL OR p.statusId = p_statusId)
      AND (p_petTypeId IS NULL OR pt.id = p_petTypeId)
      AND (p_districtId IS NULL OR p.districtId = p_districtId)
      AND (p_rescuerId IS NULL OR p.rescuerId = p_rescuerId)
      AND (p_chipId IS NULL OR UPPER(p.chipId) LIKE '%' || UPPER(p_chipId) || '%')
      AND (p_breedId IS NULL OR p.breedId = p_breedId)
      AND (p_place IS NULL OR UPPER(p.place) LIKE '%' || UPPER(p_place) || '%')
      AND (p_dateFrom IS NULL OR TRUNC(p.eventDate) >= TRUNC(p_dateFrom))
      AND (p_dateTo IS NULL OR TRUNC(p.eventDate) <= TRUNC(p_dateTo))
    ORDER BY p.eventDate DESC, p.id DESC;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END SEARCHPETS;
/


-- Description: Lists pets with status FOUND, LOST or IN_ADOPTION.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETAVAILABLEPETS (
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
    SELECT p.*,
           b.name AS breedName, pt.name AS petTypeName,
           s.name AS statusName
    FROM Pet p
    LEFT JOIN Breed b ON p.breedId = b.id
    LEFT JOIN PetType pt ON b.petTypeId = pt.id
    LEFT JOIN Status s ON p.statusId = s.id
    WHERE UPPER(s.name) IN ('FOUND', 'LOST', 'IN_ADOPTION');
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END GETAVAILABLEPETS;
/
-- Description: Deletes matches and photos of the pet first, then the pet.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE DELETEPET (
    p_id NUMBER,
    p_userId NUMBER
)
AS
BEGIN
    DELETE FROM Match WHERE lostPetId = p_id OR foundPetId = p_id;
    DELETE FROM Photo WHERE petId = p_id;
    DELETE FROM Pet WHERE id = p_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END DELETEPET;
/


-- Description: Counts pets by type and status in a date range.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETPETSBYSTATETYPEBYDATE (
    p_startDate DATE DEFAULT TRUNC(SYSDATE, 'YYYY'),
    p_endDate DATE DEFAULT SYSDATE,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
    SELECT pt.name AS petType,
           s.name AS status,
           COUNT(p.id) AS totalCount
    FROM Pet p
    JOIN Breed b ON p.breedId = b.id
    JOIN PetType pt ON b.petTypeId = pt.id
    JOIN Status s ON p.statusId = s.id
    WHERE TRUNC(p.eventDate) BETWEEN TRUNC(NVL(p_startDate, TRUNC(SYSDATE, 'YYYY'))) AND TRUNC(NVL(p_endDate, SYSDATE))
    GROUP BY pt.name, s.name
    ORDER BY pt.name, s.name;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END GETPETSBYSTATETYPEBYDATE;
/
-- Description: Counts and percentages unadopted pets by age range.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        22/10/2026
CREATE OR REPLACE PROCEDURE GETUNADOPTEDBYAGERANGE (
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
    WITH unadopted AS (
        SELECT p.id,
               TRUNC(MONTHS_BETWEEN(SYSDATE, p.dateOfBirth) / 12) AS ageYears
        FROM Pet p
        JOIN Status s ON p.statusId = s.id
        WHERE UPPER(s.name) <> 'ADOPTED'
    ),
    total_unadopted AS (
        SELECT COUNT(*) AS totalU FROM unadopted
    )
    SELECT 
        CASE 
            WHEN ageYears BETWEEN 0 AND 1 THEN '0-1'
            WHEN ageYears BETWEEN 1 AND 5 THEN '1-5'
            WHEN ageYears BETWEEN 5 AND 10 THEN '5-10'
            WHEN ageYears BETWEEN 10 AND 12 THEN '10-12'
            WHEN ageYears BETWEEN 12 AND 16 THEN '12-16'
            WHEN ageYears > 16 THEN '>16'
            ELSE 'UNKNOWN'
        END AS ageRange,
        COUNT(*) AS totalCount,
        (SELECT totalU FROM total_unadopted) AS totalUnadopted,
        ROUND((COUNT(*) * 100 / NULLIF((SELECT totalU FROM total_unadopted), 0)), 2) AS percentage
    FROM unadopted
    GROUP BY 
        CASE 
            WHEN ageYears BETWEEN 0 AND 1 THEN '0-1'
            WHEN ageYears BETWEEN 1 AND 5 THEN '1-5'
            WHEN ageYears BETWEEN 5 AND 10 THEN '5-10'
            WHEN ageYears BETWEEN 10 AND 12 THEN '10-12'
            WHEN ageYears BETWEEN 12 AND 16 THEN '12-16'
            WHEN ageYears > 16 THEN '>16'
            ELSE 'UNKNOWN'
        END
    ORDER BY 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END GETUNADOPTEDBYAGERANGE;
/


-- Description: Inserts a pet photo BLOB with BEFORE, AFTER or GENERAL type.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        25/10/2026
CREATE OR REPLACE PROCEDURE INSERTPHOTO (
    p_petId NUMBER,
    p_name VARCHAR2,
    p_image BLOB,
    p_photoType VARCHAR2,
    p_createdBy VARCHAR2,
    p_modifiedBy VARCHAR2,
    p_acceptedTypeId NUMBER DEFAULT NULL,
    p_typeId NUMBER DEFAULT NULL,
    p_userId NUMBER DEFAULT NULL,
    p_id OUT NUMBER
)
AS
BEGIN
    IF p_photoType NOT IN ('BEFORE', 'AFTER', 'GENERAL') THEN
        RAISE_APPLICATION_ERROR(-20001, 'photoType must be BEFORE, AFTER or GENERAL');
    END IF;
    p_id := S_PHOTO.NEXTVAL;
    INSERT INTO Photo (
        id, name, image, photoType, petId,
        createdBy, createdAt, modifiedBy, modifiedAt,
        acceptedTypeId, typeId
    ) VALUES (
        p_id, p_name, p_image, p_photoType, p_petId,
        p_createdBy, CURRENT_TIMESTAMP, p_modifiedBy, CURRENT_TIMESTAMP,
        p_acceptedTypeId, p_typeId
    );
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END INSERTPHOTO;
/

-- Description: Lists photo metadata of a pet, BEFORE first. Filters are optional. Returns empty when none matches.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        25/10/2026
CREATE OR REPLACE PROCEDURE GETPHOTOSBYPET (
    p_petId NUMBER,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
    SELECT id, name, photoType, petId, image,
           createdBy, createdAt, modifiedBy, modifiedAt,
           acceptedTypeId, typeId,
           DBMS_LOB.GETLENGTH(image) AS imageSize
    FROM Photo
    WHERE petId = p_petId
    ORDER BY CASE photoType WHEN 'BEFORE' THEN 1 WHEN 'AFTER' THEN 2 ELSE 3 END, id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END GETPHOTOSBYPET;
/

-- Description: Returns a single photo with BLOB by id.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        25/10/2026
CREATE OR REPLACE PROCEDURE GETPHOTOBYID (
    p_id NUMBER,
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
    SELECT id, name, photoType, petId, image,
           createdBy, createdAt, modifiedBy, modifiedAt,
           acceptedTypeId, typeId
    FROM Photo
    WHERE id = p_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END GETPHOTOBYID;
/

-- Description: Deletes a photo by id.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        25/10/2026
CREATE OR REPLACE PROCEDURE DELETEPHOTO (
    p_id NUMBER,
    p_userId NUMBER
)
AS
BEGIN
    DELETE FROM Photo WHERE id = p_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END DELETEPHOTO;
/

-- Description: Deletes all photos of a pet.
-- Author:      Alejandro Villalobos Ramírez
-- Date:        25/10/2026
CREATE OR REPLACE PROCEDURE DELETEPHOTOSBYPET (
    p_petId NUMBER,
    p_userId NUMBER
)
AS
BEGIN
    DELETE FROM Photo WHERE petId = p_petId;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END DELETEPHOTOSBYPET;
/










