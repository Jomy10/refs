---
title: Json references file
---

[< go back](/refs)

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