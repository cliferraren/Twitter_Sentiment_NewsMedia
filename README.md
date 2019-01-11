
## Unit 7 | Assignment - Distinguishing Sentiments

Background

Twitter has become a wildly sprawling jungle of information—140 characters at a time. Somewhere between 350 million and 500 million tweets are estimated to be sent out per day. With such an explosion of data, on Twitter and elsewhere, it becomes more important than ever to tame it in some way, to concisely capture the essence of the data.

Choose one of the following two assignments, in which you will do just that. Good luck!


News Mood

In this assignment, you'll create a Python script to perform a sentiment analysis of the Twitter activity of various news oulets, and to present your findings visually.

Your final output should provide a visualized summary of the sentiments expressed in Tweets sent out by the following news organizations: BBC, CBS, CNN, Fox, and New York times.



The first plot will be and/or feature the following:


Be a scatter plot of sentiments of the last 100 tweets sent out by each news organization, ranging from -1.0 to 1.0, where a score of 0 expresses a neutral sentiment, -1 the most negative sentiment possible, and +1 the most positive sentiment possible.
Each plot point will reflect the compound sentiment of a tweet.
Sort each plot point by its relative timestamp.


The second plot will be a bar plot visualizing the overall sentiments of the last 100 tweets from each organization. For this plot, you will again aggregate the compound sentiments analyzed by VADER.

The tools of the trade you will need for your task as a data analyst include the following: tweepy, pandas, matplotlib, seaborn, textblob, and VADER.

Your final Jupyter notebook must:


Pull last 100 tweets from each outlet.
Perform a sentiment analysis with the compound, positive, neutral, and negative scoring for each tweet. 
Pull into a DataFrame the tweet's source acount, its text, its date, and its compound, positive, neutral, and negative sentiment scores.
Export the data in the DataFrame into a CSV file.
Save PNG images for each plot.


As final considerations:


Use the Matplotlib and Seaborn libraries.
Include a written description of three observable trends based on the data. 
Include proper labeling of your plots, including plot titles (with date of analysis) and axes labels.
Include an exported markdown version of your Notebook called  README.md in your GitHub repository.


```python
# Dependencies
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import json
import tweepy
from datetime import datetime
import time
import seaborn as sns
from twitter_config import *

# Initialize Sentiment Analyzer
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
analyzer = SentimentIntensityAnalyzer()
```


```python
# Setup Tweepy API Authentication
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)
```


```python
# Target User Accounts
target_user = ("@BBCNorthAmerica", "@CBSNews", "@CNN", "@FoxNews", "@nytimes")
```


```python
# Variable for holding sentiments
sentiments =[]


# Loop through each users:
for user in target_user:
    
    # Counter
    counter = 1

    # Loop through 5 pages of tweets (total 100 tweets)
    for page in tweepy.Cursor(api.user_timeline, id=user).pages(5):
        
        # Get all tweets from home feed
        public_tweets = page
        
        # Loop through all tweets
        for tweet in public_tweets:
            
            text = tweet._json["text"]
            
            #Tweet datetime object
            time_stamp = tweet._json["created_at"]
            time_stamp = datetime.strptime(time_stamp, "%a %b %d %H:%M:%S %z %Y")
            
            #Get the Real Name of twitter target
            name = tweet._json['user']['name']
            
            # Run Vader Analysis on each tweet
            compound = analyzer.polarity_scores(text)["compound"]
            pos = analyzer.polarity_scores(text)["pos"]
            neu = analyzer.polarity_scores(text)["neu"]
            neg = analyzer.polarity_scores(text)["neg"]
            
            # Add sentiments for each tweet into an array
            sentiments.append({"Media Sources": name,
                               "Date": time_stamp, 
                               "Tweet Text" : text,
                               "Compound": compound,
                               "Positive": pos,
                               "Negative": neu,
                               "Neutral": neg,
                               "Tweets Ago": counter})
            # Add to counter 
            counter += 1
```


