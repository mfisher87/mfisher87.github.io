# GitHub Pages User Site

## Requirements

Just Docker. Hugo will be run from a Docker container. The `hugo_cli.sh` script accepts
arbitrary arguments, and they are passed to the `hugo` binary within the Docker
container.


## Build

Invoke the Hugo CLI in Docker with no args:

```
./scripts/hugo_cli.sh
```


## Dev server

```
./scripts/hugo_dev.sh
```


## Creating new content

When creating new content using Hugo tooling, the front-matter is automatically
calculated based on an archetype in the `archetypes/` dir. If none is specified, default
is used. E.g. to create a post:

```
./scripts/hugo_cli.sh new -k post posts/foo.md
```

To create a regular page:

```
./scripts/hugo_cli.sh new about.md
```
