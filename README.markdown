Address Cleaner
===============

A Coldbox plugin that allows a user to pass in a string that contains an address and the plugin will return
a cleaner version of the address, if it can.  Otherwise it will return an error struct containing more information.

### Version
0.1.0 - Initial Release with basic parsing and error returning


### Methods
* cleanAddress(required string address) - Simply takes the string and returns a cleanly formatted string (ie. 123 S. Main St. Anywhere, MD 12345).  Returns an error array if errors exist.
* getAddressStruct(required string address) - Returns a coldfusion struct of the individual elements of the address argument entered.  Returns an error array if errors exist. 


### Thanks go to...
I started building this because of a need for it and figured a coldbox plugin was the natural solution with the point of open sourcing 
it so others can add in their dev that they think is good and of course is helpful.

I built this using JGeoCoder under the hood so I, by no means, want any credit for it.  I just wrapped up a really nice java based parser and geocoder into a coldbox plugin.
For more information on JGeoCoder, please visit http://jgeocoder.sourceforge.net/index.html

Thanks  