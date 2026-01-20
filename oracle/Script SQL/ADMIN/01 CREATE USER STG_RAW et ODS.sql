
CREATE USER STG_RAW IDENTIFIED BY "<MotDePasseComplexe>";
CREATE USER ODS IDENTIFIED BY "<MotDePasseComplexe>";

GRANT CONNECT TO STG_RAW;
GRANT RESOURCE TO STG_RAW;
GRANT UNLIMITED TABLESPACE TO STG_RAW;

GRANT CONNECT TO ODS;
GRANT RESOURCE TO ODS;
GRANT UNLIMITED TABLESPACE TO ODS;

BEGIN
  ORDS.ENABLE_SCHEMA(
    p_enabled            => TRUE,
    p_schema             => 'STG_RAW',
    p_url_mapping_pattern => 'stg_raw',
    p_auto_rest_auth     => FALSE
  );
  COMMIT;
END;
/

BEGIN
  ORDS.ENABLE_SCHEMA(
    p_enabled            => TRUE,
    p_schema             => 'ODS',
    p_url_mapping_pattern => 'ods',
    p_auto_rest_auth     => FALSE
  );
  COMMIT;
END;
/

ALTER USER STG_RAW ACCOUNT UNLOCK;
ALTER USER ODS ACCOUNT UNLOCK;