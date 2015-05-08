# ios8-restkit-zhihu

iOS app for reading ZhihuDaily

## How it works?

It uses RestKit to load and map Zhihu's JSON API responses into models.
, and then presents users a list of daily news/stories using UITableView.
When a cell in UITableView is tapped by a user, it takes the user to a detailed view,
which loads in the full content of that news.

## What can it do?

* load daily news list
* infinite scrolling
* load news content

## What else would you like to add into it? (todos)

* save a news/story and then notify me after completion
* don't have to wait loading screen in a poor network condition
* load data both from network and local data storage

## What third party frameworks are being used?

* Restkit - load, parse, and map json
* MRProgress - show progress view while loading

## APPENDIX

### ZhiHu

From Wikipedia:
"Zhihu" is a Chinese question-and-answer website. It has a similar product model as Quora.
<br>
[link to wiki page](http://en.wikipedia.org/wiki/Zhihu)