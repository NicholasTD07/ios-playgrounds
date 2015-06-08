# ios-playgrounds

This is where I experiment with iOS development, maybe it's an idea, a
framework, or a new practice.

## ios8-restkit-zhihu

iOS app for reading ZhihuDaily

![Daily App Showcase GIF](https://dl.dropboxusercontent.com/u/212792226/zhihu-daily-v1-take-3.gif)

### How it works?

It uses RestKit to load and map Zhihu's JSON API responses into models.
, and then presents users a list of daily news/stories using UITableView.
When a cell in UITableView is tapped by a user, it takes the user to a detailed view,
which loads in the full content of that news.

User can also slide the cell from right to left, and tap on the save action button.
Then the user will be notified when the story is successfully loaded.
There will also be a checkmark on the right of the cell to remind user that
which stories are saved.

### What can it do?

* load daily news list
* infinite scrolling
* load news content
* save a news/story and then notify user after completion
* don't have to wait loading screen in a poor network condition
* mark saved news with checkmark on the right of the cell

## ios8-swift-rac #

This is a change password view written with ReactiveCocoa 3 using MVVM pattern.

![Show case GIF](https://dl.dropboxusercontent.com/u/212792226/io8-swift-rac-take-2.gif)

### You can Change Password, Only When

* The current password is inputted correctly.
* The new password fields are not empty.
* The 'New Password' matches the 'Confirm Password'.
