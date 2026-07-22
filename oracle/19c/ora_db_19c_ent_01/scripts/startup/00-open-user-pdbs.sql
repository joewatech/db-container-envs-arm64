-- Script to open up the any user created PDB in case it is in a 'closed' state upon startup of
-- the Oracle DB container.

ALTER SESSION SET CONTAINER=cdb$root;

BEGIN
  FOR pdb IN (
    SELECT name, open_mode
    FROM v$pdbs
    WHERE open_mode in ('MOUNTED')
    AND name NOT IN ('PDB$SEED')
  ) LOOP
    IF pdb.open_mode != 'READ WRITE' THEN
      EXECUTE IMMEDIATE 'ALTER PLUGGABLE DATABASE ' || pdb.name || ' OPEN READ WRITE';
    END IF;
  END LOOP;
END;
/
