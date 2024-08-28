---
title: "Anaconda's 2024 terms of service changes"
subtitle: "What they mean (I think), what to do, and what not to do."
date: "2024-08-25"
author:
  - name: "Matt Fisher"
    orcid: "0000-0003-3260-5445"
  - name: "Jaime Rodríguez-Guerra Pedregal"
    orcid: "0000-0001-8974-1566"
categories:
  - "conda"
---

:::{.callout-warning}
I am not a lawyer.
This post is strictly my analysis and opinion.
Nothing in this post is legal advice.
:::

[Jump to "What do we do now?"](#sec-what-now) for a TL;DR!

Anaconda, Inc. has set forth new
[Terms of Service (TOS)](https://web.archive.org/web/20240809094443/https://legal.anaconda.com/policies/en/)
governing the use of its products.
Anaconda's offerings have long been of the
[_"freemium"_](https://en.wikipedia.org/wiki/Freemium) model, explicitly allowing free
use for educators, researchers, and non-profits.
On March 30, 2024, this changed without an official announcement from Anaconda, Inc (or
at least none that I, a heavy user, have seen).

Here's the critical bit (emphasis mine):

> 2.1 Organizational Use.
>
> Your registration, download, use, installation, access,
> or enjoyment of all Anaconda Offerings on behalf of an organization that has two
> hundred (200) or more employees or contractors (“Organizational Use”) requires a paid
> license of Anaconda Business or Anaconda Enterprise. **For sake of clarity, use by
> government entities and nonprofit entities with over 200 employees or contractors is
> considered Organizational Use.** **Educational Entities will be exempt from the paid
> license requirement, provided that the use of the Anaconda Offering(s) is solely
> limited to being used for a curriculum-based course.** Anaconda reserves the right to
> monitor the registration, download, use, installation, access, or enjoyment of the
> Anaconda Offerings to ensure it is part of a curriculum. **Utilizing Miniconda to pull
> package updates from the Anaconda Public Repository without a commercial license (if
> required by the conditions set forth in Section 2 of this Terms of Service) is
> considered a violation of the Terms of Service.**

My takeaways:

1. Non-profits are treated the same as for-profit orgs.
1. Except for use in curriculum-based courses.
   **There are no exemptions for non-profit research**.
1. Using Miniconda to pull packages from proprietary channels counts as a violation.

[Pricing](https://www.anaconda.com/pricing) for organizations of greater than 200
employees starts at **$50/user/month** at time of writing.


## Enforcement

Anaconda, Inc. has begun the process of enforcing their new terms through legal demand letters and lawsuits.
This month,
[Anaconda, Inc. began sending out legal demands to non-profit research institutions to
purchase commercial licenses of its software, _including threats of
back-billing_](https://www.theregister.com/2024/08/08/anaconda_puts_the_squeeze_on/).
It has also
[initiated a lawsuit against Intel](https://www.reuters.com/legal/litigation/intel-sued-copyright-infringement-over-ai-software-2024-08-09/),
a for-profit user, but I see this as a sign of increasing litigiousness and risk for
non-profit users.

I work for a non-profit research organization with less than 200 employees, however, we
are two levels deep in an organizational hierarchy -- above us is a cooperative research
institute, and above that is a university.
It's unclear whether this policy applies to my organization, but we must play it safe.


## "Anaconda Public Repository?"

These are the packages Anaconda and Miniconda will use by default from the `"defaults"`
channel and which require payment.
Check out the
[Anaconda Packages](https://web.archive.org/web/20240000000000*/https://repo.anaconda.com/pkgs/)
page for more details on the official channels that are subject to terms.

The Anaconda distribution itself includes these packages, so it is subject to
terms.
Miniconda does _not_ include those packages, but **by default will download
packages from proprietary channels**, so it needs to be reconfigured to avoid violation of
terms.

![Intentionally simplified to highlight (1) many currently-free components of this
ecosystem are subject to change under the Anaconda, Inc. TOS, and (2)  **using the
official Anaconda, Inc. offerings like Anaconda and Miniconda requires non-trivial
knowledge to avoid accidental TOS violations**.](diagram.jpg)


## Conda Forge to the rescue

[Conda Forge](https://conda-forge.org/) is a community-owned collaboration providing
a higher-quality, more transparent, and free alternate distribution and repository to
the official Anaconda Distribution and Anaconda Public Repository.

The Conda Forge community serves as a
["safety net"](https://prefix.dev/blog/towards_a_vendor_lock_in_free_conda_experience)
against this and potential future changes to Anaconda's licensing and terms.
The community has already created alternate  multiple mirrors
([1](https://github.com/orgs/channel-mirrors/packages),
[2](https://prefix.dev/channels/conda-forge)) of the distribution, as well as
[the means for anyone to create their own](https://github.com/mamba-org/quetz#create-a-mirroring-channel).

The community has also created fully open alternative installers, of which
[miniforge](https://github.com/conda-forge/miniforge) provides the closest parity to the
Miniconda user experience.
Also of note is [`pixi`](https://pixi.sh/latest/), which provides an overhauled user
experience that, in my view, requires significantly less background knowledge to use
effectively than the `conda` workflow.
However, `pixi` is still a young project and may have rough edges.


## What do we do now? {#sec-what-now}

### What to do

<!-- alex ignore simple straightforward -->
This is the "keep it simple" version of what to do.
There are many other options, but this one is the most straightforward, in my view.

* Stop using the official Anaconda and Miniconda distributions.
  They are set up to use proprietary features by default and present a risk of license
  violation out-of-the-box.
* Use [miniforge](https://github.com/conda-forge/miniforge).
  The user experience parallels Miniconda, except it's set up to use only the free `"conda-forge"` channel out-of-the-box.
  It also includes `mamba`, a faster drop-in replacement for the `conda` command.
* If you want to be extra sure you won't accidentally use a proprietary channel, specify
  `"nodefaults"` in your conda environment's channels list.


### What not to do

* Don't leave the Anaconda ecosystem -- the open source community has our backs.
* Don't block `[conda].anaconda.org` in your corporate network.
  It is free to use for free channels like `"conda-forge"`.
  If and when that changes, the Conda Forge community will provide robust alternatives.
  Note you can block `repo.anaconda.com` to prevent access to the most common access point of `defaults`.
* Don't create a policy preventing installation or use of the `conda` command.


## More context from a co-founder

Last week, Peter Wang, co-founder of Anaconda, Inc., authored
[a post on LinkedIn expressing concern over the reaction to the TOS changes](https://www.linkedin.com/posts/pzwang_hi-everyone-recently-there-has-been-discussion-activity-7229549723462905856-rQH-/?utm_source=share&utm_medium=member_desktop).

Peter says (emphasis mine):

> I want to be very clear: **Anaconda's installers & package repos are free for teaching,
> learning, and research at accredited educational institutions worldwide.**
>
> [...]
>
> Our legal team is taking a comprehensive look at the wording in our current ToS, EULA,
> and related documents, with a focus on clarity for academic and academic research use.
> Our intent is to complete this by the end of this year.

The bolded section of this text directly contradicts Anaconda, Inc.'s TOS as written.
**Coupled with early reports of legal & back-billing threats, I would not feel
comfortable acting based on this claim.**

Let's wait and see what happens later this year. I'll try to keep this post updated.


## Conclusion

This is no fun.
Nobody likes dealing with this.
I don't, and I strongly doubt I got everything right.
I would be grateful to anyone who can comment on this post or submit a PR to fix any
mistakes, unclearness, or omissions!


## Updates

:::{.callout-note}
I'll try to write here if there are any important updates to this situation.
:::
