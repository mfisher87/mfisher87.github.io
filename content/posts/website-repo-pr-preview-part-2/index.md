---
title: "Deploy pull request previews for GitHub Pages repositories (part 2)"
date: "2023-12-17"
categories:
  - "github"
  - "inclusiveness"
---

## :rocket: TLDR

**Just use [ReadTheDocs (RTD)](https://readthedocs.com)!** It's free for open source
projects.

This is not an ad. I've tried many options, and this has proved to be simplest. It's not
immediately obvious, but
[ReadTheDocs allows its build process to be completely overridden](https://docs.readthedocs.io/en/stable/build-customization.html#override-the-build-process),
so it can support any tooling you like. My belief that RTD only supported Sphinx and
MkDocs is what originally prevented me from considering ReadTheDocs as a generic
solution to this problem. I'm partial to Quarto, so
[I recently set up a ReadTheDocs site to build with Quarto](https://github.com/nsidc/usaon-benefit-tool/blob/main/.readthedocs.yaml).

Setting this mechanism up with GitHub Pages (when
[deploying as an artifact](https://github.com/orgs/community/discussions/30113#discussioncomment-7650234))
is painful: There's a lot of config, a lot of conditionality, and there's a lot to
remember. For instance, "why didn't the PR preview trigger for this PR from a fark?"
"What special step(s) do I need to trigger the preview for a fork PR?"


## :raised_hand: But I don't want my site to be on ReadTheDocs!

Maybe your site isn't a docs site. That's OK. Publish your production site from your
main branch to GitHub Pages with GitHub Actions if you feel that way! ReadTheDocs can
still provide convenient PR previews in that case.

In [Part 1 of this series](/posts/website-repo-pr-previews/index.md), I discussed why
we must look outside of GitHub Pages to solve this problem (when
[deploying as an artifact](https://github.com/orgs/community/discussions/30113#discussioncomment-7650234)).
ReadTheDocs, when used _only_ for PR previews, requires significantly less
[cognitive load](/cognitive_load.md)
to use and maintain than the Netlify alternative I suggested in Part 1. Minimizing
cognitive load is very important to me; more on that in the ["Why?" section](#sec-why).


## :persevere: Overriding the RTD build process wasn't simple

If you looked at
[the ReadTheDocs config that builds with Quarto](https://github.com/nsidc/usaon-benefit-tool/blob/main/.readthedocs.yaml),
you may have noticed the config is kind of ugly.

Quarto is installable with `conda`, but I ended up having `PATH` issues in this context
that I struggled to solve. Quarto is also installable as a `.deb`, which I tried to
install with `apt`; this may be possible, but I hit several speed bumps in the attempt
and finally resigned to installing from a release tarball, and that's what you see now.

I'm not happy with this. If you see ways to improve it, I'd love to hear from you in an
issue or PR!


## :thinking: Why? {#sec-why}

GitHub Actions has restrictions on pull requests from forks for security reasons. Anyone
can open a PR on any repository, so if we allowed GitHub Actions to run as normal, they
could cause damage. For example, by altering an Action to exfiltrate repository secrets,
or write malicious code to the repository.

Therefore, pull requests from forks can either trigger `pull_request` events, which have
no access to secrets, or `pull_request_target` events, which have no access to the
changes in the PR (only to the branch the PR is _targeting_). This method of
restriction is solid: it never allows access to the fork code (which could be malicious)
and our secrets at the same time.

However, this method of restriction, and its implications, is a lot to remember.
Therefore, the mechanisms we use as workarounds are going to require high [cognitive
load](/cognitive_load.md). For example, to work around a `pull_request_target` event
having no access to secrets (which are required to push to Netlify), one option is to
use GHA to respond to `issue_comment` events. and if the comment is authored by a
maintainer and contains the magic string `Please generate a PR preview`, then generate
the preview. This allows a maintainer to review the PR for malicious code before
allowing a workflow to run that can access secrets. The huge downside is that someone
must maintain this logic in GitHub Actions YAML, and someone must remember all or most
of the above to do the required human steps of reviewing the code and commenting to
trigger the preview.
