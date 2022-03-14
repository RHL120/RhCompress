# RhCompress
A useless compression tool written in Haskell.
It compresses data by looking for repetitions.
The reason why it is useless is because the
file can not be using all possible uint8s.
## The header
Every .rhc file starts with the bytes 82, 72, 76
after that there should be the unused byte and a \n
## The way it works
The first thing it does is going through
the file to check for a byte that is not
being used by it, this byte will be called
the unused byte. It looks for repetitions
and it replaces them with the unused byte
the number of repetitions and the byte being
repeated. If the number of repetitions is greater
than 255 it splits the repetations into 2 and
does the compression.
## example
```
AAAA -> 82 72 76 00 0a 00 04 41 # here 00 is the lowest unused byte
```
