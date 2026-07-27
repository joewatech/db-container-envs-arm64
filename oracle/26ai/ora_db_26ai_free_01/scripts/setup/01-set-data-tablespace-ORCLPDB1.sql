--
-- Add 'DATA' tablespace file to the 'FREEPDB1' default PDB
-- since this is going to be used as a template to create new SF PDBs
-- within the Oracle docker container.
--
ALTER SESSION SET CONTAINER = FREEPDB1;

CREATE TABLESPACE DATA LOGGING DATAFILE
'/opt/oracle/oradata/FREE/FREEPDB1/data.dbf' SIZE 1024m
AUTOEXTEND ON NEXT 1024m MAXSIZE UNLIMITED BLOCKSIZE 8k EXTENT MANAGEMENT LOCAL;
