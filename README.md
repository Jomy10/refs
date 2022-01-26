# Refs
This cli takes in a json file and spits out references in the APA format.
It was created as a helper tool for my master thesis.

## Showcase

![showcase](assets/showcase.gif)

The CLI currently has 2 commands: read and save.

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

### -u
The `-u` flag will print out the references unstyled (see showcase gif).

### -i
The `-i` flag will print out the reference with the specified index.



That is currently it for this cli, more things coming like adding a new reference to the file via the command line, printing out the short reference for referencing inside of your text, adding an new reference using bibtex, etc.

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
Copy this repository and go into `/usr/local/bin`, then run

```bash
ln -s refs /path/to/copied/repo/src/cli.rb
```

You will need to have [Ruby](https://www.ruby-lang.org/en/downloads/) installed.

## Questions
If you have any questions, feel free to open an issue.

## Contributing
This is more of a personal project I wanted to share, if you have anything to add though, feel free to open an issue.

## License
This code is licensed under the [MIT license](LICENSE).
