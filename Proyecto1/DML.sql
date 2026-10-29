/*
dml persona 2 - datos de prueba
ejecutar conectado como bienestar_animal (bienestar_xe) con f5, despues de crear
tablas, secuencias e indices.

seccion a = filas minimas de tablas de OTROS companeros (solo para poder probar).
            cuando ellos suban su dml, se borran con DML_borrar_pruebas.sql
seccion b = tus tablas (persona 2).
pet va en medio porque necesita fosterhome (tuya) y adoption necesita pet.
*/

--TODO: Cada id se debe pasar a que sea la secuencia de esa tabla
-- ============ A1. catalogos (ajenos) ============
INSERT INTO status       (id, name, createdby, modifiedby, modifiedat) VALUES (1, 'disponible', 'p2', 'p2', SYSDATE);
INSERT INTO status       (id, name, createdby, modifiedby, modifiedat) VALUES (2, 'adoptado',   'p2', 'p2', SYSDATE);
INSERT INTO status       (id, name, createdby, modifiedby, modifiedat) VALUES (3, 'pendiente',  'p2', 'p2', SYSDATE);
INSERT INTO status       (id, name, createdby, modifiedby, modifiedat) VALUES (4, 'aprobada',   'p2', 'p2', SYSDATE);
INSERT INTO petsize      (id, name, createdby, modifiedby, modifiedat) VALUES (1, 'pequeno', 'p2', 'p2', SYSDATE);
INSERT INTO petsize      (id, name, createdby, modifiedby, modifiedat) VALUES (2, 'mediano', 'p2', 'p2', SYSDATE);
INSERT INTO petsize      (id, name, createdby, modifiedby, modifiedat) VALUES (3, 'grande',  'p2', 'p2', SYSDATE);
INSERT INTO pettype      (id, name, createdby, modifiedby, modifiedat) VALUES (1, 'perro', 'p2', 'p2', SYSDATE);
INSERT INTO pettype      (id, name, createdby, modifiedby, modifiedat) VALUES (2, 'gato',  'p2', 'p2', SYSDATE);
INSERT INTO color        (id, name, createdby, modifiedby, modifiedat) VALUES (1, 'negro',  'p2', 'p2', SYSDATE);
INSERT INTO color        (id, name, createdby, modifiedby, modifiedat) VALUES (2, 'blanco', 'p2', 'p2', SYSDATE);
INSERT INTO energylevel  (id, name, createdby, modifiedby, modifiedat) VALUES (1, 'bajo',  'p2', 'p2', SYSDATE);
INSERT INTO energylevel  (id, name, createdby, modifiedby, modifiedat) VALUES (2, 'alto',  'p2', 'p2', SYSDATE);
INSERT INTO trainability (id, name, createdby, modifiedby, modifiedat) VALUES (1, 'facil',   'p2', 'p2', SYSDATE);
INSERT INTO trainability (id, name, createdby, modifiedby, modifiedat) VALUES (2, 'dificil', 'p2', 'p2', SYSDATE);
INSERT INTO severity     (id, name, createdby, modifiedby, modifiedat) VALUES (1, 'leve',  'p2', 'p2', SYSDATE);
INSERT INTO severity     (id, name, createdby, modifiedby, modifiedat) VALUES (2, 'grave', 'p2', 'p2', SYSDATE);
INSERT INTO disease      (id, name, createdby, modifiedby, modifiedat) VALUES (1, 'ninguna', 'p2', 'p2', SYSDATE);
INSERT INTO disease      (id, name, createdby, modifiedby, modifiedat) VALUES (2, 'moquillo', 'p2', 'p2', SYSDATE);

-- ============ A2. ubicacion y raza (ajenos) ============
INSERT INTO country  (id, name, createdby, modifiedby, modifiedat) VALUES (1, 'costa rica', 'p2', 'p2', SYSDATE);
INSERT INTO province (id, name, countryid,  createdby, modifiedby, modifiedat) VALUES (1, 'cartago', 1, 'p2', 'p2', SYSDATE);
INSERT INTO canton   (id, name, provinceid, createdby, modifiedby, modifiedat) VALUES (1, 'cartago', 1, 'p2', 'p2', SYSDATE);
INSERT INTO district (id, name, cantonid,   createdby, modifiedby, modifiedat) VALUES (1, 'oriental', 1, 'p2', 'p2', SYSDATE);
INSERT INTO breed    (id, name, pettypeid,  createdby, modifiedby, modifiedat) VALUES (1, 'criollo', 1, 'p2', 'p2', SYSDATE);
INSERT INTO breed    (id, name, pettypeid,  createdby, modifiedby, modifiedat) VALUES (2, 'siames',  2, 'p2', 'p2', SYSDATE);

