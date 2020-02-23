#############################
#         Title: Ship Information
#         Author: Ryan McWay
#         Description: This script gathers information on cruise ships.
#         Steps:
#             1. Gather Ship Names
#             2. Prepare to Gather Further Info
#             3. Collect Tables of Information
#             4. Parse Ship Level Info.
#             5. Save as .csv
#############################

##########################################
#         Dependencies
##########################################

import pandas as pd
import numpy as np
from splinter import Browser
from bs4 import BeautifulSoup
import requests
import csv
import os

##########################################
#         Step 1: Gather Ship Names
##########################################

# Url for the cruise ships table
url = 'https://en.wikipedia.org/wiki/List_of_cruise_ships'

# Extract data from the html page
table = pd.read_html(url)

# Create an empty dataframe and create column names
ships_df = pd.DataFrame(columns = ['ship_name', 'operator', 'Began Operation', 
                              'Tonnage', 'Status'])

# Run the for loop to extract data from table A to Z, return dataframe
for i in range(4, 30):
    df_i = table[i]
    df_i.columns = ['ship_name', 'operator', 'Began Operation', 
                              'Tonnage', 'Status']
    df_i = df_i.iloc[0:]
    ships_df = ships_df.append(df_i, ignore_index = True)

## Keep only columns name and Operator
ships_df.drop(['Began Operation', 'Tonnage', 'Status'], axis = 1, inplace = True)
## Note: Those which are no longer operational will not match on callsign to the daily ship locations. So no problem with having none operational cruise ships in the mix

# Change to subdirectory
os.chdir('../input/cities')  

## Saving the dataframe into CSV
ships_df.to_csv("ship_names_wiki.csv", index = False)

##########################################
#         Step 2: Prep to Gather Ship Info.
##########################################

# Sending a HTTP request to a URL
list_of_ships = "https://en.wikipedia.org/wiki/List_of_cruise_ships"
# Make a GET request to fetch the raw HTML content
html_content = requests.get(list_of_ships).text

# Parse the html content
soup = BeautifulSoup(html_content, "html.parser")
#print(soup.prettify()) # print the parsed data of html

# Analyze the HTML tag, where your content lives
body_of_content = soup.find('div',{'id':'mw-content-text'})

# Get all the relevant tables
tables = body_of_content.find_all('table', attrs = {'class':'wikitable sortable'})

# Create an empty pandas dataframe
ships = pd.DataFrame(columns = ['title', 'wikipedia_page_link'])

##########################################
#         Step 3: Collect Tables
##########################################

# iterate over all tables on wikipeida page
for table in tables:
    # iterate over each row
    for row in table.tbody.find_all("tr")[1:]:
        # get first cell
        firstcell = row.th
        
        title = ''
        wiki_link = ''
        
        # check if value within <i></i> 
        if(firstcell.find('i')):
            title = firstcell.find('i').find(text = True)
            
        # check if value within <a></a>
        if(firstcell.find('a')):
            title = firstcell.find('a').get('title')
            wiki_link = 'https://en.wikipedia.org' + firstcell.find('a').get('href')
        
        # update title and link if title contains "page does not exist"
        if('(page does not exist)' in title):
            title = title[:-21]
            wiki_link = ''

        # append to pandas dataframe
        ships = ships.append({'title': title, 'wikipedia_page_link': wiki_link}, ignore_index = True)
    
##########################################
#         Step 4: Collect Ship Level Info.
##########################################

