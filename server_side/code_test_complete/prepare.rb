#!/usr/bin/env ruby

current_dir = Dir.pwd

### REMOVE EXISTING TEST COPY IF EXISTS ###

`rm -rf #{current_dir}/../code_test`

### DUPLICATE FOLDER ###
`cp -R #{current_dir} #{current_dir}/../code_test`

new_dir="#{current_dir}/../code_test"

### REMOVE JAVA COMPILED FILES ###
`rm -rf #{new_dir}/TW_JAVA/*.class`

### REMOVE OTHER FILES ###
`rm -f #{new_dir}/ADMIN_README.txt`
`rm -f #{new_dir}/.gitignore`
`rm -f #{new_dir}/prepare.rb`

### INSERT COMMENT BLOCKS

ruby_comment = "
#!/usr/bin/env ruby
=begin

This ruby script is intended to be built using version 1.9.2+. That will give you all the required libraries to port the code from javascript. It can be built without any additional gems. Please follow a similar structure to the javascript example, but do not worry about attempting asynchronous web calls.
	
The script will take an optional commandline argument profile_name, which will replace the default (TheScienceGuy). Since Twitter has a problem requiring this field to be standardized, we chose one with (Los Angeles, CA, USA), thanks Bill Nye.
	
=end
"
File.open("#{new_dir}/TW_RUBY/twitter_weather.rb", 'w') {|f| f.write(ruby_comment) }



java_comment = "
/*
Dont worry about finding any external libraries. We have provided JSON-Simple classes that you can import for your convenience since there is no native JSON library for java.
	
Because this is not a runtime language, run javac to compile the twitter_weather.java file and then (java twitter_weather) to execute the twitter_weather class. 
	
One important note: please provided a nested class to namespace the classes, just keeping with our previous examples. And make your public class named twitter_weather so it matches the filename.

Here are the two commands you will need ( assuming you are in ./TW_JAVA/ ):

COMPILE: javac twitter_weather.java

EXECUTE: java twitter_weather (optional TwitterHandler)

*/
	"
File.open("#{new_dir}/TW_JAVA/twitter_weather.java", 'w') {|f| f.write(java_comment) }



php_comment = "
/*
Attention! Oy! Achtung! 
	
This PHP script should be written within a namespace to protect it from interfering with other scripts. Please follow a similar structure to the javascript example, but do not worry about attempting asynchronous web calls. 
	
It is important to use current PHP5 standards and avoid globals whenever possible. The script will take an optional	commandline argument profile_name, which will replace the default (TheScienceGuy). Since Twitter has a problem requiring this field to be standardized, we chose one with (Los Angeles, CA, USA), thanks Bill Nye.
	*/
"

File.open("#{new_dir}/TW_PHP/twitter_weather.php", 'w') {|f| f.write(php_comment) }



bash_comment = "
#!/usr/bin/env bash
:<<BASHComment

This is undoubtedly the most difficult of all the scripts because you are limited by the language. You may use the ticktick.sh script provided to build the script, but do no include any other external code.
	
BASHComment 
"
File.open("#{new_dir}/TW_BASH/twitter_weather.sh", 'w') {|f| f.write(bash_comment) }



python_comment = "
#!/usr/bin/python
'''

Using Python, version 2.6+, you will not need to install any extra libraries to accomplish this test. Please follow a similar structure to the javascript example, but do not worry about attempting asynchronous web calls. 
	
'''
"
File.open("#{new_dir}/TW_PYTHON/twitter_weather.py", 'w') {|f| f.write(python_comment) }



csharp_comment = "
/*

You will need to make sure mono 2.6+ is installed to write this test. Please follow a similar structure to the javascript example, but do not worry about attempting asynchronous web calls. 

This is intented to be compiled with the gmcs and using a target framework of 2. The fastJSON library has been included to avoid you dealing with deserialization yourself. Since the syntax is more important than looking this up: http://fastjson.codeplex.com/

Here are the two commands you will need ( assuming you are in ./TW_CSHARP/ ):

COMPILE: gmcs -r:./fastJSON.dll twitter_weather.cs

EXECUTE: mono twitter_weather.exe (optional TwitterHandler)


*/
"
File.open("#{new_dir}/TW_CSHARP/twitter_weather.cs", 'w') {|f| f.write(csharp_comment) }


