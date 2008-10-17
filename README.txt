How to Run
==========

In the first time you run these scripts you must pass the id of the "next item" as a command-line argument. Example:

$ ruby malvados.rb 1198

This will generate the XML file. In the next run you can do just like this:

$ ruby malvados.rb

Now rssifier.rb will try to get the next item (based on the last item present in the XML file) and update the XML.
