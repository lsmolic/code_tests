#!/usr/bin/env bash

### DUPLICATE FOLDER ###
cp -R ../${PWD##*/} ../../code_test 

### CHANGE DIRECTORY ###
cd ../../code_test

### REMOVE JAVA COMPILED FILES ###
rm -rf ./TW_JAVA/*.class

### REMOVE ADMIN_README ###
rm ./ADMIN_README

### INSERT COMMENT BLOCKS

ruby_comment <<RubyComment
#!/usr/bin/env ruby

=begin
	This ruby script is intended to be built using version 1.9.2+. That will give you all the required libraries to port the code
	from javascript. It can be built without any additional gems. Please follow a similar structure to the javascript example, 
	but do not worry about attempting asynchronous web calls. 

	The script will take an optional commandline argument profile_name, which will replace the default 'TheScienceGuy'. 
	Since Twitter has a problem requiring this field to be standardized, we chose one with "Los Angeles, CA, USA", thanks Bill Nye.
=end
RubyComment
echo $ruby_comment > twitter_weather.rb



java_comment <<JavaComment
/*
	Don't worry about finding any external libraries. We have provided JSON-Simple classes that you can import for your convenience since there is no native JSON library for java.

	Because this is not a runtime language, run javac to compile the twitter_weather.java file and then 'java twitter_weather' to execute the twitter_weather class. 

	One important note: please provided a nested class to namespace the classes, just keeping with our previous examples. And make your public class named twitter_weather so it matches the filename.

*/
JavaComment
echo $java_comment > twitter_weather.java



php_comment <<PHPComment
/*
	Attention! Oy! Achtung! 

	This PHP script should be written within a namespace to protect it from interfering with other scripts. Please follow a similar structure to the javascript example, but do not worry about attempting asynchronous web calls. 

	It is important to use current PHP5 standards and avoid globals whenever possible. The script will take an optional	commandline argument profile_name, which will replace the default 'TheScienceGuy'. Since Twitter has a problem requiring this field to be standardized, we chose one with "Los Angeles, CA, USA", thanks Bill Nye.

*/
PHPComment
echo $php_comment > twitter_weather.php



bash_comment <<PHPComment
#!/usr/bin/env bash

: <<COMMENT_BLOCK
	
	This is undoubtedly the most difficult of all the scripts because you are limited by the language. You may use the ticktick.sh script provided to build the script, but do no include any other external code.


COMMENT_BLOCK
PHPComment
echo $php_comment > twitter_weather.php

