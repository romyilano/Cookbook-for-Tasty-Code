# Finding Paths of the most Useful Folders on Disk

_From Vandipoor's iOS 6 Cookbook_

* Use the NSFileManager class  and its class method +URLsForDirectory:inDomains:
* Vandipoor advises against using the shared file manager provided by this class through +defaultManager: since it's totally not thread-safe. He says "best to create + manage an instance of the NSFileManager" class for yourself

