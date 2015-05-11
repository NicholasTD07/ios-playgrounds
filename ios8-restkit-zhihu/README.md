# ios8-restkit-zhihu

iOS app for reading ZhihuDaily

## How it works?

It uses RestKit to load and map Zhihu's JSON API responses into models.
, and then presents users a list of daily news/stories using UITableView.
When a cell in UITableView is tapped by a user, it takes the user to a detailed view,
which loads in the full content of that news.

User can also slide the cell from right to left, and tap on the save action button.
Then the user will be notified when the story is successfully loaded.
There will also be a checkmark on the right of the cell to remind user that
which stories are saved.

## What can it do?

* load daily news list
* infinite scrolling
* load news content
* save a news/story and then notify user after completion
 * don't have to wait loading screen in a poor network condition
* mark saved news with checkmark on the right of the cell

## What else would you like to add into it? (todos)

* save data into Core Data
* load data both from network and local data storage

## What third party frameworks are being used?

* Restkit - load, parse, and map json
* MRProgress - show progress view while loading
* TSMessage - show notification
* WCFastCell - smooth scrolling

## APPENDIX

### ZhiHu

From Wikipedia:
"Zhihu" is a Chinese question-and-answer website. It has a similar product model as Quora.
<br>
[link to wiki page](http://en.wikipedia.org/wiki/Zhihu)

### ZhihuDaily

Daily highly-rated answers in ZhiHu, which are picked by editors.