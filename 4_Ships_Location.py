#############################
#         Title: Ship Locations
#         Author: Ryan McWay
#         Description: This script collects the ship locations.
#         Steps:
#             1. Loop to Collect Info. Dump
#############################

##########################################
#         Dependencies
##########################################

from bs4 import BeautifulSoup
import requests
import os

##########################################
#         Step 1: Collect Ship Locations
##########################################

# Change to subdirectory
os.chdir('../input/ships')

# Loop to collect the ships location from SailWX.com; outwrite each ship dump as a seperate .csv
with open('ship_names.csv', 'r') as fh:
    # Skip header
    fh.readline()
    broke_list = []
    
    for row in fh.readlines():
        (name, callsign) = row.replace('\n', '').rsplit(',', 1)
        print('Extracting for: ' + name)
        print('Ship: ' + callsign)
        url = 'http://www.sailwx.info/shiptrack/shipdump.phtml?call=' + callsign

        html = requests.get(url, headers = {
            'referer': 'http://www.sailwx.info/shiptrack/shipposition.phtml?call=' + callsign}).content
        soup = BeautifulSoup(html, 'html.parser')
        try:
            csv = soup.find_all('pre')[0].get_text().replace('\n', '', 1)
        except:
            broke_list.append(name)
            print('ERROR: Some kind of error occurred. Did not finish for: ' + name)
          
        with open('location_' + callsign + '.csv', 'w') as out:
            out.write(csv)
        print('Finshed: ' + name)
        print('\n')
    print(broke_list)