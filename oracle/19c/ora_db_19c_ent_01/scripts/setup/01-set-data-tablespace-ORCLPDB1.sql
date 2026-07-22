--
-- Add 'DATA' tablespace file to the 'ORCLPDB1' default PDB
-- since this is going to be used as a template to create new SF PDBs
-- within the Oracle docker container.
--
ALTER SESSION SET CONTAINER = ORCLPDB1;

CREATE TABLESPACE DATA LOGGING DATAFILE
'/opt/oracle/oradata/ORCLCDB/ORCLPDB1/data.dbf' SIZE 1024m
AUTOEXTEND ON NEXT 1024m MAXSIZE UNLIMITED BLOCKSIZE 8k EXTENT MANAGEMENT LOCAL;
