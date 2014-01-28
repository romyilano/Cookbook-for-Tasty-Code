# Data Storage Recipes

This is a pretty standard "lego" for the simplest way to persist data in the app if you happen to close it
or send it into the background state

NSUserDefaults is the simplest way to store simple values
* NSUserDefauls class is a simple API to store basic values, such as instances of NSString, NSNumber, BOOL, etc. as well as more complex data structures such as NSArray, NSDictionary. Larger data such as images are not approripate.