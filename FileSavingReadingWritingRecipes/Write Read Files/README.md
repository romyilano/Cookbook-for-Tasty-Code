# Writing to Disk


_From Vandipoor's iOS 6 Cookbook_

Certain classes let you store data
Each has its own instance method to save to disk

* NSString, UIImage, etc. writeToFile:atomically:encoding:error

* atomically - when you set it to yes it writes the file to a temp space then moves the temp file to the destination i want. Makes sure that the contents of the file will be saved to disk first and then saved to its destination so if ios 
