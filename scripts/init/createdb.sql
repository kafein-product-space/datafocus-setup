CREATE EXTENSION IF NOT EXISTS dblink;

DO
$$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'keycloak') THEN
      PERFORM dblink_exec('dbname=postgres', 'CREATE DATABASE keycloak');
   END IF;
END
$$;

DO
$$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'datafocus') THEN
      PERFORM dblink_exec('dbname=postgres', 'CREATE DATABASE datafocus');
   END IF;
END
$$;
