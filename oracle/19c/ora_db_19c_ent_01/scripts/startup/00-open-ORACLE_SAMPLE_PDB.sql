-- Script to open up the ORACLE_SAMPLE_PDB PDB in case it is in a 'closed' state.

BEGIN
  FOR pdb IN (
    SELECT name, open_mode
    FROM v$pdbs
    WHERE name = 'ORACLE_SAMPLE_PDB'
  ) LOOP
    IF pdb.open_mode != 'READ WRITE' THEN
      EXECUTE IMMEDIATE 'ALTER PLUGGABLE DATABASE ' || pdb.name || ' OPEN READ WRITE';
    END IF;
  END LOOP;
END;
/
