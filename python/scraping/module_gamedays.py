from bs4 import BeautifulSoup
import requests
import json
import os
from dotenv import load_dotenv
from datetime import datetime
from urllib.parse import urljoin
#
from scraping import utils


  
def get_gamedays_data(soup, competition_url):

    gamedays = soup.select('div[id]:has(> table#resultats)')
    gamedays_data = []
    
    if len(gamedays) > 0 :
        for gameday in gamedays:
            id = gameday.get("id")
            h3 = gameday.select_one('h3')
            gameday_title = h3.get_text(strip=True) if h3 else None
            #
            resultats = gameday.select_one("#resultats")
            games = resultats.find_all("tr")
            for game in games:
                game_data = game.find_all("td")
                date = game_data[0].get_text(strip=True) if len(game_data) > 0 else None
                #
                home = game_data[1] if len(game_data) > 1 else None
                if home:
                    a = home.find("a")
                    home_team_href = a.get("href")  if a else None
                    home_team_span = a.find("span")    if a else None
                    home_team = home_team_span.get_text(strip=True) if home_team_span else None
                    home_coach_span = home.find("span", recursive=False)
                    home_coach = home_coach_span.get_text(strip=True) if home_coach_span else None
                
                score = game_data[2].get_text(strip=True) if len(game_data) > 2 else None  
                
                away = game_data[3] if len(game_data) > 2 else None
                if away:
                    a = away.find("a")
                    away_team_href = a.get("href") if a else None
                    away_team_span = a.find("span") if a else None 
                    away_team = away_team_span.get_text(strip=True) if away_team_span else None
                    away_coach_span = away.find("span", recursive=False)
                    away_coach = away_coach_span.get_text(strip=True) if away_coach_span else None
                   
                #
                details = game_data[4] if len(game_data) > 3 else None
                if details:
                   a = details.find("a")
                   stat_url = a.get("href") if a else None

                #
                game_data = {
                    "competition_url": competition_url,
                    "gameday_title" : gameday_title,
                    "date" : date,
                    "home_team" : home_team,
                    "home_coach" : home_coach,
                    "away_team" : away_team,
                    "away_coach" : away_coach,
                    "score" : score,
                    "stat_url" : stat_url }
                #
                gamedays_data.append(game_data) 
    return gamedays_data
   
                  
# --- Orchestration ---
if __name__ == "__main__":
    main()

