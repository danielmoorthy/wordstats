# wordstats
This repository contains some word processing exercises

## Exercise 1 - Categorize Sequential Words from a Dictionary file

### Goal :
Given a dictionary of words at /usr/share/dict/words

Write a perl script, which uses no CPAN or 'packages', to:

- categorize and count for all words in the dictionary the unique count of sequential characters from 2 chars to N chars
- provide a two column output of 'chars' 'count' sorted by char-length, alpha
- the table output should only provide the charsets with count above the median of counts

### Script :
* Program Name : **bin/dict_categorizewords.pl**
* Dependency :   libperl >= 5

### Usage :
```
dict_categorizewords.pl --help
```

### Default values :
* Dictionary File
```
   --dictfile : /usr/share/dict/words
```
* Minimum word length to slice
```
   --minlen : 2
```

### Sample Execution :
```
moorthy@ubuntu:~/Github/wordstats$ bin/dict_categorizewords.pl --dictfile testdata/words --minlen 10

Summary
-------
    Input File name         : testdata/words
    Minimum word slice size : 10
    Total Words processed   : 3518
    Time taken to process   : 0 secs
    Total Unique Seq. words : 837
    Median word count is    : 3.5

Word Count
----------
    weatherproof      =>  4
    eatherproof      =>  4
    weatherproo      =>  4
    wrongheaded      =>  4
    atherproof      =>  4
    eatherproo      =>  4
    rongheaded      =>  4
    waterproof      =>  6
    weatherpro      =>  4
    weightlift      =>  5
    wrongheade      =>  4

Top Word Count
--------------
    waterproof      =>  6
```
