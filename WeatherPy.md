## WeatherPy

In this example, you'll be creating a Python script to visualize the weather of 500+ cities across the world of varying distance from the equator. To accomplish this, you'll be utilizing a [simple Python library](https://pypi.python.org/pypi/citipy), the [OpenWeatherMap API](https://openweathermap.org/api), and a little common sense to create a representative model of weather across world cities.

Your objective is to build a series of scatter plots to showcase the following relationships:

* Temperature (F) vs. Latitude
* Humidity (%) vs. Latitude
* Cloudiness (%) vs. Latitude
* Wind Speed (mph) vs. Latitude

Your final notebook must:

* Randomly select **at least** 500 unique (non-repeat) cities based on latitude and longitude.
* Perform a weather check on each of the cities using a series of successive API calls. 
* Include a print log of each city as it's being processed with the city number, city name, and requested URL.
* Save both a CSV of all data retrieved and png images for each scatter plot.

As final considerations:

* You must use the Matplotlib and Seaborn libraries.
* You must include a written description of three observable trends based on the data. 
* You must use proper labeling of your plots, including aspects like: Plot Titles (with date of analysis) and Axes Labels.
* You must include an exported markdown version of your Notebook called  `README.md` in your GitHub repository.  
* See [Example Solution](WeatherPy_Example.pdf) for a reference on expected format. 

## Hints and Considerations

* You may want to start this assignment by refreshing yourself on 4th grade geography, in particular, the [geographic coordinate system](http://desktop.arcgis.com/en/arcmap/10.3/guide-books/map-projections/about-geographic-coordinate-systems.htm). 

* Next, spend the requisite time necessary to study the OpenWeatherMap API. Based on your initial study, you should be able to answer  basic questions about the API: Where do you request the API key? Which Weather API in particular will you need? What URL endpoints does it expect? What JSON structure does it respond with? Before you write a line of code, you should be aiming to have a crystal clear understanding of your intended outcome.

* Though we've never worked with the [citipy Python library](https://pypi.python.org/pypi/citipy), push yourself to decipher how it works, and why it might be relevant. Before you try to incorporate the library into your analysis, start by creating simple test cases outside your main script to confirm that you are using it correctly. Too often, when introduced to a new library, students get bogged down by the most minor of errors -- spending hours investigating their entire code -- when, in fact, a simple and focused test would have shown their basic utilization of the library was wrong from the start. Don't let this be you!

* Part of our expectation in this challenge is that you will use critical thinking skills to understand how and why we're recommending the tools we are. What is Citipy for? Why would you use it in conjunction with the OpenWeatherMap API? How would you do so?

* In building your script, pay attention to the cities you are using in your query pool. Are you getting coverage of the full gamut of latitudes and longitudes? Or are you simply choosing 500 cities concentrated in one region of the world? Even if you were a geographic genius, simply rattling 500 cities based on your human selection would create a biased dataset. Be thinking of how you should counter this. (Hint: Consider the full range of latitudes).

* Lastly, remember -- this is a challenging activity. Push yourself! If you complete this task, then you can safely say that you've gained a strong mastery of the core foundations of data analytics and it will only go better from here. Good luck!

## Copyright

Coding Boot Camp (C) 2016. All Rights Reserved.

#Create randomly 500 unique (non-repeat) integers.
#The edges are at -180/+180 for the east–west extents, and -/+90 for the north–south extents. 
#These extents are called the "horizon" of the coordinate system.
![latitude](lat.png)
![longitude](lon.png)


```python
#Dependencies

import requests
import json
from config import api_key
from citipy import citipy
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime
```


```python
#OpenWeatherMap API
base_url = 'http://api.openweathermap.org/data/2.5/weather?'
```


```python
#Based on the research article 'Map: Where the People Are", By Joshua Keating.
#Using this data, I used it to set and based the limits(longitude [-120,150]) for cities mostly inhabited by humans.
#Instead of 500, I'll just query 50 random cities
rand_number = np.random.randint(-120, 150,size=(1000,2))
```


```python
#Create List for storing data
city_geoCode = []
cities = []
countries = []
date = []
latitude = []
longitude = []
humidity = []
cloudiness = []
max_temp = []
wind_speed = []
```

#Citipy:
>from citipy import citipy
> city = citipy.nearest_city(22.99, 120.21)
> city
<citipy.City instance at 0x1069b6518>
>
> city.city_name     # Tainan, my home town
'tainan'
>
> city.country_code
'tw'                  # And the country is surely Taiwan


```python
#Loop through the 50 randomly generated pairs and save its as randon city geocodes(lat, lon)


for coordinates in rand_number:
    lat,lon = coordinates
    
    #Using Citipy wrapper to query city name using the generated random pair-coordinates
    city_name = citipy.nearest_city(lat,lon).city_name
    
    #set the queried country code to upper case
    country_code = citipy.nearest_city(lat,lon).country_code.upper() 
    query_url = f'{base_url}appid={api_key}&q={city_name}'
   
    
    response = requests.get(query_url).json()
    
    if 'id' in response:
        k = response['main']['temp_max']
        F = (9/5) * (k - 273) + 32
        city_geoCode.append(response['id'])
        cities.append(city_name)
        countries.append(country_code)
        latitude.append(lat)
        longitude.append(lon)
        cloudiness.append(response['clouds']['all'])
        date.append(response['dt'])
        max_temp.append(F)
        humidity.append(response['main']['humidity'])
        wind_speed.append(response['wind']['speed'])
```


```python
#Prety the JSON response from the openweather API

print(json.dumps(response, indent=4, sort_keys=True))
```

    {
        "base": "stations",
        "clouds": {
            "all": 1
        },
        "cod": 200,
        "coord": {
            "lat": 39.31,
            "lon": -74.98
        },
        "dt": 1521280560,
        "id": 4501427,
        "main": {
            "humidity": 62,
            "pressure": 1015,
            "temp": 271.49,
            "temp_max": 274.15,
            "temp_min": 269.15
        },
        "name": "Port Elizabeth",
        "sys": {
            "country": "US",
            "id": 1971,
            "message": 0.0044,
            "sunrise": 1521284843,
            "sunset": 1521328162,
            "type": 1
        },
        "visibility": 16093,
        "weather": [
            {
                "description": "clear sky",
                "icon": "01n",
                "id": 800,
                "main": "Clear"
            }
        ],
        "wind": {
            "deg": 260,
            "speed": 2.6
        }
    }



```python
weather = {
    'City': cities,
    'Cloudiness': cloudiness,
    'Country': countries,
    'Date': date,
    'Humidity' :humidity,
    'Latitude': latitude,
    'Longitude': longitude,
    'Max Temp': max_temp,
    'Wind Speed':wind_speed
    }
weatherDF = pd.DataFrame(weather)
```


```python
weatherDF.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 864 entries, 0 to 863
    Data columns (total 9 columns):
    City          864 non-null object
    Cloudiness    864 non-null int64
    Country       864 non-null object
    Date          864 non-null int64
    Humidity      864 non-null int64
    Latitude      864 non-null int64
    Longitude     864 non-null int64
    Max Temp      864 non-null float64
    Wind Speed    864 non-null float64
    dtypes: float64(2), int64(5), object(2)
    memory usage: 60.8+ KB



```python
#Print 10 sample rows of the city-weather data
weatherDF[:10]
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>City</th>
      <th>Cloudiness</th>
      <th>Country</th>
      <th>Date</th>
      <th>Humidity</th>
      <th>Latitude</th>
      <th>Longitude</th>
      <th>Max Temp</th>
      <th>Wind Speed</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>karasjok</td>
      <td>90</td>
      <td>NO</td>
      <td>1521282000</td>
      <td>55</td>
      <td>69</td>
      <td>26</td>
      <td>35.8700</td>
      <td>3.60</td>
    </tr>
    <tr>
      <th>1</th>
      <td>guacimo</td>
      <td>92</td>
      <td>CR</td>
      <td>1521284639</td>
      <td>97</td>
      <td>9</td>
      <td>-83</td>
      <td>70.5218</td>
      <td>1.01</td>
    </tr>
    <tr>
      <th>2</th>
      <td>dikson</td>
      <td>0</td>
      <td>RU</td>
      <td>1521284211</td>
      <td>100</td>
      <td>123</td>
      <td>95</td>
      <td>-13.4482</td>
      <td>4.41</td>
    </tr>
    <tr>
      <th>3</th>
      <td>albany</td>
      <td>75</td>
      <td>AU</td>
      <td>1521280440</td>
      <td>57</td>
      <td>-56</td>
      <td>113</td>
      <td>23.2700</td>
      <td>3.71</td>
    </tr>
    <tr>
      <th>4</th>
      <td>punta arenas</td>
      <td>75</td>
      <td>CL</td>
      <td>1521280800</td>
      <td>75</td>
      <td>-89</td>
      <td>-114</td>
      <td>43.0700</td>
      <td>6.20</td>
    </tr>
    <tr>
      <th>5</th>
      <td>vila velha</td>
      <td>20</td>
      <td>BR</td>
      <td>1521280800</td>
      <td>78</td>
      <td>-26</td>
      <td>-24</td>
      <td>82.6700</td>
      <td>1.50</td>
    </tr>
    <tr>
      <th>6</th>
      <td>teya</td>
      <td>5</td>
      <td>RU</td>
      <td>1521283680</td>
      <td>88</td>
      <td>62</td>
      <td>92</td>
      <td>70.0700</td>
      <td>4.10</td>
    </tr>
    <tr>
      <th>7</th>
      <td>chokurdakh</td>
      <td>0</td>
      <td>RU</td>
      <td>1521284643</td>
      <td>0</td>
      <td>103</td>
      <td>147</td>
      <td>-35.0482</td>
      <td>1.81</td>
    </tr>
    <tr>
      <th>8</th>
      <td>ushuaia</td>
      <td>75</td>
      <td>AR</td>
      <td>1521280800</td>
      <td>64</td>
      <td>-117</td>
      <td>-15</td>
      <td>39.4700</td>
      <td>1.50</td>
    </tr>
    <tr>
      <th>9</th>
      <td>muzhi</td>
      <td>76</td>
      <td>RU</td>
      <td>1521284645</td>
      <td>75</td>
      <td>65</td>
      <td>66</td>
      <td>-3.0082</td>
      <td>6.36</td>
    </tr>
  </tbody>
</table>
</div>



## Temperature (F) vs. Latitude


```python
#Get current UTC date
date_now=datetime.utcnow().strftime('%m/%d/%Y')
```


```python
plt.title(f'City Latitude vs Max Temperature ({date_now})')
plt.ylabel('Max Temperature (F)')
plt.xlabel('Latitude')
plt.grid(True)
plt.xlim([-150, 150])
plt.ylim([0, 120])

#Scatter plot for Max Temp vs. Latitude
plt.scatter(weatherDF['Latitude'],
            weatherDF['Max Temp'],
            edgecolor='grey', linewidths=.5, marker="o",
            alpha=0.5)
plt.show()
```


![png](output_14_0.png)


## Humidity (%) vs. Latitude


```python
plt.title(f'City Latitude vs Humidity ({date_now})')
plt.ylabel('Humidity (%)')
plt.xlabel('Latitude')
plt.grid(True)
plt.xlim([-150, 150])
plt.ylim([0, 110])

#Scatter plot for Humidity vs. Latitude
plt.scatter(weatherDF['Latitude'],
            weatherDF['Humidity'],
            edgecolor='grey', linewidths=.5, marker="o",
            alpha=0.5)

plt.show()
```


![png](output_16_0.png)


## Cloudiness (%) vs. Latitude


```python
plt.title(f'City Latitude vs Cloudiness ({date_now})')
plt.ylabel('Cloudiness (%)')
plt.xlabel('Latitude')
plt.grid(True)
plt.xlim([-150, 150])
plt.ylim([0, 110])

#Scatter plot for Cloudiness vs. Latitude
plt.scatter(weatherDF['Latitude'],
            weatherDF['Cloudiness'],
            edgecolor='grey', linewidths=.5, marker="o",
            alpha=0.5)

plt.show()
```


![png](output_18_0.png)


## Wind Speed (mph) vs. Latitude


```python
plt.title(f'City Latitude vs Wind Speed ({date_now})')
plt.ylabel('Wind Speed (mph)')
plt.xlabel('Latitude')
plt.grid(True)
plt.xlim([-150, 150])
plt.ylim([0, 17.5])

#Scatter plot for Cloudiness vs. Latitude
plt.scatter(weatherDF['Latitude'],
            weatherDF['Wind Speed'],
            edgecolor='grey', linewidths=.5, marker="o",
            alpha=0.5)

plt.show()
```


![png](output_20_0.png)

