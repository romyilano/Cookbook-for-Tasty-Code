# Executing Non - UI Related tasks sync with GCD

Synchronous tasks not involving UI-related code:

Vandipoor recommends the dispatch_sync function. 
These call on the global concurrent queues in GCD. These run on threads other than
the main thread.

examples:
* Downloading an image and display it to user after download. The downloading process has nothing to do with the UI.

