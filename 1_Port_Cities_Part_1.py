#############################
#         Title: Port Cities Part 1
#         Author: Ryan McWay
#         Description: This script pulls together information on port cities globally from wikipedia.
#         Steps:
#             1. Determine Sites for information
#             2. Extract information by Ocean
#             3. Append the tables together
#             4. Clean the information
#             5. Export as a .csv
#############################

##########################################
#         Dependencies
##########################################

import pandas as pd
import numpy as np 
import os

##########################################
#         Step 1: Declare Sites
##########################################

# Url for the Port Cities table. Wikipedia breaks up the information by Ocean or Sea
url_atlantic = 'https://en.wikipedia.org/wiki/List_of_ports_and_harbours_of_the_Atlantic_Ocean'
# Info: Port and Country and coordinates 
url_baltic = 'https://en.wikipedia.org/wiki/Ports_of_the_Baltic_Sea'
# Info: City 
url_mediterranean = 'https://en.wikipedia.org/wiki/List_of_coastal_settlements_of_the_Mediterranean_Sea'
# Info: City and Country 
url_indian = 'https://en.wikipedia.org/wiki/List_of_ports_and_harbours_of_the_Indian_Ocean'
# Info: City and County
url_pacific = 'https://en.wikipedia.org/wiki/List_of_ports_and_harbors_of_the_Pacific_Ocean'

##########################################
#         Step 2: Extract Info.
##########################################

# Extract data from each page, and get a df for each ocean, and clean columns before append
atlantic_table = pd.read_html(url_atlantic)
atl_df = atlantic_table[0]
atl_df[['country', 'subdivision']] = atl_df['Country/territory (and subdivision)'].str.split(',', n = 1, expand = True)
atl_df.drop(['Land region', 'Body of water', 'Features and notes', 'Country/territory (and subdivision)', 'subdivision'], axis = 1, inplace = True)
atl_df.rename(columns = {'Port': "port_city", 'Coordinates': 'coordinates'}, inplace = True)
atl_df = atl_df[['port_city', 'country', 'coordinates']]
print('atl_df:', atl_df.columns)

baltic_table = pd.read_html(url_baltic)
bal_df = baltic_table[1]
bal_df.drop(['Authority', 'Tons', 'Containers TEU', 'Passengers', 'Notes', 'Unnamed: 6'], axis = 1, inplace = True)
bal_df.rename(columns = {'City': "port_city"}, inplace = True)
print('bal_df:', bal_df.columns)

mediterranean_table = pd.read_html(url_mediterranean)
med_df = mediterranean_table[0]
med_df.drop(['Other names', 'Subdivision', 'Population', 'Date, Source', 'Language(s)'], axis = 1, inplace = True)
med_df.rename(columns = {'City': "port_city", 'Country': 'country'}, inplace = True)
print('med_df:', med_df.columns)

indian_table = pd.read_html(url_indian)
ind_df = indian_table[0] 
ind_df[['country', 'subdivision']] = ind_df['Country, subdivision'].str.split(',', n = 1, expand = True)
ind_df.drop(['Land region', 'Country, subdivision', 'Body of water', 'subdivision'], axis = 1, inplace = True)
ind_df.rename(columns = {'Port': "port_city"}, inplace = True)
print('ind_df:', ind_df.columns)

pacific_table = pd.read_html(url_pacific)
pac_df = pacific_table[1] 
pac_df[['country', 'subdivision']] = pac_df['Country (and subdivision)'].str.split(',', n = 1, expand = True)
pac_df.drop(['Region', 'Country (and subdivision)', 'Features and notes[1] [2]', 'Body of water', 'subdivision', 'Unnamed: 6'], axis = 1, inplace = True)
pac_df.rename(columns = {'Port': "port_city", 'Coordinates': 'coordinates'}, inplace = True)
pac_df = pac_df[['port_city', 'country', 'coordinates']]
print('pac_df:', pac_df.columns)


##########################################
#         Step 3: Append Data
##########################################

# Merge the tables together
cities_df = pd.DataFrame(columns = ['port_city', 'country', 'coordinates'])
for i in [atl_df, bal_df, med_df, ind_df, pac_df]:
    cities_df = cities_df.append(i, ignore_index = True)
cities_df = cities_df[['port_city', 'country', 'coordinates']]
cities_df.drop_duplicates(inplace = True)
cities_df.info()
cities_df.iloc[0]

##########################################
#         Step 4: Clean Data
##########################################

# Fill in missing countries
cities_df = cities_df.sort_values(by = 'country', ascending = False, na_position = 'first')
cities_df.head(33) # Test
cities_df.loc[615, 'country'] = 'Denmark'
cities_df.loc[616, 'port_city'] = 'Copenhagen'
cities_df.loc[616, 'country'] = 'Denmark'
cities_df.loc[617, 'country'] = 'Poland'
cities_df.loc[618, 'country'] = 'Poland'
cities_df.loc[619, 'country'] = 'Finland'
cities_df.loc[620, 'country'] = 'Sweden'
cities_df.loc[621, 'country'] = 'Finland'
cities_df.loc[622, 'country'] = 'Russia'
cities_df.loc[623, 'country'] = 'Germany'
cities_df.loc[624, 'country'] = 'Lithuania'
cities_df.loc[625, 'country'] = 'Latvia'
cities_df.loc[626, 'country'] = 'Germany'
cities_df.loc[627, 'country'] = 'Sweden'
cities_df.loc[628, 'country'] = 'Estonia'
cities_df.loc[629, 'country'] = 'Sweden'
cities_df.loc[630, 'country'] = 'Sweden'
cities_df.loc[631, 'country'] = 'Estonia'
cities_df.loc[632, 'country'] = 'Poland'
cities_df.loc[633, 'country'] = 'Finland'
cities_df.loc[634, 'country'] = 'Russia'
cities_df.loc[635, 'country'] = 'Finland'
cities_df.loc[636, 'country'] = 'Latvia'
cities_df.loc[637, 'country'] = 'Germany'
cities_df.loc[638, 'country'] = 'Russia'
cities_df.loc[639, 'country'] = 'Sweden'
cities_df.loc[640, 'port_city'] = 'Szczecin'
cities_df.loc[640, 'country'] = 'Poland'
cities_df.loc[641, 'country'] = 'Estonia'
cities_df.loc[642, 'country'] = 'Sweden'
cities_df.loc[643, 'country'] = 'Finland'
cities_df.loc[644, 'country'] = 'Russia'
cities_df.loc[645, 'country'] = 'Latvia'
cities_df.loc[646, 'country'] = 'Sweden'
cities_df.loc[647, 'country'] = 'Sweden'
cities_df.info()

# Ensure country name consistent across data
cities_df.country.unique()

# Port by Country
p_by_c = cities_df.groupby(by = 'country', as_index = False).agg({'port_city': pd.Series.nunique})

##########################################
#         Step 5: Export Data
##########################################

# Change to subdirectory
os.chdir('../input/cities')

# Create unique port_id
cities_df['port_id'] = pd.factorize(cities_df.port_city + cities_df.country)[0]

cities_df = cities_df.sort_values(by = 'country', ascending = True, na_position = 'first')
cities_df.to_csv( r'../input/cities/port_cities.csv', encoding = 'utf-8', index = False)
