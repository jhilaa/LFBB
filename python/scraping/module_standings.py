from bs4 import BeautifulSoup
import requests
import json
import os
from dotenv import load_dotenv
from datetime import datetime
from urllib.parse import urljoin
#
from scraping import utils

   
def get_standings_data(soup, competition_url):
    standings_board = soup.select_one("#classement")
    standings_data = []
    
    if standings_board:
        board_container = standings_board.find_parent("div")
        h3 = board_container.find("h3") if board_container else None
        if h3:
            competition_metadata = h3.get_text(strip=True)
        
        rows = standings_board.find_all("tr")[1:]
        if rows:
            for row in rows:
                data = row.find_all("td")
                if data:
                    standing = data[0].get_text(strip=True) if len(data) > 0  else None
                    # 
                    a = data[1].find("a") if len(data) > 1  else None
                    href = a["href"] if a else None
                    title = a.get("title") if a else None
                    team_name = a.get_text(strip=True) if a else None
                    #
                    team_data = {
                        "competition_url": competition_url,
                        "competition_metadata" : competition_metadata,
                        "standing" : standing ,
                        "team_name" : team_name ,
                        "title" : title ,
                        "team_url": href ,
                        "coach" : data[2].get_text(strip=True) if len(data) > 2  else None ,
                        "roster" : data[3].get_text(strip=True) if len(data) > 3  else None ,
                        "TV" : data[4].get_text(strip=True) if len(data) > 4  else None , 
                        "MJ" : data[5].get_text(strip=True) if len(data) > 5  else None ,
                        "V" : data[6].get_text(strip=True) if len(data) > 6  else None ,
                        "N" : data[7].get_text(strip=True) if len(data) > 7  else None ,
                        "D" : data[8].get_text(strip=True) if len(data) > 8  else None ,
                        "TP" : data[9].get_text(strip=True) if len(data) > 9  else None ,
                        "TC" : data[10].get_text(strip=True) if len(data) > 10  else None ,
                        "GA" : data[11].get_text(strip=True) if len(data) > 11  else None ,
                        "Pts" : data[12].get_text(strip=True) if len(data) > 12  else None 
                    }
                    standings_data.append(team_data)
        
    return standings_data
   

                  
# --- Orchestration ---
if __name__ == "__main__":
    main()

