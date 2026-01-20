DECLARE
  v_log_id NUMBER;
  v_count  NUMBER;
  v_errmsg VARCHAR2(4000);
BEGIN
  -- 1. Nouveau log_id
  SELECT STG_RAW.LOG_SEQ.NEXTVAL INTO v_log_id FROM dual;

  -- 2. Log "EN COURS" et commit immédiat
  INSERT INTO STG_RAW.LOG (log_id, table_name, log_ts)
  VALUES (v_log_id, 'STG_RAW.GAMEDAYS', SYSTIMESTAMP);
  COMMIT;  

  BEGIN
    -- 3. Suppression transactionnelle
    DELETE FROM STG_RAW.GAMEDAYS;

    -- 4. Insert en bloc depuis JSON
    INSERT INTO STG_RAW.GAMEDAYS (
		LOG_ID,
		COMPETITION_URL,
		GAMEDAY_TITLE,
		MATCH_DATE,
		HOME_TEAM,
		HOME_COACH,
		AWAY_TEAM,
		AWAY_COACH,
		SCORE,
		STAT_URL)
	SELECT 
		v_log_id,
		jt.competition_url,
		jt.gameday_title,
		jt.match_date,
		jt.home_team,
		jt.home_coach,
		jt.away_team,
		jt.away_coach,
		jt.score,
		jt.stat_url	
    FROM JSON_TABLE(:body, '$[*]'
      COLUMNS (
		  competition_url  varchar2(255)  PATH '$.competition_url',     
		  gameday_title varchar2(50) PATH '$.gameday_title',   
		  match_date    varchar2(30) PATH '$.match_date',      
		  home_team     varchar2(150) PATH '$.home_team',        
		  home_coach    varchar2(100) PATH '$.home_coach',       
		  away_team     varchar2(150) PATH '$.away_team',        
		  away_coach    varchar2(100) PATH '$.away_coach',       
		  score         varchar2(20) PATH '$.score',            
		  stat_url      varchar2(255) PATH '$.stat_url'        
      )
    ) jt;
    v_count := SQL%ROWCOUNT;
    COMMIT;

    UPDATE STG_RAW.LOG
    SET row_count = v_count
    WHERE log_id = v_log_id;
    
    COMMIT;

    :status_code := 201;
    owa_util.mime_header('application/json', FALSE);
    owa_util.http_header_close; 
    htp.print('{"log_id": ' || v_log_id ||
              ', "status": "SUCCES"' ||
              ', "row_count": ' || v_count || '}');

  EXCEPTION
    WHEN OTHERS THEN
      v_errmsg := SQLERRM;
      ROLLBACK;

      UPDATE STG_RAW.LOG
      SET error_message = v_errmsg
      WHERE log_id = v_log_id;
      COMMIT;

      :status_code := 400;
      owa_util.mime_header('application/json', FALSE);
      owa_util.http_header_close; 
      htp.print('{"log_id": ' || v_log_id ||
                ', "status": "ECHEC"' ||
                ', "error": "' || REPLACE(v_errmsg,'"','''') || '"}');
  END;
END;