# Refs
This cli takes in a json file and spits out references in the APA format.
It was created as a helper tool for my master thesis.

## Showcase

![showcase](assets/showcase.gif)


The following commands and flags are available:

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

```

## Replacing citations in text using templates

You can find more information on the refs template cli [here](template-engine)

## Json file

The json file contains your referenes and has following structure:

```json
[
  {
    /*Reference 1*/
  }, {
    /*Reference 2*/
  }
]
```

There are currently 2 types of references:

### Article

```json
{
  "title": "Crowdfunding: tapping the right crowd",
  "authors": ["Belleflamme, P.", "Lambert, T.", "Schwienbacher, A."],
  "year": "2014",
  "journal": "Journal of busines venturing",
  "volume": 29,
  "issue": 5,
  "page": "585-609",
  "wos_link": "https://www.webofscience.com/wos/woscc/full-record/WOS:000340337400001",
  "used": true,
  "uid": 1,
  "type": "article"
}
```

`wos_link` is an optional field that will be ignored. `used` is used to determine the color of the reference. The `type` field is used to identify the type of the reference. `volume`, `issue` and `page` are optional and are respectively and integer, an integer and a string.

`[1] Belleflamme, P., Lambert, T. & Schwienbacher, A. (2014). Crowdfunding: tapping the right crowd. Journal of busines venturing, 29(5), 585-609.`

### Web

```json
{
  "title": "Crowdfunding: An Industrial Organization Perspective",
  "authors": ["Belleflame, P.", "Lambert, T.", "Schwienbacher, A."],
  "year": "2010",
  "web_link": "https://www.economix.fr/uploads/source/doc/workshops/2010_dbm/Belleflamme_al.pdf",
  "used": false,
  "uid": 3,
  "type": "web"
}
```

For a **web** reference, a `web_link` is required.

`[3] Belleflame, P., Lambert, T. & Schwienbacher, A. (2010). Crowdfunding: An Industrial Organization Perspective. Retrieved from https://www.economix.fr/uploads/source/doc/workshops/2010_dbm/Belleflamme_al.pdf.`

## Download
Copy this repository using `git clone https://github.com/Jomy10/refs` and go into
your `/usr/local/bin`, then run

```bash
ln -s refs /path/to/copied/repo/src/cli.rb
```

You can also install the cli manually by running ./install.rb inside of the cloned repo

You will need to have [Ruby](https://www.ruby-lang.org/en/downloads/) installed.

## Questions
If you have any questions, feel free to open an issue.

## Contributing
This is more of a personal project I wanted to share. For my use case it is now mostly done. If you have something to add, or want to implement something that has not been added yet, feel free to open a pull request!

## License
This code is licensed under the [MIT license](LICENSE).


**If this was helpful for you, consider leaving a star!**
