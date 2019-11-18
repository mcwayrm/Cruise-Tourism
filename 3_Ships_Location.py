from bs4 import BeautifulSoup
import requests

with open('..\input\ships\ships_test.csv', 'r') as fh:
    # Skip header
    fh.readline()

    for row in fh.readlines():
        (name, callsign) = row.replace('\n', '').rsplit(',', 1)

        print('Extracting for: ' + name)
        print('Ship ' + row + 'of ' + len(fh))
        url = 'http://www.sailwx.info/shiptrack/shipdump.phtml?call=' + callsign

        html = requests.get(url, headers={
            'referer': 'http://www.sailwx.info/shiptrack/shipposition.phtml?call=' + callsign}).content
        print('Length: ' + len(html))
        soup = BeautifulSoup(html, 'html.parser')
        csv = soup.find_all('pre')[0].get_text().replace('\n', '', 1)

        with open('..\input\ships\location_' + callsign + '.csv', 'w') as out:
            out.write(csv)

#  Append all the location.csv together keeping only lat lon callsign cruise liner and ship name

# Match within 15 km radius of cities to mark if location is in_port
# Add lag_lat and lag_lon for previous lat lon in data ordered by date
# Create minutes spent in port by taking difference in time stamp from first in port to next outside of port
# Number of signal transmission between first in port and out of port

#  Give them appropriate new var names, save as ship_locations.csv