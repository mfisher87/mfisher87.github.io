# PR previews

I configured PR previews to deploy to a Netlify site. Not because I'm expecting a flood
of PRs, but as a learning exercise about what tools are available for providing PR
previews for community-driven website projects.


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


## Notes

It would be really nice to be able to deploy previews on GitHub Pages, but it's not
easy. If you're using the "old" branch-based usage pattern with GitHub Pages, an action
exists, and it's [unclear](https://github.com/rossjrw/pr-preview-action/issues/21) when
or whether it will ever support the new action-based deployment pattern.

Luckily, it [looks like](https://github.com/orgs/community/discussions/7730) GitHub [is
working on this](https://github.com/actions/deploy-pages/pull/61), but has not provided
any form of commitment to complete this feature.
