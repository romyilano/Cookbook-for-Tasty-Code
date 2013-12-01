# Non-UI Related tasks async with GCD

Non ui tasks async with GCD

"GCD can show its true power: executing blocks of code asynchronously
on the main, serial, or concurrent queues."

Tools: dispatch_async or (for c-related functions) dispatch_async_f

# Example

Download an image from a URL on the Noisebridge page.
After the download's finished, the app should
display the image to a user.

Vandipoor's outline:
# Launch block object asynchronously on a concurrent queue (from the main queue)
# In this block, launch another block obj synchronously using dispatch_sync function to download the image from a URL. This makes the rest of the code in the concurrent queue to wait. Since i'm in a synchronous thread and not on the main thread, i'm not blocking the main thread
# After the image is downloaded, we will synchronously execute a block object on the main queue to dispaly the image to the user

