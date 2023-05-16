# Kyten
Introducing Kyten (short for Lua Kyten and is pronunced Kitten)! A programming language interpreted in Lua. (You call also call it Lua Kyten)

### "Find and Replace" Parser
The Kyten parser is something I guess you can call a double parser. Not only does the parser read the code line by line, but it also reads it letter by letter. Say if you want to have a custom syntax, you would have to spell it out letter by letter (I know, I know, very inefficient) then replace said phrase with its LUA equivalent. ***NOTE: EVEN THOUGH KYTEN IS CODED IN LUA YOU MUST USE A SEMICOLON!***
```ky
putln "Hello World"; <-- CORRECT

putln "Hello World" <-- INCORRECT
```
___
### Comments
When commenting in Kyten, keep in mind that if you are using a single line comment you still have to use a semicolon at the end of the comment. When using a multiline comments, the comments themselves MUST be placed inbetween the comments identifier (See other example for another way to comment)!
```ky
-# Kyten has access to single line comments;

###
And Multiline comments as well

Note: Multiline comments only have to be structured like this if there isn't any code found inbetween
###
```
Example with code:
```ky
###static time = os.date("*t");
putln os.date("%B")%" "%time.day%", "%time.year;###
```
___
### Importing Files and Libraries
To import a file, use the 'import()' function. If you are importing a LUA file (since Kyten can run LUA files aswell), add the lua tag to the file name. 

Importing a file:
```ky
import "path/to/file";
```
Importing a Lua file:
```ky
import "path/to/file<lua>";
```
___

**[Varibles]**

Variables in Kyten are easy to use since there are only two types. Public variables (default) and static variables.
```ky
?static table = {};

nested_table = {table1 = {"Hello"}, table2 = {"World"}};

dict = {
  ["First"] = 1,
  ["Second"] = 2,
  ["Third"] = 3
};

?static number = 300;
number = 200;
?static string = "Hello";
```
**You can also set variables to hold a specific value. These are 'set' variables:** (Note: Set variables can be reassigned but only to the type delcared)
```
set ?static name::<@String> = "This is a string";

set number::<@Integer> = 1327;

set ?static deciaml::<@Float> = 37.96;

set letter::<@Char> = "W";

set Name::<@Array> = {"Jane","Bill","Bob"};
```
___
### Syntax
The syntax in Kyten is a bit different from the syntax in LUA.

**[Functions]**
```ky
func speak(words):{
  putln words;
end};

speak("Hello");
```
**[If statements]**

A basic if statment:
```ky
if (Number < 10):{
  putln "Number is less than 10";
}elseif (Number == 5):{
  putln "Number is equal to 5 (obviously)";
}elseif (type(Number) != "number"):{
  putln "Number is not even a number :/";
}else{
  putln Number;
end};
```

Using the 'not' identifier (similar to Java):
```ky
running = false;

if (!running):{
  putln "Is not running :T";
end};
```

**[For statements]**
```ky
for (i in pairs(table)):{
  putln i;
end};
```
**[While statements]**
```ky
while (1 <= 10):{
  putln i;
end};
```
**[Indexing a table (for metatables)]**
```ky
table:set_index = table
```
**[Getting user input]**

Kyte uses a "io.getln() function for user input"
```ky
name = io.getln("What is your name? ");
```

**[Special operators]**
```ky
|| <-- or

&& <-- and

!= <-- not equal

! <-- not
```

**[Added/Changed Functions]**
```
    *Old*       |      *New*        | *Method Version*
----------------|-------------------|-------------------
string.lower()  | string.toLower()  | string:toLower()
string.upper()  | string.toUpper()  | string:toUpper()
                | string.findFirst()| string:findFirst()
                | string.findLast() | string:findLast()
                |---------------------------------------
                | table.position()  |
                | table.merge()     |
                | table.split()     |
                | table.search()    |
```
To combine strings or variables in string you use the "/" symbol. Example:
```ky
?static name = "Bob";

putln "Hello "/name;
```
The code above outputs "Hello Bob"
___
### Formatting Files

You may have run into an error telling you that you are missing the format type for a file. Well... that is because you are. You can format a file by using @format. The format type of the MUST be specififed in the FIRST line of a file. (Note: Each file can have only 1 format typing (for now))
```
Modules files have to be formatted for module usage:

@format "lib.module";


The main file (index.ky) should be formatted for console usage.

@format "sh.io";
```
___
### Built in Library
Kyten has a built in library called "Textstyle" which brings in well... text styles and colors. 
```ky
import "Textstyle"

or

import("Textstyle");
```

The Textstyle module give you access to the "typewrite" function.

An example of using Textstyle for console color:
```ky
import "Textstyle";

putln Style["Bold"]%Color["Blue"]%"Hello World"%Reset;

or

-#Typewrite function usage (NOTE: If you are combining strings, you must use "..");

typewrite(Style["Bold"]..Color["Blue"].."Hello World"..Reset,0.1);
```

### Small but Important Changes
Instead of using "io.read()" function to get user input, Kyten uses the "**io.getln()**". To call an error you also use the "**io.error()**" function.

Also, just to make life a bit easier, Kyten has a math.random has been changed to math.genrand(). Now there is no need to use math.randomseed(os.time()). Kyten does it for you!
___

### CREDITS
```
Me, Myself, and I
(And ChatGPT for the typewrite function)
```
