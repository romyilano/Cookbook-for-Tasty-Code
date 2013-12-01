# Peforming UI-Related Tasks with GCD

Use dispatch_get_main_queue with UI_related tasks on GCD

## Notes 

Just like with threading's main thread, GCD has a main queue.
All UI tasks should be executed on the main thread

Dispatching tasks to the main queue (when you're not currently on the main queue) is done asynchronously. 

You have to submit all tasks to the main queue through GCD aysnchronously (Vandipoor)

