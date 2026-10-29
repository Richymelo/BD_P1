--SYS



CREATE USER bienestarAnimal IDENTIFIED BY password12345
  DEFAULT TABLESPACE DataTableSpace
  TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON DataTableSpace
  QUOTA UNLIMITED ON LogTableSpace
  QUOTA UNLIMITED ON LargeMediaTableSpace
  QUOTA UNLIMITED ON GEIndex;

GRANT CONNECT, RESOURCE TO bienestarAnimal;



GRANT CREATE JOB TO bienestarAnimal;
GRANT EXECUTE ON DBMS_SCHEDULER TO bienestarAnimal;
GRANT MANAGE SCHEDULER TO bienestarAnimal;


--MosqueHerramientaMisteriosa:
--ALTER SESSION SET "_ORACLE_SCRIPT"=true;
