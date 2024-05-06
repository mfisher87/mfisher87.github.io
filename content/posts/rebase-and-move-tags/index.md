---
title: "Rebase and move tags"
description: "You probably don't want to do this, but if you do, here's how!"
image: "ai-rewrite-history-and-move-tags.jpeg"
image-alt: >-
  An &quot;AI&quot;'s best attempt to generate an image from prompt `rewrite history and move
  tags`. I don't know what I expected!
date: "2024-05-06"
categories:
  - "git"
  - "python"
---

:::{.callout-warning}
This is generally a bad idea, and I only did this out of ignorance of best practices for
maintaining a [pre-commit](https://pre-commit.com/) mirror. Was this the right thing to
do? **I don't know!** In the Conda Forge ecosystem I would _never_ do this.

If you know, please share. I have a comments section now!
:::

<!-- alex disable hook hooks -->
I created a [pre-commit](https://pre-commit.com/) mirror to enable
[Alex.js](https://github.com/get-alex/alex) to be used with pre-commit. Everything went
smoothly until I needed to make changes to the pre-commit hook metadata; for example, a
correction to the `description` field that applies to every version.


## Background

Alex.js is an inclusive language checker. It scans your prose to detect and suggest
alternatives to uninclusive language, for example profanity or condescending language.
pre-commit is an tool for automating other tools to run before making a Git commit, so
you can detect issues before they make it to your repository.

:::{.callout-info}
There are some pre-commit checks, like
[`check-added-large-files`](https://pre-commit.com/hooks.html) that I recommend for
every repository!
:::

To create my pre-commit mirror for Alex.js, I used
[`pre-commit-mirror-maker`](https://github.com/pre-commit/pre-commit-mirror-maker) to
generate a repository with one commit (plus tag) for each version of Alex.js. I only
needed to do a couple of steps, and everything worked great! :tada:


## The rebase

I can't stress enough that **I don't know what I'm doing and I may have caused pain for
users by doing this!** I'm sharing this because I learned something new.

Another Alex.js user generously
[contributed to this mirror repository](https://github.com/mfisher87/alexjs-pre-commit-mirror/pull/1)
by adding a description I had neglected to populate to the pre-commit metadata. :heart:
Thanks! Neither of us had experience maintaining this type of repository, and it's a new
repository with likely a small number of users, so we decided to try applying this
metadata change to every commit. The only problem was moving the tags.

`git rebase`, probably for good reason, doesn't have a `--tags` flag you can pass to
tell it to move tags while it's re-writing history. Thanks to Git's
[amazing hook system](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks),
implementing this functionality by myself was not as hard as I expected!

:::{.callout-important}
Git's hook system is not to be confused with [pre-commit](https://pre-commit.com).
pre-comit is a tool built on top of Git hooks. It adds the ability to share
project-level Git hooks and automates the installation of those hooks and their
respective software environments.
:::

I implemented a `post-rewrite` hook. This type of hook will run after `git rebase` and
`git commit --amend`, which create new commits from old commits. Git will pass the
rewrites as old-new commit pairs, e.g.:

```
aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d a3457012afa04a5d109ba19650d1ebb909dc9a94
2ced3ee86f82bf91c15cc30605df6d3ddf0769ff 0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33
```

I wrote my hook code in Python:

```{.python filename="${MY_REPO}/.git/hooks/post-rewrite"}
#!/usr/bin/env python
"""Move tags from old commit to new commit on every re-written commit.

WARNING: This is generally not a good idea.

Full: https://gist.github.com/mfisher87/094ddc4619ba0f4c428ea66236212ce6
"""
import subprocess
import sys


def git(*args: list[str]) -> str:
    """Run a git command with `args`."""
    args = ['git', *args]
    subp = subprocess.run(args, check=True, capture_output=True)
    return subp.stdout.decode('utf-8').strip()


def retag(old_commit: str, new_commit: str) -> None:
    """For each old/new commit pair, move tags from old commit to new."""
    tags = git('tag', '--points-at', old_commit).split('\n')   # <3>
    if tags == ['']:
        tags = []

    for tag in tags:                                           # <4>
        git('tag', '--force', tag, new_commit)                 # <4>


def main(lines) -> None:
    rewrites: list[tuple[str, str]] = []                       # <1>
    for line in lines:                                         # <1>
        old, new = line.strip().split(' ')                     # <1>
        rewrites.append((old, new))                            # <1>

    for old, new in rewrites:                                  # <2>
        retag(old, new)                                        # <2>


if __name__ == "__main__":
    main(sys.stdin)
```

1. Convert the text Git is passing into an easier-to-work-with list of 2-tuples (old,
   new).
2. Perform a `retag` operation for each pair of old and new commit identifiers.
3. `git tag --points-at {old_commit_id}` will yield all tags on the old commit,
   separated by newlines. We `.split("\n")` to once again make the data easier to work
   with.
4. For each tag on the old commit, we move it to the new commit with
   `git tag --force {tag} {new_commit}`

:tada: We've committed a horrible sin!