-- ============ A3. personas (ajenas) ============
/*
-- 2. Luis (Adoptante)
INSERT INTO person (id, firstname, secondname, firstsurname, secondsurname, email, phone, createdby, modifiedby, modifiedat) 
VALUES (s_person.NEXTVAL, 'luis', 'diego', 'rojas', 'vargas', 'luis@test.com', 88880002, 'p2', 'p2', SYSDATE);

INSERT INTO appuser (id, username, password, createdby, modifiedby, modifiedat) 
VALUES (s_person.CURRVAL, 'luis', 'clave123', 'p2', 'p2', SYSDATE);

INSERT INTO adopter (userid, createdby, modifiedby, modifiedat) 
VALUES (s_person.CURRVAL, 'p2', 'p2', SYSDATE);


-- 3. Sofia (Adoptante)
INSERT INTO person (id, firstname, secondname, firstsurname, secondsurname, email, phone, createdby, modifiedby, modifiedat) 
VALUES (s_person.NEXTVAL, 'sofia', 'elena', 'araya', 'campos', 'sofia@test.com', 88880003, 'p2', 'p2', SYSDATE);

INSERT INTO appuser (id, username, password, createdby, modifiedby, modifiedat) 
VALUES (s_person.CURRVAL, 'sofia', 'clave123', 'p2', 'p2', SYSDATE);

INSERT INTO adopter (userid, createdby, modifiedby, modifiedat) 
VALUES (s_person.CURRVAL, 'p2', 'p2', SYSDATE);


-- 4. Pablo (Veterinario)
INSERT INTO person (id, firstname, secondname, firstsurname, secondsurname, email, phone, createdby, modifiedby, modifiedat) 
VALUES (s_person.NEXTVAL, 'pablo', 'jose', 'quesada', 'mendez', 'pablo@test.com', 88880004, 'p2', 'p2', SYSDATE);

INSERT INTO appuser (id, username, password, createdby, modifiedby, modifiedat) 
VALUES (s_person.CURRVAL, 'pablo', 'clave123', 'p2', 'p2', SYSDATE);

INSERT INTO veterinarian (userid, createdby, modifiedby, modifiedat) 
VALUES (s_person.CURRVAL, 'p2', 'p2', SYSDATE);
*/
-- ============ B1. casa cuna ============
INSERT INTO fosterhome (id, name, requiresfood, userid, createdby, modifiedby, modifiedat) VALUES (s_fosterhome.NEXTVAL, 'casa cuna patitas', 'si', 1, 'p2', 'p2', SYSDATE);
INSERT INTO fosterhome (id, name, requiresfood, userid, createdby, modifiedby, modifiedat) VALUES (s_fosterhome.NEXTVAL, 'casa cuna huellas', 'no', 1, 'p2', 'p2', SYSDATE);

INSERT INTO acceptedtype (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedtype.NEXTVAL, 'perro', 1, 'p2', 'p2', SYSDATE);
INSERT INTO acceptedtype (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedtype.NEXTVAL, 'gato',  1, 'p2', 'p2', SYSDATE);
INSERT INTO acceptedtype (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedtype.NEXTVAL, 'gato',  2, 'p2', 'p2', SYSDATE);

INSERT INTO acceptedsize (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedsize.NEXTVAL, 'pequeno', 1, 'p2', 'p2', SYSDATE);
INSERT INTO acceptedsize (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedsize.NEXTVAL, 'mediano', 1, 'p2', 'p2', SYSDATE);
INSERT INTO acceptedsize (id, name, fosterhomeid, createdby, modifiedby, modifiedat) VALUES (s_acceptedsize.NEXTVAL, 'pequeno', 2, 'p2', 'p2', SYSDATE);

-- ============ A4. pet (ajena, necesita fosterhome de arriba) ============
INSERT INTO pet (id, name, chipid, dateofbirth, age, eventdate, rewardamount, needsspace, place, description, createdby, modifiedby, modifiedat,
                 districtid, breedid, statusid, colorid, sizeid, energylevelid, trainabilityid, veterinarianid, diseaseid, fosterhomeid, rescuerid, severityid)
VALUES (1, 'firulais', 'chip001', DATE '2022-03-10', 4, DATE '2026-09-01', 0, 'patio', 'cartago', 'perro jugueton', 'p2', 'p2', SYSDATE,
        1, 1, 1, 1, 2, 2, 1, 4, 1, 1, 1, 1);
INSERT INTO pet (id, name, chipid, dateofbirth, age, eventdate, rewardamount, needsspace, place, description, createdby, modifiedby, modifiedat,
                 districtid, breedid, statusid, colorid, sizeid, energylevelid, trainabilityid, veterinarianid, diseaseid, fosterhomeid, rescuerid, severityid)
VALUES (2, 'michi', 'chip002', DATE '2023-05-20', 3, DATE '2026-09-10', 0, 'apartamento', 'cartago', 'gata tranquila', 'p2', 'p2', SYSDATE,
        1, 2, 2, 2, 1, 1, 1, 4, 1, 2, 1, 1);
INSERT INTO pet (id, name, chipid, dateofbirth, age, eventdate, rewardamount, needsspace, place, description, createdby, modifiedby, modifiedat,
                 districtid, breedid, statusid, colorid, sizeid, energylevelid, trainabilityid, veterinarianid, diseaseid, fosterhomeid, rescuerid, severityid)