```python
# Convert sentiments to DataFrame
sentiments_pd = pd.DataFrame.from_dict(sentiments)
sentiments_pd[:10]
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
      <th>Compound</th>
      <th>Date</th>
      <th>Media Sources</th>
      <th>Negative</th>
      <th>Neutral</th>
      <th>Positive</th>
      <th>Tweet Text</th>
      <th>Tweets Ago</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.3400</td>
      <td>2018-03-24 03:52:04+00:00</td>
      <td>BBC North America</td>
      <td>0.769</td>
      <td>0.231</td>
      <td>0.000</td>
      <td>The art of the US gun reform movement https://...</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.4019</td>
      <td>2018-03-24 02:49:02+00:00</td>
      <td>BBC North America</td>
      <td>0.828</td>
      <td>0.000</td>
      <td>0.172</td>
      <td>Was the #Stoneman shooting any different? Yes,...</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.3400</td>
      <td>2018-03-24 02:09:29+00:00</td>
      <td>BBC North America</td>
      <td>0.714</td>
      <td>0.000</td>
      <td>0.286</td>
      <td>The week Facebook's value plunged $58bn https:...</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.0000</td>
      <td>2018-03-24 02:01:23+00:00</td>
      <td>BBC North America</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Florida school shooting: Pennsylvania students...</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-0.2263</td>
      <td>2018-03-24 01:45:17+00:00</td>
      <td>BBC North America</td>
      <td>0.787</td>
      <td>0.213</td>
      <td>0.000</td>
      <td>Illustrating this turbulent time in American p...</td>
      <td>5</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0.0000</td>
      <td>2018-03-24 00:50:03+00:00</td>
      <td>BBC North America</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>"Why I'm marching on Washington DC" https://t....</td>
      <td>6</td>
    </tr>
    <tr>
      <th>6</th>
      <td>-0.3400</td>
      <td>2018-03-23 23:35:22+00:00</td>
      <td>BBC North America</td>
      <td>0.745</td>
      <td>0.255</td>
      <td>0.000</td>
      <td>America's gun reform in 10 charts https://t.co...</td>
      <td>7</td>
    </tr>
    <tr>
      <th>7</th>
      <td>0.0000</td>
      <td>2018-03-23 22:37:25+00:00</td>
      <td>BBC North America</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Elon Musk pulls Tesla and SpaceX from Facebook...</td>
      <td>8</td>
    </tr>
    <tr>
      <th>8</th>
      <td>-0.3818</td>
      <td>2018-03-23 21:41:40+00:00</td>
      <td>BBC North America</td>
      <td>0.500</td>
      <td>0.307</td>
      <td>0.193</td>
      <td>Iowa family found dead in Mexico holiday home ...</td>
      <td>9</td>
    </tr>
    <tr>
      <th>9</th>
      <td>0.3400</td>
      <td>2018-03-23 21:10:09+00:00</td>
      <td>BBC North America</td>
      <td>0.789</td>
      <td>0.000</td>
      <td>0.211</td>
      <td>John Bolton: Who is Trump's new national secur...</td>
      <td>10</td>
    </tr>
  </tbody>
</table>
</div>




```python
sentiments_pd = sentiments_pd[['Media Sources', 
                               'Tweet Text', 
                               'Date','Compound', 
                               'Positive', 
                               'Neutral', 
                               'Negative',
                               'Tweets Ago']]
