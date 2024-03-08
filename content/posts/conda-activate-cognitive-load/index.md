---
title: "A cognitive load shortcut for `conda activate`"
description: "How I activate my Conda environments without disrupting my flow"
image: "short-snake-oil-painting.jpeg"
image-alt: "An image in oil painting style of a woman holding a short snake with an ouroboros halo. Generated with stable diffusion."
date: "2024-03-08"
categories:
  - "conda"
  - "python"
  - "cognitive load"
---

Whenever I need to activate a Conda environment, I struggle to remember the name of the
environment I need to activate. It doesn't take too long too remember usually, a couple
of seconds, but that often significantly disrupts an ongoing thought process or, if I'm
pair programming, a conversation. Last I checked, tab completion support was removed from
Conda, and in any case, my issue is remembering the name, not typing too much! But by
the end of this post, I'll get us down to three-keystroke environment activation.

It took me 8 years, but today I realized this is a
[cognitive load](/more/cognitive_load.md) problem that I can solve relatively easily.

From now on, I will always name my Conda environments after the Git repo root directory
(this should match the GitHub repository name). With the exception of projects with
multiple environment files, I'll no longer need to remember environment names.

For this project:

```{.yaml filename="environment.yml"}
name: "mfisher87.github.io"
# ... etc.
```

This solves the memory problem, but we can do a bit better.

We can activate an environment named after the current directory:

```bash
conda activate $(basename $PWD)
```

Using an alias I already have (read on for details), we can activate an environment
named after the current Git repository root directory from any subdirectory within that
repo:

```bash
conda activate $(basename $(git root))
```

And finally, a **two-character alias** I put in my `~/.bash_aliases` (sourced from
`~/.bashrc`; see [my dotfiles repository](https://github.com/mfisher87/dotfiles)):

```bash
# Activate a Conda environment named after root directory name of the current
# Git project. Of course, only works if you have named your envs to match your
# project names (and keep the repo in a directory named after the project)!
alias ca='conda activate $(basename $(git root))'
```

Here's the configuration from my `~/.gitconfig` that provides the `git root`
command:

```toml
[alias]
  # Output the path of the root directory of this git repo:
  root = "rev-parse --show-toplevel"
```