VALUES (3, 'rocky', 'chip003', DATE '2021-01-15', 5, DATE '2026-08-15', 0, 'patio', 'cartago', 'perro adulto', 'p2', 'p2', SYSDATE,
        1, 1, 2, 1, 3, 2, 2, 4, 1, 1, 1, 1);

-- ============ B2. tus tablas: solicitudes y formulario ============
INSERT INTO adoptionapplication (id, name, applicationdate, adopterid, statusid, createdby, modifiedby, modifiedat) VALUES (s_adoptionapplication.NEXTVAL, 'solicitud luis',  DATE '2026-09-05', 2, 4, 'p2', 'p2', SYSDATE);
INSERT INTO adoptionapplication (id, name, applicationdate, adopterid, statusid, createdby, modifiedby, modifiedat) VALUES (s_adoptionapplication.NEXTVAL, 'solicitud sofia', DATE '2026-09-12', 3, 4, 'p2', 'p2', SYSDATE);
INSERT INTO adoptionapplication (id, name, applicationdate, adopterid, statusid, createdby, modifiedby, modifiedat) VALUES (s_adoptionapplication.NEXTVAL, 'solicitud luis 2', DATE '2026-10-01', 2, 3, 'p2', 'p2', SYSDATE);

INSERT INTO formquestion (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formquestion.NEXTVAL, 'tiene patio?', 1, 'p2', 'p2', SYSDATE);
INSERT INTO formquestion (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formquestion.NEXTVAL, 'tiene otras mascotas?', 1, 'p2', 'p2', SYSDATE);
INSERT INTO formquestion (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formquestion.NEXTVAL, 'tiene patio?', 2, 'p2', 'p2', SYSDATE);

INSERT INTO formanswer (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formanswer.NEXTVAL, 'si', 1, 'p2', 'p2', SYSDATE);
INSERT INTO formanswer (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formanswer.NEXTVAL, 'no', 1, 'p2', 'p2', SYSDATE);
INSERT INTO formanswer (id, name, aplicationid, createdby, modifiedby, modifiedat) VALUES (s_formanswer.NEXTVAL, 'no', 2, 'p2', 'p2', SYSDATE);

-- ============ B3. tus tablas: adopciones y lista negra ============
INSERT INTO adoption (id, rating, adoptiondate, notes, givepersonid, adopterid, petid, createdby, modifiedby, modifiedat) VALUES (s_adoption.NEXTVAL, 5, DATE '2026-09-20', 'todo bien', 1, 2, 3, 'p2', 'p2', SYSDATE);
INSERT INTO adoption (id, rating, adoptiondate, notes, givepersonid, adopterid, petid, createdby, modifiedby, modifiedat) VALUES (s_adoption.NEXTVAL, 4, DATE '2026-09-25', 'se adapto', 1, 3, 2, 'p2', 'p2', SYSDATE);

INSERT INTO blacklist (id, reason, reportdate, grade, notes, reportedby, userid, createdby, modifiedby, modifiedat) VALUES (s_blacklist.NEXTVAL, 'maltrato', DATE '2026-10-02', 'grave', 'reportado por vecinos', 'ana', 3, 'p2', 'p2', SYSDATE);
INSERT INTO blacklist (id, reason, reportdate, grade, notes, reportedby, userid, createdby, modifiedby, modifiedat) VALUES (s_blacklist.NEXTVAL, 'abandono', DATE '2026-10-05', 'media', 'devolvio la mascota', 'ana', 2, 'p2', 'p2', SYSDATE);

COMMIT;

-- verificacion: cada consulta debe devolver filas
SELECT 'fosterhome' t, COUNT(*) n FROM fosterhome UNION ALL
SELECT 'acceptedtype', COUNT(*) FROM acceptedtype UNION ALL
SELECT 'acceptedsize', COUNT(*) FROM acceptedsize UNION ALL
SELECT 'adoptionapplication', COUNT(*) FROM adoptionapplication UNION ALL
SELECT 'formquestion', COUNT(*) FROM formquestion UNION ALL
SELECT 'formanswer', COUNT(*) FROM formanswer UNION ALL
SELECT 'adoption', COUNT(*) FROM adoption UNION ALL
SELECT 'blacklist', COUNT(*) FROM blacklist;






-- 1. Eliminar dependencias finales (adopciones, listas negras y respuestas)
DELETE FROM blacklist;
DELETE FROM adoption;
DELETE FROM formanswer;
DELETE FROM formquestion;
DELETE FROM adoptionapplication;

-- 2. Eliminar mascotas y detalles de casa cuna
DELETE FROM pet;
DELETE FROM acceptedsize;
DELETE FROM acceptedtype;
DELETE FROM fosterhome;

-- 4. Eliminar ubicaciones y razas
DELETE FROM breed;
DELETE FROM district;
DELETE FROM canton;
DELETE FROM province;
DELETE FROM country;

-- 5. Eliminar catálogos base
DELETE FROM disease;
DELETE FROM severity;
DELETE FROM trainability;
DELETE FROM energylevel;
DELETE FROM color;
DELETE FROM pettype;
DELETE FROM petsize;
DELETE FROM status;

-- Guardar los cambios
COMMIT;

