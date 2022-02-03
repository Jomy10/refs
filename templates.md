[< go back](/refs)

# Refs templating engine
There is also a templating engine for replacing citations in your text. For example, writing `[#1]` in your text will replace it with the reference with the corresponding id `1`.

## Templates

These are the available templates:

- `[#1]` -> `(Belleflamme, P. et al., 2014)` <!--Matching refs command: `refs short -t par -m 1`-->
- `[#1!]` -> `Belleflamme, P. et al. (2014)` <!--Matching refs command: `refs short -m 1` or `refs short -t def -m 1`-->
- `[#1&2]` -> `(Belleflamme, P. et al., 2014; Paschen, J., 2017)` <!--Matching refs command: `refs short -t par -m 1,2`-->
- `[#1&2!]` -> `Belleflamme, P. et al. (2014) and Paschen, J. (2017)` <!--Matching refs command: `refs short -m 1,2`-->

## Usage

```bash
refst path/to/file > path/to/output_file
OR
refst "Pass in a string with citations [#1]." > path/to/output_file
```

An input file might look something like this:

```txt
[#1] states that crowdfunding involves a general request for money ...
```

the output will be:

```txt
Belleflamme, P. et al. (2014) states that crowdfunding involves a general request for money ... 
```

## Download 
To download this cli, you will first need the [refs cli](index.md). You can simply install it using the same method as the refs cli; using `./install.rb`.

You can also manually install it:<br/>
go into `/usr/local/bin` (`cd /usr/local/bin` in terminal) and make a link to the engine:

```bash
ln -s /path/to/clone/repo/template-engine/src/engine.rb refst
```
