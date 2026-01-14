from scraping import utils
from scraping import module_test

# --- Orchestration ---
def main():
    utils.print_log(" [>] Lancement du script principal", 0)
    
    utils.print_log(" [>] Lancement du module Test", 3)
    module_test.main()
    
    utils.print_log("[>] Fin du script principal", 0)

if __name__ == "__main__":
    main()
    