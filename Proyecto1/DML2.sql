DECLARE
    v_owner NUMBER;
    v_luis NUMBER;
    v_sofia NUMBER;
    v_pablo NUMBER;

    v_disponible NUMBER;
    v_adoptado NUMBER;
    v_pendiente NUMBER;
    v_aprobada NUMBER;
    v_pequeno NUMBER;
    v_mediano NUMBER;
    v_grande NUMBER;
    v_perro NUMBER;
    v_gato NUMBER;
    v_negro NUMBER;
    v_blanco NUMBER;
    v_bajo NUMBER;
    v_alto NUMBER;
    v_facil NUMBER;
    v_dificil NUMBER;
    v_leve NUMBER;
    v_grave NUMBER;
    v_ninguna NUMBER;
    v_moquillo NUMBER;

    v_country NUMBER;
    v_province NUMBER;
    v_canton NUMBER;
    v_district NUMBER;
    v_criollo NUMBER;
    v_beagle NUMBER;

    v_fh1 NUMBER;
    v_fh2 NUMBER;
    v_michi NUMBER;
    v_rocky NUMBER;
    v_app1 NUMBER;
    v_app2 NUMBER;
    v_app3 NUMBER;

    -- Devuelve el id del registro del catalogo; si no existe, lo crea
    FUNCTION ins(p_table VARCHAR2,
                 p_seq VARCHAR2,
                 p_name VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT id FROM ' || p_table || ' WHERE name = :1'
            INTO v_id USING p_name;
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            EXECUTE IMMEDIATE 'INSERT INTO ' || p_table
                || ' (id, name, createdby, modifiedby, modifiedat) VALUES ('
                || p_seq || '.NEXTVAL, :1, ''p2'', ''p2'', SYSDATE) RETURNING id INTO :2'
                USING p_name RETURNING INTO v_id;
            RETURN v_id;
    END;

    -- Crea persona + usuario (clave123) + su rol (adopter o veterinarian)
    PROCEDURE add_person(p_first VARCHAR2,
                         p_second VARCHAR2,
                         p_surname1 VARCHAR2,
                         p_surname2 VARCHAR2,
                         p_email VARCHAR2,
                         p_phone NUMBER,
                         p_username VARCHAR2,
                         p_role VARCHAR2,
                         p_id OUT NUMBER) IS
    BEGIN
        INSERT INTO person (id, firstname, secondname, firstsurname, secondsurname, email, phone, createdby, modifiedby, modifiedat)
        VALUES (s_person.NEXTVAL, p_first, p_second, p_surname1, p_surname2, p_email, p_phone, 'p2', 'p2', SYSDATE)
        RETURNING id INTO p_id;

        INSERT INTO appuser (id, username, password, createdby, modifiedby, modifiedat)
        VALUES (p_id, p_username, RAWTOHEX(STANDARD_HASH('clave123', 'SHA256')), 'p2', 'p2', SYSDATE);

        EXECUTE IMMEDIATE 'INSERT INTO ' || p_role
            || ' (userid, createdby, modifiedby, modifiedat) VALUES (:1, ''p2'', ''p2'', SYSDATE)'
            USING p_id;
    END;
BEGIN
    -- Tu usuario admin (el dueno de las casas cuna, rescatista y quien da en adopcion)
    SELECT MIN(id) INTO v_owner FROM appuser WHERE isadmin = 1;
    IF v_owner IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Primero debe existir un usuario admin');
    END IF;

    -- ============ A1. catalogos ============
    v_disponible := ins('status', 's_status', 'disponible');
    v_adoptado   := ins('status', 's_status', 'adoptado');
    v_pendiente  := ins('status', 's_status', 'pendiente');
    v_aprobada   := ins('status', 's_status', 'aprobada');
    v_pequeno    := ins('petsize', 's_size', 'pequeno');
    v_mediano    := ins('petsize', 's_size', 'mediano');
    v_grande     := ins('petsize', 's_size', 'grande');
    v_perro      := ins('pettype', 's_pettype', 'perro');
    v_gato       := ins('pettype', 's_pettype', 'gato');
    v_negro      := ins('color', 's_color', 'negro');
    v_blanco     := ins('color', 's_color', 'blanco');
    v_bajo       := ins('energylevel', 's_energylevel', 'bajo');
    v_alto       := ins('energylevel', 's_energylevel', 'alto');
    v_facil      := ins('trainability', 's_trainability', 'facil');
    v_dificil    := ins('trainability', 's_trainability', 'dificil');
    v_leve       := ins('severity', 's_severity', 'leve');
    v_grave      := ins('severity', 's_severity', 'grave');
    v_ninguna    := ins('disease', 's_disease', 'ninguna');
    v_moquillo   := ins('disease', 's_disease', 'moquillo');

    -- ============ A2. ubicacion y raza ============
    v_country := ins('country', 's_country', 'costa rica');

    INSERT INTO province (id, name, countryid, createdby, modifiedby, modifiedat)
    VALUES (s_province.NEXTVAL, 'cartago', v_country, 'p2', 'p2', SYSDATE)
    RETURNING id INTO v_province;

    INSERT INTO canton (id, name, provinceid, createdby, modifiedby, modifiedat)
    VALUES (s_canton.NEXTVAL, 'cartago', v_province, 'p2', 'p2', SYSDATE)
    RETURNING id INTO v_canton;

    INSERT INTO district (id, name, cantonid, createdby, modifiedby, modifiedat)
    VALUES (s_district.NEXTVAL, 'oriental', v_canton, 'p2', 'p2', SYSDATE)
    RETURNING id INTO v_district;

    INSERT INTO breed (id, name, pettypeid, createdby, modifiedby, modifiedat)
    VALUES (s_breed.NEXTVAL, 'criollo', v_perro, 'p2', 'p2', SYSDATE)
    RETURNING id INTO v_criollo;

    INSERT INTO breed (id, name, pettypeid, createdby, modifiedby, modifiedat)
    VALUES (s_breed.NEXTVAL, 'beagle', v_gato, 'p2', 'p2', SYSDATE)
    RETURNING id INTO v_beagle;

    -- ============ A3. personas ============
    add_person('luis', 'diego', 'rojas', 'vargas', 'luis@test.com', 88880002, 'luis', 'adopter', v_luis);
    add_person('sofia', 'elena', 'araya', 'campos', 'sofia@test.com', 88880003, 'sofia', 'adopter', v_sofia);
    add_person('pablo', 'jose', 'quesada', 'mendez', 'pablo@test.com', 88880004, 'pablo', 'veterinarian', v_pablo);

    -- ============ B1. casa cuna ============
    INSERT INTO fosterhome (id, name, requiresfood, userid, createdby, modifiedby, modifiedat)
    VALUES (s_fosterhome.NEXTVAL, 'casa cuna patitas', 'si', v_owner, 'p2', 'p2', SYSDATE)
    RETURNING id INTO v_fh1;

    INSERT INTO fosterhome (id, name, requiresfood, userid, createdby, modifiedby, modifiedat)
    VALUES (s_fosterhome.NEXTVAL, 'casa cuna huellas', 'no', v_owner, 'p2', 'p2', SYSDATE)
    RETURNING id INTO v_fh2;

    INSERT INTO acceptedtype (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedtype.NEXTVAL, 'perro', v_fh1, 'p2', 'p2', SYSDATE);
    INSERT INTO acceptedtype (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedtype.NEXTVAL, 'gato', v_fh1, 'p2', 'p2', SYSDATE);
    INSERT INTO acceptedtype (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedtype.NEXTVAL, 'gato', v_fh2, 'p2', 'p2', SYSDATE);

    INSERT INTO acceptedsize (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedsize.NEXTVAL, 'pequeno', v_fh1, 'p2', 'p2', SYSDATE);
    INSERT INTO acceptedsize (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedsize.NEXTVAL, 'mediano', v_fh1, 'p2', 'p2', SYSDATE);
    INSERT INTO acceptedsize (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedsize.NEXTVAL, 'pequeno', v_fh2, 'p2', 'p2', SYSDATE);

    -- ============ A4. mascotas ============
    INSERT INTO pet (id, name, chipid, dateofbirth, age, eventdate, rewardamount, needsspace, place, description, createdby, modifiedby, modifiedat,
                     districtid, breedid, statusid, colorid, sizeid, energylevelid, trainabilityid, veterinarianid, diseaseid, fosterhomeid, rescuerid, severityid)
    VALUES (s_pet.NEXTVAL, 'firulais', 'chip001', DATE '2022-03-10', 4, DATE '2026-09-01', 0, 'patio', 'cartago', 'perro jugueton', 'p2', 'p2', SYSDATE,
            v_district, v_criollo, v_disponible, v_negro, v_mediano, v_alto, v_facil, v_pablo, v_ninguna, v_fh1, v_owner, v_leve);

    INSERT INTO pet (id, name, chipid, dateofbirth, age, eventdate, rewardamount, needsspace, place, description, createdby, modifiedby, modifiedat,
                     districtid, breedid, statusid, colorid, sizeid, energylevelid, trainabilityid, veterinarianid, diseaseid, fosterhomeid, rescuerid, severityid)
    VALUES (s_pet.NEXTVAL, 'michi', 'chip002', DATE '2023-05-20', 3, DATE '2026-09-10', 0, 'apartamento', 'cartago', 'gata tranquila', 'p2', 'p2', SYSDATE,
            v_district, v_beagle, v_adoptado, v_blanco, v_pequeno, v_bajo, v_facil, v_pablo, v_ninguna, v_fh2, v_owner, v_leve)
    RETURNING id INTO v_michi;

    INSERT INTO pet (id, name, chipid, dateofbirth, age, eventdate, rewardamount, needsspace, place, description, createdby, modifiedby, modifiedat,
                     districtid, breedid, statusid, colorid, sizeid, energylevelid, trainabilityid, veterinarianid, diseaseid, fosterhomeid, rescuerid, severityid)
    VALUES (s_pet.NEXTVAL, 'rocky', 'chip003', DATE '2021-01-15', 5, DATE '2026-08-15', 0, 'patio', 'cartago', 'perro adulto', 'p2', 'p2', SYSDATE,
            v_district, v_criollo, v_adoptado, v_negro, v_grande, v_alto, v_dificil, v_pablo, v_ninguna, v_fh1, v_owner, v_leve)
    RETURNING id INTO v_rocky;

    -- ============ B2. solicitudes y formulario ============
    INSERT INTO adoptionapplication (id, name, applicationdate, adopterid, statusid, createdby, modifiedby, modifiedat)
    VALUES (s_adoptionapplication.NEXTVAL, 'solicitud luis', DATE '2026-09-05', v_luis, v_aprobada, 'p2', 'p2', SYSDATE)
    RETURNING id INTO v_app1;

    INSERT INTO adoptionapplication (id, name, applicationdate, adopterid, statusid, createdby, modifiedby, modifiedat)
    VALUES (s_adoptionapplication.NEXTVAL, 'solicitud sofia', DATE '2026-09-12', v_sofia, v_aprobada, 'p2', 'p2', SYSDATE)
    RETURNING id INTO v_app2;

    INSERT INTO adoptionapplication (id, name, applicationdate, adopterid, statusid, createdby, modifiedby, modifiedat)
    VALUES (s_adoptionapplication.NEXTVAL, 'solicitud luis 2', DATE '2026-10-01', v_luis, v_pendiente, 'p2', 'p2', SYSDATE)
    RETURNING id INTO v_app3;

    INSERT INTO formquestion (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formquestion.NEXTVAL, 'tiene patio?', v_app1, 'p2', 'p2', SYSDATE);
    INSERT INTO formquestion (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formquestion.NEXTVAL, 'tiene otras mascotas?', v_app1, 'p2', 'p2', SYSDATE);
    INSERT INTO formquestion (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formquestion.NEXTVAL, 'tiene patio?', v_app2, 'p2', 'p2', SYSDATE);

    INSERT INTO formanswer (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formanswer.NEXTVAL, 'si', v_app1, 'p2', 'p2', SYSDATE);
    INSERT INTO formanswer (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formanswer.NEXTVAL, 'no', v_app1, 'p2', 'p2', SYSDATE);
    INSERT INTO formanswer (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formanswer.NEXTVAL, 'no', v_app2, 'p2', 'p2', SYSDATE);

    -- ============ B3. adopciones y lista negra ============
    INSERT INTO adoption (id, rating, adoptiondate, notes, givepersonid, adopterid, petid, createdby, modifiedby, modifiedat)
    VALUES (s_adoption.NEXTVAL, 5, DATE '2026-09-20', 'todo bien', v_owner, v_luis, v_rocky, 'p2', 'p2', SYSDATE);

    INSERT INTO adoption (id, rating, adoptiondate, notes, givepersonid, adopterid, petid, createdby, modifiedby, modifiedat)
    VALUES (s_adoption.NEXTVAL, 4, DATE '2026-09-25', 'se adapto', v_owner, v_sofia, v_michi, 'p2', 'p2', SYSDATE);

    INSERT INTO blacklist (id, reason, reportdate, grade, notes, reportedby, userid, createdby, modifiedby, modifiedat)
    VALUES (s_blacklist.NEXTVAL, 'maltrato', DATE '2026-10-02', 'grave', 'reportado por vecinos', 'ana', v_sofia, 'p2', 'p2', SYSDATE);

    INSERT INTO blacklist (id, reason, reportdate, grade, notes, reportedby, userid, createdby, modifiedby, modifiedat)
    VALUES (s_blacklist.NEXTVAL, 'abandono', DATE '2026-10-05', 'media', 'devolvio la mascota', 'ana', v_luis, 'p2', 'p2', SYSDATE);

    COMMIT;
END;
/























SELECT username FROM appuser;
SELECT name, chipid FROM pet;


DELETE FROM appuser WHERE username IN ('ana');
DELETE FROM person WHERE id NOT IN (SELECT id FROM appuser) AND createdby = 'p2';


-- verificacion: cada consulta debe devolver filas
SELECT 'fosterhome' t, COUNT(*) n FROM fosterhome UNION ALL
SELECT 'acceptedtype', COUNT(*) FROM acceptedtype UNION ALL
SELECT 'acceptedsize', COUNT(*) FROM acceptedsize UNION ALL
SELECT 'adoptionapplication', COUNT(*) FROM adoptionapplication UNION ALL
SELECT 'formquestion', COUNT(*) FROM formquestion UNION ALL
SELECT 'formanswer', COUNT(*) FROM formanswer UNION ALL
SELECT 'adoption', COUNT(*) FROM adoption UNION ALL
SELECT 'blacklist', COUNT(*) FROM blacklist;







DECLARE
    v_id NUMBER;
BEGIN
    SELECT id INTO v_id FROM appuser WHERE username = 'ana';

    DELETE FROM sessioninfo WHERE userid = v_id;
    DELETE FROM donation WHERE appuserid = v_id;
    DELETE FROM blacklist WHERE userid = v_id;
    DELETE FROM adoption WHERE adopterid = v_id OR givepersonid = v_id;
    DELETE FROM formanswer WHERE aplicationid IN (SELECT id FROM adoptionapplication WHERE adopterid = v_id);
    DELETE FROM formquestion WHERE aplicationid IN (SELECT id FROM adoptionapplication WHERE adopterid = v_id);
    DELETE FROM adoptionapplication WHERE adopterid = v_id;
    DELETE FROM acceptedtype WHERE fosterhomeid IN (SELECT id FROM fosterhome WHERE userid = v_id);
    DELETE FROM acceptedsize WHERE fosterhomeid IN (SELECT id FROM fosterhome WHERE userid = v_id);
    DELETE FROM fosterhome WHERE userid = v_id;
    DELETE FROM adopter WHERE userid = v_id;
    DELETE FROM veterinarian WHERE userid = v_id;
    DELETE FROM appuser WHERE id = v_id;
    DELETE FROM person WHERE id = v_id;

    COMMIT;
END;
/