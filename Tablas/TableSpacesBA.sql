CREATE TABLESPACE DataTableSpace

    DATAFILE 'C:\app\gzuni\product\21c\oradata\XE\ProyectoBienestarAnimal\Data.dbf'
    SIZE 10M
    REUSE
    AUTOEXTEND ON
    NEXT 512k
    MAXSIZE 200M;
    
    
CREATE TABLESPACE LogTableSpace

    DATAFILE 'C:\app\gzuni\product\21c\oradata\XE\ProyectoBienestarAnimal\Log.dbf'
    SIZE 10M
    REUSE
    AUTOEXTEND ON
    NEXT 512k
    MAXSIZE 200M; 
    

CREATE TABLESPACE IndexTableSpace

    DATAFILE 'C:\app\gzuni\product\21c\oradata\XE\ProyectoBienestarAnimal\Index.dbf'
    SIZE 10M
    REUSE
    AUTOEXTEND ON
    NEXT 512k
    MAXSIZE 200M;
