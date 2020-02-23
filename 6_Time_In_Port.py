#############################
#         Title: Time Spent in Port
#         Author: Ryan McWay
#         Description: This script calculates the amount of time a ship spends in port.
#         Steps:
#             1. Import Ship Data
#             2. Set Parameters
#             3. Calculate Time in Port
#             4. Save as .csv
#############################

##########################################
#         Dependencies
##########################################

import pandas as pd
import numpy as np
import os

##########################################
#         Step 1: Import Ship Data
##########################################

# Change to subdirectory
os.chdir('../input/ships')

# P.S specifying data types can help you save memory space when loading large datasets
ship_movement_data = pd.read_csv('ships_pre_time_in_port.csv', 
                                 usecols= ['daily_id', 'port_id', 'km_to_port_id', 'city_name', 'country_name', 'alpha_2_code', 'alpha_3_code', 
                                           'port_lat', 'port_lon', 'ship_name', 'operator', 'callsign', 'crew', 'capacity', 'date_time', 'timestamp',
                                           'ship_lat', 'ship_lon'],
                                 dtype = {'daily_id': 'float64',
                                          'port_id': 'int64',
                                          'km_to_port_id': 'float64',
                                          'city_name': 'category',
                                          'country_name': 'category',
                                          'alpha_2_code': 'category',
                                          'alpha_3_code': 'category',
                                          'port_lat': 'float64',
                                          'port_lon': 'float64',
                                          'ship_name': 'category',
                                          'operator': 'category',
                                          'callsign': 'category',
                                          'crew': 'int64',
                                          'capacity': 'int64',
                                          'date_time': 'category',
                                          'timestamp': 'int64',
                                          'ship_lat': 'float64',
                                          'ship_lon': 'float64'})

# sort dataset by callsign and timestamp
ship_movement_data.sort_values(['callsign', 'timestamp'], inplace = True, ascending = True)

##########################################
#         Step 2: Set Parameters
##########################################

ship_time_per_port = ship_movement_data.copy()

# calculate total number of records
TOTAL_RECORDS = len(ship_time_per_port)

# we assume a ship to be within a port when its within DISTANCE_THRESHOLD
DISTANCE_THRESHOLD = 15

# variable that will hold our required outcome - time spent in each port by a ship
ship_time_per_port['time_spent_at_this_location'] = np.NaN
# column number for this variable
TIME_SPENT_AT_THIS_LOCATION_COL = 18

# variable that will tell us if a row represents first consecutive day of ship being within a port
# by default - we assume it was first day 
# we will update this variable to false as and when we iterate through each row below
ship_time_per_port.loc[(ship_time_per_port.km_to_port_id <= DISTANCE_THRESHOLD), 'first_day_in_port'] = True
# column number for this variable
FIRST_DAY_IN_PORT_COL = 19

##########################################
#         Step 3: Calculate Time in Port
##########################################

# iterate over each row
for i in range(0, TOTAL_RECORDS):
    
    current_location = ship_time_per_port.iloc[i,:]
    
    # log the progress
    print('Progress percentage: ', (i/TOTAL_RECORDS)*100)
    print('Current ship callsign: ', current_location.callsign)
    
    # check if ship is within 
    if(current_location.km_to_port_id <= DISTANCE_THRESHOLD):
        
        # check if it was first day within that port
        if(current_location.first_day_in_port):
            
            # if it was first day within that port, iterate over all the future locations of that ship
            for j in range((i + 1), TOTAL_RECORDS):
                
                future_location = ship_time_per_port.iloc[j,:]
                
                # if the future location has same call sign, same port and within DISTANCE_THRESHOLD, 
                # mark that future row as ship being in same location i.e its not first_day_in_port
                if((current_location.callsign == future_location.callsign)
                   and (current_location.port_id == future_location.port_id)
                   and (future_location.km_to_port_id <= DISTANCE_THRESHOLD)):
                    ship_time_per_port.iloc[j, FIRST_DAY_IN_PORT_COL] = False
                
                # if future location has different call sign, or different port id or outside DISTANCE_THRESHOLD,
                # update current row with difference in timestamps
                if((current_location.callsign != future_location.callsign)
                   or (current_location.port_id != future_location.port_id)
                   or (future_location.km_to_port_id > DISTANCE_THRESHOLD)):
                    
                    # calculate time spent
                    time_spent = future_location.timestamp - current_location.timestamp
                    # update current row with difference in timestamps
                    ship_time_per_port.iloc[i, TIME_SPENT_AT_THIS_LOCATION_COL] = time_spent
                    # jump to the point where 'current' in-port session ends
                    i = j - 1
                    # we are done calculating time spent for 'current' row. Break away.
                    break

##########################################
#         Step 4: Export Data
##########################################

ship_time_per_port.to_csv('ship_time_per_port.csv', index = False)
