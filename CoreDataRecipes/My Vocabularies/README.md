# My Vocabularies - Core Data Recipe

This is a nice Core Data recipe from apress.com 


## Notes
Reminer about the delete rules in Entity relationships
_Wow! heh relationships are all about danger. get it? ;) sounds like relationships in real life_

* No Action - most dangerous value, allows related objects to continue to attempt to access the deleted object
* Nullify - default value, specifies relationship will be nullified upon deletion and thus return a nil value
* Cascade - slightly dangerous,specifies that if one object is deleted, all the objects it is related to via this Delete rule will also be dleeted, so as to avoid having nil values. "If you're not careful with this, you can delete unexpectedly large amounts of data, though it can also be very good for keeping your data clean. You may use this for example in the case of a "folder" with multiple objects. When the folder is deleted, you would want to delete all teh contained objects as well.
* Deny - prevents the object from being deleted as long as the relationship doesn't point to nil

