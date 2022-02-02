## Overview

### Read

```bash
refs read references.json
```

Reads the references from `references.json` and spits out the references formatted in APA style.

### Save

```bash
refs save references.json
```

Saves the file path in the config directory for easy acces:

When you now call

```bash
refs
```

This will have the same behaviour as `refs read references.json`.

### Add
If you don't want to edit the JSON file to add a new reference, you can use the
`add` command. If you have a JSON file saved (using `save`):

```bash
refs add
```
or
```bash
refs add article
```

You can also pass in a file to add it to:

```bash
refs add article file.json
```

This will take you to some prompts for input. Fields like `volume`, `issue`, `page` and
`wos_link` are optional.

### Short
`refs short` will output all references in short form, for citing references inside of text. See [Short flags](#short-flags) for useable flags.

### Flags

#### -u
The `-u` flag will print out the references unstyled (see showcase gif).

#### -i
The `-i` flag will print out the reference with the specified index.

```bash
# One reference
$ refs -i 4
[4] Churchill, N. C. & Lewis, V. L. (1983). The five stages of small business growth. Harverd Business Review, 61(3), 30-50.

# Multiple references
$ refs -i 4 -i 5
[4] Churchill, N. C. & Lewis, V. L. (1983). The five stages of small business growth. Harverd Business Review, 61(3), 30-50.
[5] Ward, C. & Ramachandran, V. (2010, December). Crowdfunding the next hit: Microfunding online experience goods. In Workshop on computational social science and the wisdom of crowds at NIPS2010, 1-5.

$ refs -i 4,5
# Equivalent to the previous command
```

#### -s, --short (unimplemented)
Prints out the short version for referencing inside of text.

e.g.
```bash
# Long version
Churchill, N. C. & Lewis, V. L. (1983). The five stages of small business growth. Harverd Business Review, 61(3), 30-50.

# Short versions
Churchill, N. C. & Lewis, V. L. (1983)
(Churchill, N. C. & Lewis, V. L., 1983)
```

<!--
Syntax

refs -s 5
refs -s 5!
refs -s 5&6&7

-->

#### -c
Counts the amount of references (can be combined with -o to only count used references)

#### -o
Only shows used references.

#### -s, --search
Searches through the references. Accepts regex as an argument

#### -n 
Outputs the references without numbers

#### -h, --help (unimplemented)
Prints the help message

That is currently it for this cli, more things coming like adding a new reference to the file via the command line, printing out the short reference for referencing inside of your text, adding an new reference using bibtex, maybe an installer, etc.

### Short flags

### -m \<ids\>
Reference multiple sources

**Usage**
```bash
$ refs short -m 1,4
Belleflamme, P. et al. (2014) and Churchill, N. C. and Lewis, V. L. (1983)
```

### -t
Specify a type using `-t def` (default) or `-t par` (parentheses).

**Usage**
```bash
$ refs short -t def -m 1
Belleflamme, P. et al. (2014)

$ refs short -t par -m 1
(Belleflamme, P. et al., 2014)
```
