# Development


## Conda environment

Create the environment:

```
mamba env create
```

Activate it:

```
conda activate mfisher-homepage
```


### Locking

This project uses `conda-lock`. Install it to your base conda environment:

```
mamba install --channel=conda-forge --name=base conda-lock
```

And to update the lockfile:

```
conda-lock --no-mamba
```

_NOTE: `--no-mamba` really makes this slow, but it's needed to work around [this
bug](https://github.com/conda/conda-lock/issues/381)._


## Creating new content

_TODO_


### Preview your changes

From the `content/` directory:

```
quarto preview
```
