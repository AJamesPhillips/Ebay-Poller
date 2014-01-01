Download this directory structure and open 'ea.html', found in the
public folder, as a local webpage to poll ebay to see if it has an item.
If the item is present, the screen will turn green and if you have placed
a .ogg audio file called 'noise' into the 'public/sounds' folder
it will also be played when the item is found.

This will poll the UK ebay site every 10 minutes.


Note 1: this is using an ebay developer APP-ID limited to 5000
requests per day in total.  If it does not work, it may be that
someone else is using it.  Sign up for your own at the ebay developer site.


Note 2: compiling a new version of the javascript from the
coffeescript:
  1. Install Coffeescript
  2. install jslint
  3. run `coffee -o public/javascript/ -cw src/` from the project directory
	-l  use the linter


**Use of Apple mobile and unplugged devices**
Apple's Safari may stop the setTimeout function from working so this would stop
the automatic polling of ebay from running in the background if your device is
unplugged.