from bs4 import BeautifulSoup
import requests
from datetime import datetime
from urllib.parse import urljoin
#
from scraping import utils


def get_competitions (): 
    # URLs
    url_src = urljoin(utils.get_env("domain"), "classements.html")
    soup = utils.get_soup(url_src)
    
    competitions_list = []
    if soup :
        competitions_url = soup.select('a[href^="/classements/"][href*=".html?sx="]')
        if (len(competitions_url) > 0):
            for a in competitions_url:
                href = a.get("href")
                menu_label = a.get_text(strip=True)
                
                competition_url = urljoin(utils.get_env("domain"), href)
                competition_soup = utils.get_soup(competition_url)
                competitions_list.append({"url": href, "menu_label": menu_label, "soup": competition_soup})
    
    return (competitions_list)
                  
# --- Orchestration ---
if __name__ == "__main__":
    main()

