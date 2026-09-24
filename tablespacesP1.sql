/*================================================================================
================================================================================*/
CREATE TABLESPACE DataTableSpace
    SIZE 10M
    REUSE
    AUTOEXTEND ON
    NEXT 512K
    MAXSIZE 200M;

CREATE TABLESPACE LogTableSpace
    SIZE 10M
    REUSE
    AUTOEXTEND ON
    NEXT 512K
    MAXSIZE 200M;

CREATE TABLESPACE IndexTableSpace
    SIZE 10M
    REUSE
    AUTOEXTEND ON
    NEXT 512K
    MAXSIZE 200M;

CREATE TABLESPACE LargeMediaTableSpace
    SIZE 10M
    REUSE
    AUTOEXTEND ON
    NEXT 512K
    MAXSIZE 200M;