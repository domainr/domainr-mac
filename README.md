# Domai.nr for Mac

Domai.nr for Mac is a simple menubar application that lets you search Domai.nr from the convenience of your desktop.

There's a global keyboard shortcut (`Cmd+Shift+D`) and clicking a search result opens up the information page on Domai.nr regarding the domain you selected.

### Running locally

1) Clone this repository.

2) `gem install cocoapods` if you don't already have Cocoapods installed.

3) `cd` into the project directory and run `pod install`.

4) Open the `Domai.nr.xcworkspace` file and start hacking!

### Screenshots

![](http://f.cl.ly/items/0N263O0M0m1t08332T0f/Screen%20Shot%202014-04-13%20at%2022.12.58.png)

![](http://cl.ly/image/020c2J3Z0m3Y/Screen%20Shot%202014-04-13%20at%2022.13.13.png)

### Acknowledgements

This project uses some fantastic open-source work, specifically:

* [SVHTTPRequest](https://github.com/samvermette/SVHTTPRequest) for talking to our API over HTTP.
* [INPopoverController](https://github.com/indragiek/INPopoverController) for the all-white Popover.
* [AXStatusItemPopup](https://github.com/aschuch/AXStatusItemPopup) as a starting point for a menubar app with an NSPopover attached to it.

Big thanks to those folks for putting it on github and making our lives easier.

