# wordstats
This repository contains some word processing exercises

## Exercise 1
Given a dictionary of words at /usr/share/dict/words

Write a perl script, which uses no CPAN or 'packages', to:

- categorize and count for all words in the dictionary the unique count of sequential characters from 2 chars to N chars
- provide a two column output of 'chars' 'count' sorted by char-length, alpha
- the table output should only provide the charsets with count above the median of counts

### Script :
* Program Name **bin/dict_categorizewords.pl**
* Dependency :   libperl >= 5

### Usage :
* dict_categorizewords.pl --help

### Default values :
* Dictionary File
```
   --dictfile : /usr/share/dict/words
````


