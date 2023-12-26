---
title: "Cognitive load"
---

Inspired by an [amazing talk by Julia
Evans](https://jvns.ca/blog/2023/10/06/new-talk--making-hard-things-easy/), I will
record tools I use to reduce my cognitive load on this page! My favorites will be marked
with a ⭐!

* ⭐ [Git](https://git-scm.com/): Version control is a necessary part of every day
  knowledge work, even if you don't count software. **Without tools to help us do
  version control, we invent our own version control systems, and that rarely works
  out well:**

  ![_Piled Higher and Deeper_ by Jorge Cham <https://www.phdcomics.com>](https://uidaholib.github.io/get-git/images/phd101212s.gif)

* ⭐ [pre-commit](https://pre-commit.com/): A tool for sharing [Git
  hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) in a standard way.
  This enables linting, formatting, analysis, and more to occur automatically at
  commit-time instead of needing to be operated by a human. I no longer need to think
  "I should remember to lint before committing" (and I often forget); it just happens.
  **Of all the tools I use, nothing has had a larger impact than pre-commit; it enhances
  every single other tool by enabling them to work like magic in the background.**
    * [pre-commit.ci](https://pre-commit.ci/): A free zero-config-required CI service
      for open source projects. It runs your pre-existing pre-commit config so even if a
      contributor doesn't install pre-commit, the checks will run on pushed commits.
      This service will also ensure that version numbers in your pre-commit
      configuration are kept up-to-date automatically; one less thing to think about!


## Python

I write a lot of Python, and I find these tools reduce my cognitive load and in many
cases, also reduce the amount of typing I have to do, which is good for my health.

* [Black](https://github.com/psf/black): Instead of worrying about formatting, which I
  can be very picky about, I focus on the problem I'm trying to solve and let Black
  format for me. In contrast with tools I used previously for this purpose (e.g.
  Flake8), Black doesn't just check my formatting, it fixes it. Black is also
  opinionated, which reduces bikeshedding about formatting on my teams.
* ⭐ [Ruff](https://github.com/astral-sh/ruff): A Python linter written in Rust. Ruff has
  many new linting rules and has also adopted rules from pre-existing tools. Ruff can
  also auto-fix a significant portion of rule violations. I need to spend less thought
  on setting up rules and finding new linters and plugins, and I need to fix fewer
  problems by hand because Ruff does it for me. **In combination with pre-commit and
  Black, I feel like I've reached an almost perfect state in which I'm not distracted by
  my tools and can focus purely on solving problems while my tools do magical things
  like upgrade my code to use new features in new Python releases.**
* ⭐ [Python type annotations & checker](https://docs.python.org/3/library/typing.html):
  While Python is known to be easy to read, it's possible to write hard-to-read Python.
  One way is by naming variables ambiguously and passing those variables through a deep
  stack of function calls. To debug an inner function's behavior, I have to debug or
  climb my way up the stack to reason about what's being passed in. **Type annotations
  enable verifiable self-documentation, so I don't have to investigate to understand
  what kind of data I'm working with**.


## JavaScript

I don't write JavaScript that often, but when I do:

* ⭐ [TypeScript](https://www.typescriptlang.org/): I find JavaScript code requires a
  lot of cognitive load to read, but **with the addition of typing, I find it's both
  easier to read and write clean JavaScript.** I will always write TypeScript over
  JavaScript.
* [ESLint](https://eslint.org/): I use this for the same reason I use Ruff.


## Bash

I used to write a lot more Bash than I do now, so I've forgotten a lot of the Bash
trivia I used to have memorized. Thankfully, I have tools to help me 🤓

* [Shellcheck](https://www.shellcheck.net/): As mentioned in Julia's talk, Shellcheck
  knows most of Bash's "gotchas" and frees you to worry about your problems instead of
  Bash's problems.
