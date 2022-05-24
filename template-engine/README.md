# Refs template engine

This is a separate CLI tool that depends on the refs cli to replace template citations in text.

For example, `[#1]` will be replaced with `(Belleflamme, Lambert & Schwienbacher, 2014)`.

## Templates

These are the available templates:

- `[#1]` -> `(Belleflamme, Lambert & Schwienbacher, 2014)`
- `[#1!]` -> `Belleflamme, Lambert and Schwienbacher (2014)`
- `[#1&2]` -> `(Belleflamme, Lambert & Schwienbacher, 2014; Paschen, 2017)`
- `[#1&2!]` -> `Belleflamme, Lambert & Schwienbacher, 2014 and Paschen, 2017`

If there are three or more authors and the reference is cited a second time: `[#1!] ->  Belleflamme et al. (2014)`.

References with 6 or more authors will already be abbreviated.

## Usage

```bash
refst path/to/file > path/to/output_file
OR
refst "Pass in a string with citations [#1]." > path/to/output_file
```

An input file might look something like this:

```txt
[#1!] states that crowdfunding involves a general request for money ...
```

the output will be:

```txt
Belleflamme, Lambert and Schwienbacher (2014) states that crowdfunding involves a general request for money ...
```

The second time it appears in the same text: 
```txt
Belleflamme et al. (2014) states that crowdfunding involves a general request for money ...
```

### Listing references
```bash
refst list path/to/file
```

This will list all references in a text.

## A note from the author
The citation style is based on the recommendations of Ghent University.
This is because this tool was created for my own master thesis. Feel free to fork the project if your project requires a different style.
