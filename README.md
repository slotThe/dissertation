# Categorical Reconstruction Theory

My doctoral dissertation, for the world to see.

## Cloning

When cloning, be sure to include the required submodules:

``` console
$ git clone --recurse-submodules «URL»
```

If you already have the repository, you can execute

``` console
$ git submodule update --init --recursive
```

instead.

## Building

Not as easy as I would like, but here we are.
If you use
[direnv](https://direnv.net/)—which you should—then
a simple `direnv allow` should
get you inside of a nix shell that has all the relevant dependencies.
Then, `make` will build the whole project.
Due to externalisation, this will take a *long* time the first time around,
but subsequent calls will be much quicker,
see [here](https://tony-zorman.com/posts/speeding-up-latex.html).

When making simple changes to the document—not the preamble—I would instead suggest

``` console
pdflatex \
  -shell-escape -file-line-error -interaction=batchmode \
  -halt-on-error -fmt=prec.fmt \
  main
```

which only does one pass over the document, but is much quicker.