# iterate over each row of pandas dataframe
for index, ship in ships.iterrows():
    
    # get link to ship web page
    wikipedia_page_link = ship.wikipedia_page_link
    #print(wikipedia_page_link)
    
    # check if web page is valid
    if((wikipedia_page_link is not None) & (wikipedia_page_link != '')):

        # Make a GET request to fetch the raw HTML content
        ship_wiki_page_raw_html = requests.get(wikipedia_page_link).text

        # Parse the html content
        ship_wiki_page_content = BeautifulSoup(ship_wiki_page_raw_html, "html.parser")

        # get infobox table
        info_box_table = ship_wiki_page_content.find('table',{'class':'infobox'})

        # ensure infobox is not empty
        if info_box_table is not None:

            # iterate over each row in info box table
            for row in info_box_table.tbody.find_all("tr"):

                # get field name of the row
                fieldname = row.find('td')

                if fieldname is not None:

                    # check if field has any values
                    if(fieldname.find(text = True) is not None):

                        # check if its Operator field
                        if("Operator" in fieldname.find(text = True)):

                            # find all <li></li> sections within this field
                            # each section represents one operator
                            operators = row.find_all('li')
                            
                            for operator in operators:
                                
                                # get text for each operator
                                info = operator.find_all(text= True)
                            
                                #print('Operator ' + str(info))
                                # add it to pandas dataframe
                                ships.loc[ships.title == ship.title, 'operator'] = str(info)
                                
                        # check if its Crew field
                        if("Crew" in fieldname.find(text = True)):

                            # find all <td></td> sections within this field
                            # each section represents something about crew
                            crew = row.find_all('td')
                            
                            if(crew is not None):
                                
                                # get first number in that section
                                info_list = crew[1].find_all(text= True)
                            
                                if((info_list is not None) & (len(info_list) != 0)):
                                    
                                    # remove bad values
                                    if '\n' in info_list: info_list.remove('\n')
                                        
                                    #print('Crew ' + info_list[0])
                                    # add it to pandas dataframe                                    
                                    ships.loc[ships.title == ship.title, 'crew'] = info_list[0]
                                
                        # check if its Capacity field                        
                        if("Capacity" in fieldname.find(text = True)):

                            # find all <td></td> sections within this field
                            # each section represents something about capacity
                            capacity = row.find_all('td')
                            
                            if(capacity is not None):
                                
                                info_list = capacity[1].find_all(text= True)
                            
                                # remove bad values
                                if((info_list is not None) & (len(info_list) != 0)):
                                    
                                    if '\n' in info_list: info_list.remove('\n')
                                        
                                    #print('capacity ' + str(info_list))
                                    # add it to pandas dataframe                                    
                                    ships.loc[ships.title == ship.title, 'capacity'] = str(info_list)

                        # check if its Identification field                        
                        if("Identification" in fieldname.find(text = True)):

                            # find all <li></li> sections within this field
                            # each section represents an identification type
                            identifications = row.find_all('li')

                            # iterate over each identification type
                            for identification_type in identifications:

                                # get all text info about this identification type
                                id_info_list = identification_type.find_all(text= True)
                                
                                # ensure list is not empty
                                if((id_info_list is not None) & (len(id_info_list) != 0)):

                                    # remove bad values
                                    if '\n' in id_info_list: id_info_list.remove('\n')
                                    if ': ' in id_info_list: id_info_list.remove(': ')
                                    if ':\xa0' in id_info_list: id_info_list.remove(':\xa0')

                                    if('Call' in id_info_list[0]):
                                        for info in id_info_list:
                                            # remove colons and spaces from the identification number
                                            info = info.strip(': ')
                                            # ensure its more than 3 in length and does not contain the work call in it
                                            if((len(info) > 3) & ('Call' not in info)):
                                                #print('Call sign ' + info)
                                                # add it to pandas dataframe
                                                ships.loc[ships.title == ship.title, 'Call sign'] = info

                                    if('IMO' in id_info_list[0]):
                                        for info in id_info_list:
                                            # remove colons and spaces from the identification number                                            
                                            info = info.strip(': ')
                                            # ensure its exactly 7 in length
                                            if(len(info) == 7):
                                                #print('IMO number ' + info)
                                                # add it to pandas dataframe
                                                ships.loc[ships.title == ship.title, 'IMO number'] = info

                                    if('MMSI' in id_info_list[0]):
                                        for info in id_info_list:
                                            # remove colons and spaces from the identification number                                            
                                            info = info.strip(': ')
                                            # ensure its exactly 9 in length
                                            if(len(info) == 9):
                                                #print('MMSI number ' + info)
                                                # add it to pandas dataframe
                                                ships.loc[ships.title == ship.title, 'MMSI number'] = info

                                    if('DNV' in id_info_list[0]):
                                        for info in id_info_list:
                                            # remove colons and spaces from the identification number                                            
                                            info = info.strip(': ')
                                            # ensure its more than 3 in length and does not contain the work DNV in it
                                            if((len(info) > 3) & ('DNV' not in info)):
                                                #print('DNV ID ' + info)
                                                # add it to pandas dataframe                                                
                                                ships.loc[ships.title == ship.title, 'DNV ID'] = info                                             

##########################################
#         Step 5: Export Data
##########################################

ships.to_csv('ships_wikipedia_info.csv', index = False)