DECLARE
  v_log_id NUMBER;
  v_count  NUMBER;
  v_errmsg VARCHAR2(4000);
BEGIN
  -- 1. Nouveau log_id
  SELECT STG_RAW.LOG_SEQ.NEXTVAL INTO v_log_id FROM dual;

  -- 2. Log "EN COURS" et commit immédiat
  INSERT INTO STG_RAW.LOG (log_id, table_name, log_ts)
  VALUES (v_log_id, 'STG_RAW.STANDINGS', SYSTIMESTAMP);
  COMMIT;  

  BEGIN
    -- 3. Suppression transactionnelle
    DELETE FROM STG_RAW.STANDINGS;

    -- 4. Insert en bloc depuis JSON
    INSERT INTO STG_RAW.STANDINGS (
      	LOG_ID,
		COMPETITION_URL,      
		COMPETITION_METADATA, 
		STANDING_RANK,        
		TEAM_NAME,            
		TITLE,                
		TEAM_URL,             
		COACH,                
		ROSTER,               
		TV,                   
		MJ,                   
		V,                    		   
		N,                    		   
		D,                    		   
		TP,                   		   
		TC,                   		   
		GA,                   		   
		PTS ) 
    SELECT 
	    v_log_id,
		jt.COMPETITION_URL,      
		jt.COMPETITION_METADATA, 
		jt.STANDING,        
		jt.TEAM_NAME,            
		jt.TITLE,                
		jt.TEAM_URL,             
		jt.COACH,                
		jt.ROSTER,               
		jt.TV,                   
		jt.MJ,                   
		jt.V,                    		   
		jt.N,                    		   
		jt.D,                    		   
		jt.TP,                   		   
		jt.TC,                   		   
		jt.GA,                   		   
		jt.PTS              		   
    FROM JSON_TABLE(:body, '$[*]'
  COLUMNS (
			competition_url        VARCHAR2(255)  PATH '$.competition_url',
			competition_metadata   VARCHAR2(200)  PATH '$.competition_metadata',
			standing      NUMBER         PATH '$.standing',
			team_name     VARCHAR2(150)  PATH '$.team_name',
			title         VARCHAR2(400)  PATH '$.title',
			team_url      VARCHAR2(255)  PATH '$.team_url',
			coach         VARCHAR2(100)  PATH '$.coach',
			roster        VARCHAR2(50)   PATH '$.roster',
			tv       NUMBER  PATH '$.TV',
			mj       NUMBER  PATH '$.MJ',
			v        NUMBER  PATH '$.V',
			n        NUMBER  PATH '$.N',
			d        NUMBER  PATH '$.D',
			tp       NUMBER  PATH '$.TP',
			tc       NUMBER  PATH '$.TC',
			ga       NUMBER  PATH '$.GA',
			pts      NUMBER  PATH '$.Pts'
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