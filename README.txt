How to Run
==========

In the first time you run these scripts you must pass the id of the "next item" as a command-line argument. Example:

$ ruby malvados.rb 1198

This will generate the XML file. In the next run you can do just like this:

$ ruby malvados.rb

Now rssifier.rb will try to get the next item (based on the last item number present in the XML file) and update the XML.

How to create a new feed
========================

The 'rssify' method takes some parameters, with two special cases: the parameter ':get_body' must contain a Proc that gets a 
string 's' containing the body of the feed item and formats it. The parameter ':next_item_getter' (yeah, I must fix these 
names...) doest the same for the next item number.

The guess_next_item method acts sequentially, adding 1 to the next_item number and trying to download it based on a template. 
If it's successful (!= '404'), the XML file containing the feed is updated.
