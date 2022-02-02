# Refs template engine **WIP**

This is a separate CLI tool that depends on the refs cli to replace template citations in text.

For example, `[#1]` will be replaced with `(Belleflamme, P. et al., 2014)`.

## Templates

These are the available templates:

- `[#1]` -> `(Belleflamme, P. et al., 2014)` <!--Matching refs command: `refs short -t par -m 1`-->
- `[#1!]` -> `Belleflamme, P. et al. (2014)` <!--Matching refs command: `refs short -m 1` or `refs short -t def -m 1`-->
- `[#1&2]` -> `(Belleflamme, P. et al., 2014; Paschen, J., 2017)` <!--Matching refs command: `refs short -t par -m 1,2-`->
- `[#1&2!]` -> `Belleflamme, P. et al. (2014) and Paschen, J. (2017)` <!--Matching refs command: `refs short -m 1,2`-->

## Usage

```bash
refst path/to/file > path/to/output
OR
refst "Pass in a string with citations [#1]." > path/to/output
```

An input file might look something like this:

```txt
[#1] states that crowdfunding involves a general request for money ...
```

the output will be:

```txt
Belleflamme, P. et al. (2014) states that crowdfunding involves a general request for money ... 
```
