-- ===================== COMENTARIOS (alimentan el diccionario de datos) =====================
COMMENT ON TABLE adoption IS 'Registro de una adopcion concreta: quien adopta, que mascota y la calificacion dada por quien la entrego.';
COMMENT ON COLUMN adoption.id           IS 'Identificador unico de la adopcion (secuencia s_adoption).';
COMMENT ON COLUMN adoption.rating       IS 'Calificacion de 1 a 5 estrellas dada al adoptante.';
COMMENT ON COLUMN adoption.adoptionDate         IS 'Fecha en que se realizo la adopcion.';
COMMENT ON COLUMN adoption.notes        IS 'Notas sobre los nuevos duenos.';
COMMENT ON COLUMN adoption.givePersonId IS 'Persona que entrega la mascota en adopcion.';
COMMENT ON COLUMN adoption.adopterId    IS 'Adoptante que recibe la mascota.';
COMMENT ON COLUMN adoption.petId        IS 'Mascota adoptada.';

COMMENT ON TABLE adoptionapplication IS 'Solicitud de adopcion enviada por un adoptante.';
COMMENT ON COLUMN adoptionapplication.id        IS 'Identificador unico de la solicitud (secuencia s_adoptionapplication).';
COMMENT ON COLUMN adoptionapplication.name      IS 'Nombre o titulo de la solicitud.';
COMMENT ON COLUMN adoptionapplication.applicationDate      IS 'Fecha de envio de la solicitud.';
COMMENT ON COLUMN adoptionapplication.adopterId IS 'Adoptante que envia la solicitud.';
COMMENT ON COLUMN adoptionapplication.statusId  IS 'Estado actual de la solicitud (catalogo Status).';

COMMENT ON TABLE formquestion IS 'Preguntas del formulario parametrizable de solicitud de adopcion.';
COMMENT ON COLUMN formquestion.id           IS 'Identificador unico de la pregunta.';
COMMENT ON COLUMN formquestion.name         IS 'Texto de la pregunta.';
COMMENT ON COLUMN formquestion.aplicationId IS 'Solicitud de adopcion a la que pertenece.';

COMMENT ON TABLE formanswer IS 'Respuestas dadas a las preguntas del formulario de adopcion.';
COMMENT ON COLUMN formanswer.id           IS 'Identificador unico de la respuesta.';
COMMENT ON COLUMN formanswer.name         IS 'Texto de la respuesta.';
COMMENT ON COLUMN formanswer.aplicationId IS 'Solicitud de adopcion a la que pertenece.';

COMMENT ON TABLE fosterhome IS 'Casa cuna: persona que cuida temporalmente mascotas rescatadas.';
COMMENT ON COLUMN fosterhome.id           IS 'Identificador unico de la casa cuna.';
COMMENT ON COLUMN fosterhome.name         IS 'Nombre de la casa cuna.';
COMMENT ON COLUMN fosterhome.requiresFood IS 'Indica si requiere donacion para alimentos.';
COMMENT ON COLUMN fosterhome.userId       IS 'Usuario dueno de la casa cuna.';

COMMENT ON TABLE blacklist IS 'Lista negra de personas reportadas (por ejemplo adoptantes problematicos).';
COMMENT ON COLUMN blacklist.id         IS 'Identificador unico del reporte.';
COMMENT ON COLUMN blacklist.reason     IS 'Motivo del reporte.';
COMMENT ON COLUMN blacklist.reportDate       IS 'Fecha del reporte.';
COMMENT ON COLUMN blacklist.grade      IS 'Calificacion asignada a la persona.';
COMMENT ON COLUMN blacklist.notes      IS 'Notas adicionales.';
COMMENT ON COLUMN blacklist.reportedby IS 'Quien hizo el reporte.';
COMMENT ON COLUMN blacklist.userId     IS 'Persona reportada.';




-- Verificacion (captura para el diccionario de datos)
SELECT table_name, comments FROM user_tab_comments WHERE table_name IN
 ('ADOPTION','ADOPTIONAPPLICATION','FORMQUESTION','FORMANSWER','FOSTERHOME','BLACKLIST');
SELECT index_name, table_name FROM user_indexes WHERE index_name LIKE 'IDX\_%' ESCAPE '\';
SELECT sequence_name FROM user_sequences;