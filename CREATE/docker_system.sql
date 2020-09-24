SELECT *
FROM DBA_DATA_FILES;

DROP TABLESPACE TS_DBSQL;

CREATE TABLESPACE TS_DBSQL
DATAFILE '/u01/app/oracle/oradata/XE/TS_DBSQL.DBF' 
SIZE 100M 
AUTOEXTEND ON;

create user sujin identified by java
default tablespace TS_DBSQL
temporary tablespace temp
quota unlimited on TS_DBSQL
quota 0m on system;

GRANT CONNECT, RESOURCE TO sujin;