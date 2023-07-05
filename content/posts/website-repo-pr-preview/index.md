---
title: "Render previews for pull requests to GitHub Pages repositories"
author: "Matt Fisher"
date: "2023-07-04"
categories:
  - "tech"
---

GitHub provides fantastic tools for collaborative development. It also provides
fantastic tools for building and hosting open-source websites with GitHub Pages.
But there's currently a hole in the in-house tooling to enable collaborative development
on open-source websites: automated website previews in pull requests.

[ReadTheDocs provides](https://docs.readthedocs.io/en/stable/pull-requests.html) this
workflow, and in my work on [QGreenland](https://github.com/nsidc/qgreenland), it
enabled less technical contributors to edit documentation rendered by a toolchain they
didn't need to know how to use.

I wanted to figure out a way to achieve the same workflow with GitHub pages, and the
[outcome of that exercise](https://github.com/mfisher87/mfisher87.github.io/pull/4) was
to use Netlify to host my previews while still hosting the production site on GitHub pages.


## Background on GitHub Pages

If you want to host a website with GitHub Pages, there are currently two options for
deployment.

![GitHub Pages deployment sources](/resources/github-actions-deployment-source.png)

The default is to deploy from a branch, named `gh-pages` by default. I prefer to avoid
this option because committing build artifacts to my source repository feels weird. The
alternative is to deploy by using GitHub Actions to upload your built site as an
"artifact" for deployment to GitHub Pages. GitHub kindly provides actions to achieve
this like so:

```yaml
name: "Build and deploy"

on:
  push:
    branches: ["main"]

permissions:
  contents: "read"
  pages: "write"
  id-token: "write"

jobs:
  build:
    runs-on: "ubuntu-latest"
    steps:
      - name: "Checkout"
        uses: "actions/checkout@v3"

      # ... build your site to e.g. `./_site`  ...

      - name: "Upload site artifact"
        uses: "actions/upload-pages-artifact@v1"
        with:
          path: "./_site"

  deploy:
    runs-on: "ubuntu-latest"
    needs: "build"
    environment:
      name: "github-pages"
      url: "${{ steps.deployment.outputs.page_url }}"
    steps:
      - name: "Deploy to GitHub Pages"
        id: "deployment"
        uses: "actions/deploy-pages@v1"
```

This way, you can have your website automatically build and re-deploy on, for example,
every commit to the `main` branch.


## The problem

What GitHub _doesn't_ currently provide is a way to preview what your site looks like on
a pull request. There is a [user-created
action](https://github.com/rossjrw/pr-preview-action), but it's
[unclear](https://github.com/rossjrw/pr-preview-action/issues/21) when or whether it
will ever support the new action-based deployment pattern.

After spending too long thinking about how to achieve previews, I gave in and decided to
do it with Netlify's free offerings, inspired by the [Quarto
website](https://github.com/quarto-dev/quarto-web/blob/main/.github/workflows/preview.yml)
project. I don't think I'll ever hit Netlify's free bandwidth limits, and I'm not using
the Netlify build system, I'm using GitHub Actions. I [recently
added](https://github.com/mfisher87/mfisher87.github.io/pull/4) this functionality to
the GitHub repository containing the source for this website.

It's pretty neat! The action which deploys to Netlify even leaves a comment in the PR:

![Bot comment on successful deployment](/resources/github-netlify-deploy-comment.png)

Set up was a bit weird, since Netlify wants you to run your builds in their ecosystem,
and I want to keep everything in GitHub Actions. The set up looked like this:


## Netlify configuration

Since we only use Netlify to host PR previews, we don't need a real site, and we don't
need to link Netlify to our repo. We can simply create a blank "Hello world" site, and
use [deploy previews](https://docs.netlify.com/site-deploys/deploy-previews/) for our
PRs.

1. Log in with GitHub account, or any other method. Sign up doesn't require a method of
   payment as of this writing.
1. Create a new site, without integrating with a Git repo. We're going to build with
   GitHub Actions, so we just need a plain boring site, which Netlify doesn't seem to
   want us to be able to do easily. This approach minimizes permissions granted to
   Netlify.
    * Select the option to browse for a folder on your computer
    * `mkdir /tmp/netlify-site && echo "Hello world" > /tmp/netlify-site/index.html`
    * Browse to and upload `/tmp/netlify-site`
1. Get the "Site ID" from the "Site configuration" menu, and save it as a repo secret.
1. Generate a "Personal Access Token" in
   [user settings](https://app.netlify.com/user/applications#personal-access-tokens),
   and save it as a repo secret.


## GitHub configuration

We're using [nwtgck/actions-netlify](https://github.com/nwtgck/actions-netlify) to push
the build as a [deploy preview](https://docs.netlify.com/site-deploys/deploy-previews/)
on Netlify.

The GitHub Action workflow requires an extra permission to add comments to PRs:

```yaml
permissions:
  pull-requests: "write"
```


## All together

```yaml
# Build, and deploy to either GitHub Pages (production), or Netlify (PR previews)
name: "Build and deploy"

on:
  # "Production" deployments are from main branch
  push:
    branches: ["main"]

  # Preview deployments are from on PRs
  pull_request:


permissions:
  # For GitHub Pages:
  contents: "read"
  pages: "write"
  id-token: "write"
  # For PR preview comments:
  pull-requests: "write"


jobs:
  build:
    runs-on: "ubuntu-latest"
    steps:
      - name: "Checkout"
        uses: "actions/checkout@v3"

      # ... build your site to e.g. `./_site`  ...

      - name: "Upload site artifact"
        uses: "actions/upload-pages-artifact@v1"
        with:
          path: "./_site"


  # Deploy preview to Netlify IFF this action triggered by PR
  # Based on: https://github.com/quarto-dev/quarto-web/blob/main/.github/workflows/preview.yml
  deploy_preview:
    if: "github.event_name == 'pull_request'"
    runs-on: "ubuntu-latest"
    needs: "build"
    steps:
      - name: "Download site artifact"
        uses: "actions/download-artifact@v3"
        with:
          # The name of artifacts created by `actions/upload-pages-artifact` is always "github-pages"
          name: "github-pages"
          path: "./_site"

      - name: "Untar site artifact"
        run: "tar --directory ./_site -xvf ./_site/artifact.tar "

      - name: "Deploy preview to Netlify"
        uses: "nwtgck/actions-netlify@v2"
        env:
          NETLIFY_SITE_ID: "${{ secrets.NETLIFY_SITE_ID }}"
          NETLIFY_AUTH_TOKEN: "${{ secrets.NETLIFY_AUTH_TOKEN }}"
        with:
          publish-dir: "./_site"
          production-deploy: false
          github-token: "${{ secrets.GITHUB_TOKEN }}"
          deploy-message: "Deploy from GHA: ${{ github.event.pull_request.title }}"
          alias: "deploy-preview-${{ github.event.pull_request.number }}"
          # these all default to 'true'
          enable-pull-request-comment: true
          enable-commit-comment: false
          enable-commit-status: true
          overwrites-pull-request-comment: false
        timeout-minutes: 1


  # Deploy to GH Pages IFF this action triggered by push
  deploy:
    if: "github.event_name == 'push'"
    runs-on: "ubuntu-latest"
    needs: "build"
    environment:
      name: "github-pages"
      url: "${{ steps.deployment.outputs.page_url }}"
    steps:
      - name: "Deploy to GitHub Pages"
        id: "deployment"
        uses: "actions/deploy-pages@v1"
```
