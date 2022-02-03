---
title: Refs reference manager
---

<section id="downloads" class="clearfix">
    <a href="https://github.com/Jomy10/refs/zipball/master" id="download-zip" class="button"><span>Download .zip</span></a>
    <a href="https://github.com/Jomy10/refs/tarball/master" id="download-tar-gz" class="button"><span>Download .tar.gz</span></a>
</section>

# Refs: References manager

The refs cli takes in a json file and returns references in the APA format.

## Showcase

![showcase](https://github.com/Jomy10/refs/raw/master/assets/showcase.gif)

## Overview

For usage of the available commands and flags, check the [overview](overview.md).

For more information on the Json file, check the (Json file section)(json-file.md)

## Templating engine

There is also a templating engine for replacing citations in your text. For example, writing `[#1]` in your text will replace it with the reference with the corresponding id `1`.

These are the available templates:
- `[#1]` -> `(Belleflamme, P. et al., 2014)` <!--Matching refs command: `refs short -t par -m 1`-->
- `[#1!]` -> `Belleflamme, P. et al. (2014)` <!--Matching refs command: `refs short -m 1` or `refs short -t def -m 1`-->
- `[#1&2]` -> `(Belleflamme, P. et al., 2014; Paschen, J., 2017)` <!--Matching refs command: `refs short -t par -m 1,2`-->
- `[#1&2!]` -> `Belleflamme, P. et al. (2014) and Paschen, J. (2017)` <!--Matching refs command: `refs short -m 1,2`-->

For more information on the template engine, go to its [dedicated page](templates.md).

## Download
Copy the repository using `git clone https://github.com/Jomy10/refs`, or you can download it [here](https://github.com/Jomy10/refs/releases). 

### Install script
Go into the copied folder and run `./install.rb`.

### Manual installs
Go into your `/usr/local/bin`, then run

```bash
ln -s refs /path/to/copied/repo/src/cli.rb
```

You will need to have [Ruby](https://www.ruby-lang.org/en/downloads/) installed.

<section id="downloads" class="clearfix">
    <a href="https://github.com/Jomy10/refs/zipball/master" id="download-zip" class="button"><span>Download .zip</span></a>
    <a href="https://github.com/Jomy10/refs/tarball/master" id="download-tar-gz" class="button"><span>Download .tar.gz</span></a>
</section>

## Questions
If you have any questions, feel free to open an issue on the [GitHub page](https://github.com/Jomy10/refs/issues)

## License
The code is licensed under the [MIT License](https://github.com/Jomy10/refs/blob/master/LICENSE).

**If this was helpful for you, consider leaving a star on [GitHub](https://github.com/jomy10/refs)!**