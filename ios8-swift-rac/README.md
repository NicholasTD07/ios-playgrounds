# ios8-swift-rac #

This is a change password view written with ReactiveCocoa 3 using MVVM pattern.

![Show case GIF](https://dl.dropboxusercontent.com/u/212792226/io8-swift-rac-take-2.gif)

## Setup

`brew install carthage`
`carthage update  --platform all --use-ssh --use-submodules --no-use-binaries`

## You can Change Password, Only When

* The current password is inputted correctly.
* The new password fields are not empty.
* The 'New Password' matches the 'Confirm Password'.
