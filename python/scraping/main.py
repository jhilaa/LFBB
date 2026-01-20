from scraping import utils
from scraping import module_competitions
from scraping import module_gamedays
from scraping import module_standings
import json
import os
from dotenv import load_dotenv
from datetime import datetime
from urllib.parse import urljoin

# --- Orchestration ---
def main():
    utils.print_log(" [>] Lancement du script principal", 0)
    
    api_endpoint = utils.get_env("api_endpoint")
    script_dir = os.path.dirname(os.path.abspath(__file__)) 

    #===============================
    utils.print_log(" [>] Module Compétitions", 2)
    #===============================
    competitions_soup =  module_competitions.get_competitions() # url, menu_label, soup
    if len(competitions_soup) > 0 :
        # données Competitions, sans le soup pour l'export json
        competitions_data = [{"url": competition["url"], "menu_label": competition["menu_label"]} for competition in competitions_soup] 
        utils.create_json_file (dir_name=script_dir, dataset_name="competitions", json_data=competitions_data)   
        # api rest POST
        competitions_endpoint = urljoin(api_endpoint, "competitions")
        utils.post_json(competitions_endpoint, competitions_data)
    
    #===============================
    utils.print_log(" [>] Modules Classement et Matchs", 2)
    #===============================
    standings_data = []
    gamedays_data = []
    for competition in competitions_soup :   # url, menu_label, soup
        utils.print_log("[>] url : "+competition["url"], 2)
        # api rest POST
        standings_data.extend (module_standings.get_standings_data(competition["soup"], competition["url"]))
        gamedays_data.extend (module_gamedays.get_gamedays_data(competition["soup"], competition["url"]))
    #    
    if len(standings_data) > 0 :
        utils.create_json_file (dir_name=script_dir, dataset_name="standings", json_data=standings_data)
        # api rest POST
        standings_endpoint = urljoin(api_endpoint, "standings")
        utils.post_json(standings_endpoint, standings_data)
        
    if len(gamedays_data) > 0 :
        utils.create_json_file (dir_name=script_dir, dataset_name="gamedays", json_data=gamedays_data) 
        # api rest POST
        gamedays_endpoint = urljoin(api_endpoint, "gamedays")
        utils.post_json(gamedays_endpoint, gamedays_data)
        
    utils.print_log("[>] Fin du script principal", 0)

if __name__ == "__main__":
    main()
    