How to Run
==========

In the first time you run these scripts you must provide the id of the initial item as a command-line argument. Example:

$ ruby malvados.rb 1198

This will generate the XML file. In the next time you don't need it anymore:

$ ruby malvados.rb

Now rssifier.rb will try to get the next item (based on the last item number present in the XML file) and update the XML.
