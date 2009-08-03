Word Count Example
==================


Locally
-------

mandy-local word_count.rb alice.txt alice-output
mandy-local word_count.rb war.txt war-output


Remotely
--------

mandy-put alice.txt input/alice.txt cluster.xml
mandy-hadoop word_count.rb input/alice.txt mandy/alice-output cluster.xml

mandy-put war.txt input/war.txt cluster.xml
mandy-hadoop word_count.rb input/war.txt mandy/war-output cluster.xml


http://pair4:50030/jobtracker.jsp
