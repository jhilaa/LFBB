-- Table des logs
CREATE TABLE STG_RAW.LOG (
  LOG_ID NUMBER PRIMARY KEY
  TABLE_NAME VARCHAR2(100), 
  LOG_TS TIMESTAMP  DEFAULT CURRENT_TIMESTAMP, 
  ERROR_MESSAGE VARCHAR2(250), 
  ROW_COUNT NUMBER
)

CREATE TABLE COMPETITIONS (
    LOG_ID              NUMBER NOT NULL,
    URL                 VARCHAR2(255) NOT NULL,
    MENU_LABEL          VARCHAR2(100),

    CONSTRAINT FK_ODS_COMPETITIONS_LOG
        FOREIGN KEY (LOG_ID)
        REFERENCES STG_RAW.LOG  (LOG_ID)
);

CREATE TABLE STANDINGS (
    LOG_ID                  NUMBER NOT NULL,
    COMPETITION_URL         VARCHAR2(255) NOT NULL,
    COMPETITION_METADATA    VARCHAR2(200),
    STANDING_RANK           NUMBER,
    TEAM_NAME               VARCHAR2(150),
    TITLE                   VARCHAR2(400),
    TEAM_URL                VARCHAR2(255),
    COACH                   VARCHAR2(100),
    ROSTER                  VARCHAR2(50),
    TV                      NUMBER,
    MJ                      NUMBER,
    V                       NUMBER,
    N                       NUMBER,
    D                       NUMBER,
    TP                      NUMBER,
    TC                      NUMBER,
    GA                      NUMBER,
    PTS                     NUMBER
    CONSTRAINT FK_ODS_STANDINGS_LOG
        FOREIGN KEY (LOG_ID)
        REFERENCES STG_RAW.LOG  (LOG_ID)
);

CREATE TABLE GAMEDAYS (
    LOG_ID              NUMBER NOT NULL,
    COMPETITION_URL     VARCHAR2(255) NOT NULL,
    GAMEDAY_TITLE       VARCHAR2(50),
    MATCH_DATE          VARCHAR2(30),
    HOME_TEAM            VARCHAR2(150),
    HOME_COACH           VARCHAR2(100),
    AWAY_TEAM            VARCHAR2(150),
    AWAY_COACH           VARCHAR2(100),
    SCORE                VARCHAR2(20),
    STAT_URL             VARCHAR2(255),

    CONSTRAINT FK_ODS_GAMEDAYS_LOG
        FOREIGN KEY (LOG_ID)
        REFERENCES STG_RAW.LOG (LOG_ID)
);
