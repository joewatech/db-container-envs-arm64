-- Script to open up the any user created PDB in case it is in a 'closed' state upon startup of
-- the Oracle DB container.

BEGIN
  DBMS_SESSION.SLEEP(5); -- pauses for 5 seconds
END;
/

BEGIN
  FOR pdb IN (
    SELECT name
    FROM v$pdbs
    WHERE open_mode = 'MOUNTED'
    AND name NOT IN ('PDB$SEED')
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'ALTER PLUGGABLE DATABASE "' || pdb.name || '" OPEN READ WRITE';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Failed to open PDB ' || pdb.name || ': ' || SQLERRM);
    END;
  END LOOP;

  -- Persist state so PDBs reopen READ WRITE automatically on future restarts too
  EXECUTE IMMEDIATE 'ALTER PLUGGABLE DATABASE ALL SAVE STATE';
END;
/
