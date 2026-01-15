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
    utils.print_log("[>] Données Test",0)
    # URLs
    url_src = urljoin(utils.get_env("domain"), "classements.html")
    soup = utils.get_soup(url_src)
    
    competitions_data = []
    if soup :
        competitions_url = soup.select('a[href^="/classements/"][href*=".html?sx="]')
        if (len(competitions_url) > 0):
            for a in competitions_url:
                href = a.get("href")
                text = a.get_text(strip=True)
                competitions_data.append({"url": href, "title": text})
       
        # export json
        script_dir = os.path.dirname(os.path.abspath(__file__)) 
        utils.create_json_file (dir_name=script_dir, dataset_name="competitions", json_data=competitions_data)
        #
        #utils.post_json(item_endpoint, items_data)
    
                  
# --- Orchestration ---
if __name__ == "__main__":
    main()

