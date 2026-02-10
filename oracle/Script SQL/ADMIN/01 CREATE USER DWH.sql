
CREATE USER DWH IDENTIFIED BY "<MotDePasseComplexe>";

GRANT CONNECT TO DWH;
GRANT RESOURCE TO DWH;
GRANT UNLIMITED TABLESPACE TO DWH;

BEGIN
  ORDS.ENABLE_SCHEMA(
    p_enabled            => TRUE,
    p_schema             => 'DWH',
    p_url_mapping_pattern => 'dwh',
    p_auto_rest_auth     => FALSE
  );
  COMMIT;
END;
/

ALTER USER DWH ACCOUNT UNLOCK;

CREATE ROLE ODS_ROLE;
GRANT ODS_ROLE TO DWH;