sentiments_pd.to_csv("Resources/news_media_tweets.csv")
sentiments_pd[:10]
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
      <th>Media Sources</th>
      <th>Tweet Text</th>
      <th>Date</th>
      <th>Compound</th>
      <th>Positive</th>
      <th>Neutral</th>
      <th>Negative</th>
      <th>Tweets Ago</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>BBC North America</td>
      <td>The art of the US gun reform movement https://...</td>
      <td>2018-03-24 03:52:04+00:00</td>
      <td>-0.3400</td>
      <td>0.000</td>
      <td>0.231</td>
      <td>0.769</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>BBC North America</td>
      <td>Was the #Stoneman shooting any different? Yes,...</td>
      <td>2018-03-24 02:49:02+00:00</td>
      <td>0.4019</td>
      <td>0.172</td>
      <td>0.000</td>
      <td>0.828</td>
      <td>2</td>
    </tr>
    <tr>
      <th>2</th>
      <td>BBC North America</td>
      <td>The week Facebook's value plunged $58bn https:...</td>
      <td>2018-03-24 02:09:29+00:00</td>
      <td>0.3400</td>
      <td>0.286</td>
      <td>0.000</td>
      <td>0.714</td>
      <td>3</td>
    </tr>
    <tr>
      <th>3</th>
      <td>BBC North America</td>
      <td>Florida school shooting: Pennsylvania students...</td>
      <td>2018-03-24 02:01:23+00:00</td>
      <td>0.0000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>1.000</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>BBC North America</td>
      <td>Illustrating this turbulent time in American p...</td>
      <td>2018-03-24 01:45:17+00:00</td>
      <td>-0.2263</td>
      <td>0.000</td>
      <td>0.213</td>
      <td>0.787</td>
      <td>5</td>
    </tr>
    <tr>
      <th>5</th>
      <td>BBC North America</td>
      <td>"Why I'm marching on Washington DC" https://t....</td>
      <td>2018-03-24 00:50:03+00:00</td>
      <td>0.0000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>1.000</td>
      <td>6</td>
    </tr>
    <tr>
      <th>6</th>
      <td>BBC North America</td>
      <td>America's gun reform in 10 charts https://t.co...</td>
      <td>2018-03-23 23:35:22+00:00</td>
      <td>-0.3400</td>
      <td>0.000</td>
      <td>0.255</td>
      <td>0.745</td>
      <td>7</td>
    </tr>
    <tr>
      <th>7</th>
      <td>BBC North America</td>
      <td>Elon Musk pulls Tesla and SpaceX from Facebook...</td>
      <td>2018-03-23 22:37:25+00:00</td>
      <td>0.0000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>1.000</td>
      <td>8</td>
    </tr>
    <tr>
      <th>8</th>
      <td>BBC North America</td>
      <td>Iowa family found dead in Mexico holiday home ...</td>
      <td>2018-03-23 21:41:40+00:00</td>
      <td>-0.3818</td>
      <td>0.193</td>
      <td>0.307</td>
      <td>0.500</td>
      <td>9</td>
    </tr>
    <tr>
      <th>9</th>
      <td>BBC North America</td>
      <td>John Bolton: Who is Trump's new national secur...</td>
      <td>2018-03-23 21:10:09+00:00</td>
      <td>0.3400</td>
      <td>0.211</td>
      <td>0.000</td>
      <td>0.789</td>
      <td>10</td>
    </tr>
  </tbody>
</table>
</div>




```python
color_palette = ('lime', 'yellow', 'cyan', 'coral', 'dodgerblue')

g = sns.lmplot(x='Tweets Ago', 
           y='Compound', 
           data=sentiments_pd,
           fit_reg=False,
           size = 8,
           legend_out=True,
           hue='Media Sources',
           palette = color_palette,
           scatter_kws={"s":100,"alpha":0.5,"linewidth":1,"edgecolors":'grey'})

plt.title(f"Sentiment Analysis of Media Tweets ({time.strftime('%m/%d/%Y')})")
plt.ylabel('Tweet Polarity')
plt.savefig("Resources/Media_tweets_sentiment_analysis.png")
plt.show()
```


![png](output_9_0.png)



```python
sentiments_summary = sentiments_pd.groupby('Media Sources', as_index=False).mean()
sentiments_summary = sentiments_summary[['Media Sources', 'Compound']]
sentiments_summary
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
      <th>Media Sources</th>
      <th>Compound</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>BBC North America</td>
      <td>-0.128016</td>
    </tr>
    <tr>
      <th>1</th>
      <td>CBS News</td>
      <td>-0.156817</td>
    </tr>
    <tr>
      <th>2</th>
      <td>CNN</td>
      <td>-0.041507</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Fox News</td>
      <td>-0.009321</td>
    </tr>
    <tr>
      <th>4</th>
      <td>The New York Times</td>
      <td>-0.081286</td>
    </tr>
  </tbody>
</table>
</div>




```python
plt.figure(figsize=(12,8))
plt.ylim(-0.2,0.2)
ax = sns.barplot(x = sentiments_summary['Media Sources'], 
                 y = sentiments_summary['Compound'],
                 data=sentiments_summary,
                 palette = color_palette
                )

plt.title(f"Overall Media Sentiment based on Twitter ({time.strftime('%m/%d/%Y')})")
plt.ylabel('Tweet Polarity')
plt.savefig("Resources/Overall_Media_Sentiment.png")
plt.show()
```


    <matplotlib.figure.Figure at 0x1a1ebd2ba8>



![png](output_11_1.png)

