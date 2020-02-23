#############################
#         Title: Port Cities Part 2
#         Author: Ryan McWay
#         Description: This script geocodes ports using google map's API
#         Steps:
#             1. Prepare for Geocoding
#             2. Gecode Loop
#             3. Save as .csv
#############################

##########################################
#         Dependencies
##########################################

import pandas as pd
import numpy as np
import requests
import json
import time
import os

##########################################
#         Step 1: Preparation
##########################################

gkey = 'AIzaSyCs0vOOJbmVPLamiu-gVK4mR-T8KtEHW3k'

# Google url
places_url = "https://maps.googleapis.com/maps/api/geocode/json"
test = {'port_city': ['Accra', 'San Francisco', 'Oakland'], 'country': ['Ghana', 'United States', 'United States']}
cities_df = pd.DataFrame.from_dict(test)

lat, lon, google_id = ([], [], [])

##########################################
#         Step 2: Geocoding
##########################################

for index, row in cities_df.iterrows():
    # set up a parameters dictionary: input = city , country 
    params = {
            "input": cities_df.loc[index, 'port_city'] + ' , ' + cities_df.loc[index, 'country'],
            "key": gkey,
            "fields": 'geometry/location , name'
        }
    # API search for each city
    search_result = requests.get(places_url, params)
    port_city = search_result.json()
    # Get lat, lon and google code for each city
    if port_city['status'] == 'OK':
        lat.append(port_city['results'][0]['geometry']['location']['lat'])
        lon.append(port_city['results'][0]['geometry']['location']['lng'])
        google_id.append(port_city['results'][0]['place_id'])
    else:
        # If didn't find anything, still values so can merge in the end correctly
        lat.append(None)
        lon.append(None)
        google_id.append(None)
    
    ## A CHECK FOR IF WORKING
#     print(params)
    print(port_city)
    print('\n')
    
    # To avoid the 'OVER_QUERY_LIMIT' Error
    time.sleep(2)

##########################################
#         Step 3: Export Data
##########################################

# Record each location in in seperate column of the pandas cities_df 

# Export cities_df as a .csv

