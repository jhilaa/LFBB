from bs4 import BeautifulSoup
import requests
import json
import os
from dotenv import load_dotenv
from datetime import datetime
from urllib.parse import urljoin
#
from scraping import utils


def main (): 
    utils.print_log("[>] Données par journées",0)
    # URLs
    url_src = urljoin(utils.get_env("domain"), "classements/chpt.html?sx=70")
    soup = utils.get_soup(url_src)
    
    if soup :
        gamedays_result = []
        gamedays_data = get_gamedays_data (soup, url_src)

        #if (len(gamedays_data) > 0):
         #   print (len(gamedays_data))
            # export json
            #script_dir = os.path.dirname(os.path.abspath(__file__)) 
            #utils.create_json_file (dir_name=script_dir, dataset_name="gamedays", json_data=gamedays_data)
            #
            #utils.post_json(item_endpoint, items_data)
    
def get_gamedays_data(soup, url_src):

    gamedays = soup.select('div[id]:has(> table#resultats)')
    if len(gamedays) > 0 :
        for gameday in gamedays:
            id = gameday.get("id")
            h3 = gameday.select_one('h3')
            title = h3.get_text(strip=True) if h3 else None
            print(title)
            #
            resultats = gameday.select_one("#resultats")
            games = resultats.find_all("tr")
            for game in games:
                game_data = game.find_all("td")
                date = game_data[0] if len(game_data) > 0 else None
                #
                home = game_data[1] if len(game_data) > 1 else None
                a = home.find("a")
                home_team_href = a.get("href")
                home_team_span = a.find("span")   
                home_team = home_team_span.get_text(strip=True) if home_team_span else None
                home_coach_span = home.find("span", recursive=False)
                home_coach = home_coach_span.get_text(strip=True) if home_coach_span else None
                
                print(home_team_href)
                print(home_team)
                print(home_coach)

    return 0    
    #return {"url": url_src, "competition_metadata": competition_metadata, "standings_data" : standings_data}
   
                  
# --- Orchestration ---
if __name__ == "__main__":
    main()

