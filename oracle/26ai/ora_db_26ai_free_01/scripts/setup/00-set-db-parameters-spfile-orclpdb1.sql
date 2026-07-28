--
-- This script was created by combining code from code examples in the
-- following two articles.  The 'markusdba.net' article is the one that really helped
-- to get this script to work properly to set new database parameters/settings
-- in the 'pdb$seed' and default '26AIPDB1' PDB during the container startup.
--
-- This script is setup to update the 'PDB$SEED' and 'FREEPDB1' PDBs.
--
-- https://www.markusdba.net/2016/10/23/switching-a-multitenant-database-to-extended-data-types/
-- https://oracle-base.com/articles/12c/extended-data-types-12cR1#enabling-extended-data-types-pdb
--

WHENEVER SQLERROR EXIT FAILURE;
WHENEVER OSERROR EXIT FAILURE;

-------------------
-- Updating database instance parameters/settings in the spfile.
-------------------

PURGE DBA_RECYCLEBIN;

SHUTDOWN IMMEDIATE;

STARTUP UPGRADE;

SELECT 'Show parameters prior to the update of the spfile...' AS STARTUP_OUTPUT_TEXT FROM dual;

SHOW PARAMETER string_size;

SHOW PARAMETER NLS_NCHAR_CONV_EXCP;

ALTER system SET max_string_size=EXTENDED SCOPE=spfile;

ALTER system SET NLS_NCHAR_CONV_EXCP=TRUE SCOPE=spfile;

START $ORACLE_HOME/rdbms/admin/utl32k.sql;

SHUTDOWN IMMEDIATE;

STARTUP;

SELECT 'Show updated parameters after the update of the spfile...' AS STARTUP_OUTPUT_TEXT FROM dual;

SHOW PARAMETER string_size;

SHOW PARAMETER NLS_NCHAR_CONV_EXCP;

SELECT 'Get PDB statuses prior to update...' AS STARTUP_OUTPUT_TEXT FROM dual;

SHOW PDBS;

-------------------
-- Setting the PDB$SEED PDB template to take on the updated parameters from the 'spfile'
-------------------

SELECT 'Updating PDB$SEED to new spfile parameters...' AS STARTUP_OUTPUT_TEXT FROM dual;

ALTER SESSION SET "_oracle_script"=true;

ALTER PLUGGABLE DATABASE pdb$seed OPEN UPGRADE;

ALTER SESSION SET CONTAINER=PDB$SEED;

ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;

START $ORACLE_HOME/rdbms/admin/utl32k.sql;

ALTER SESSION SET CONTAINER=cdb$root;

ALTER PLUGGABLE DATABASE pdb$seed CLOSE;

ALTER PLUGGABLE DATABASE pdb$seed OPEN READ ONLY;

SELECT 'Show PDB$SEED with updated parameters...' AS STARTUP_OUTPUT_TEXT FROM dual;

ALTER SESSION SET CONTAINER=pdb$seed;

SHOW PARAMETER string_size;

SHOW PARAMETER NLS_NCHAR_CONV_EXCP;

-------------------
-- Updating the FREEPDB1 PDB to take on the updated properties from the 'spfile'
-------------------

SELECT 'Updating FREEPDB1 to new spfile parameters...' AS STARTUP_OUTPUT_TEXT FROM dual;

ALTER SESSION SET CONTAINER=cdb$root;

ALTER PLUGGABLE DATABASE FREEPDB1 OPEN UPGRADE;

ALTER SESSION SET CONTAINER=FREEPDB1;

ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;

START $ORACLE_HOME/rdbms/admin/utl32k.sql;

ALTER PLUGGABLE DATABASE FREEPDB1 CLOSE;

ALTER PLUGGABLE DATABASE FREEPDB1 OPEN;

SELECT 'Show FREEPDB1 with updated parameters...' AS STARTUP_OUTPUT_TEXT FROM dual;

ALTER SESSION SET CONTAINER=FREEPDB1;

SHOW PARAMETER string_size;

SHOW PARAMETER NLS_NCHAR_CONV_EXCP;

-------------------
-- Show status of PDBs after all the parameter updates have completed.
-------------------

SELECT 'Get PDB statuses after the update...' AS STARTUP_OUTPUT_TEXT FROM dual;

ALTER SESSION SET CONTAINER=cdb$root;

SHOW PDBS;

SELECT 'End of the ''00-set-db-parameters-spfile-PDBs.sql'' script' AS STARTUP_OUTPUT_TEXT FROM dual;

-- All bounces are done and every statement above succeeded (WHENEVER EXIT FAILURE
-- would have aborted otherwise), so it's safe to let the healthcheck resume.
HOST rm -f "$ORACLE_BASE/oradata/.${ORACLE_SID}.nochk"