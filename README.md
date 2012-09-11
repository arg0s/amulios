Overview
--------

Simple app that displays Amul 'topical' cartoons over the years, that was first built over a weekend in early 2010 while I was learning Obj-C. The app was downloaded far more times that I'd expected - several thousands every month, but I didnt get a chance to update it until now. This is a dedication to Dr Kurien of Amul, who passed away in September 2012. I'm opening up the code so that other contributors who like the Amul cartoon ads can join in to help enhance it.

Scraper
=======
Worker task that scrapes the image and caption data off the Amul site, and dumps it in a JSON feed. Workers currently run off Heroku, and dump the feed on S3. Uses BeautifulSoup to parse the content & work through a linked list of pages to propagate data upwards.

The scraper code is located in a separate repo here: https://github.com/arg0s/amulet.git


App
===
iOS app that lets you browse the cartoons, and provides a nifty picker to go back and forth across the years all the way back to 1976.

TODO
----
* Wire the greatest hits to the Google Analytics feed and key off top content
* Offer a random cartoon of the day, and an ability to personalize/share with friends
