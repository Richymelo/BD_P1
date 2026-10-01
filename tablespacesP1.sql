/*================================================================================
================================================================================*/
CREATE TABLESPACE DataTableSpace
    DATAFILE 'DataTableSpace.dbf'
    SIZE 10M
    AUTOEXTEND ON
    NEXT 512K
    MAXSIZE 200M;

CREATE TABLESPACE GEIndex
    DATAFILE 'GEIndex.dbf'
    SIZE 10M
    AUTOEXTEND ON
    NEXT 512K
    MAXSIZE 200M;

CREATE TABLESPACE LogTableSpace
    DATAFILE 'LogTableSpace.dbf'
    SIZE 10M
    AUTOEXTEND ON
    NEXT 512K
    MAXSIZE 200M;

CREATE TABLESPACE LargeMediaTableSpace
    DATAFILE 'LargeMediaTableSpace.dbf'
    SIZE 10M
    AUTOEXTEND ON
    NEXT 512K
    MAXSIZE 200M;