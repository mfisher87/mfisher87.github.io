---
title: "Technique specifications"
description: "Techniques are often casually shared in gists, READMEs, and Stack Overflow posts, but we lack accessible methods to track their evolution."
date: "2023-10-07"
categories:
  - "reproducibility"
  - "ideas"
---

I was recently discussing the ["remote git worktree" dotfile-management
approach](https://github.com/mfisher87/dotfiles). I don't really know if there's a
canonical name for it. I learned about it some time back, and I don't remember where. I
struggled to find any comprehensive resources or documentation to learn about or adopt
the approach, so I did not adopt it. This year (2023), a demonstration by [Fernando
Perez](https://github.com/fperez) in a workshop convinced me to adopt it. The
documentation in [his dotfile repo](https://github.com/fperez/dotfiles) is quite
friendly, and I'm now a happy user.

I don't think this experience is unique. A large number of distributed individuals have
adopted this technique and done their best to document it, but because there is no
shared resource (like a specification) to document the technique, tracking its evolution
is incredibly difficult. I can't easily find the answer to "what's the latest version of
this technique?"


## :sparkles: Technique specifications

I propose a practice of documenting "technique specifications", a form of technical
specification that robustly specifies the method, constraints, benefits, and limitations
of a technique.

Adopting existing best practices for specifications, like [RFC2119: Key words for use in
RFCs to Indicate Requirement Levels](https://www.ietf.org/rfc/rfc2119.txt) is, I feel,
critical for producing specifications that are useful.


### Accessibility

Specifications are, I think, seen as a lot of work, but that shouldn't be a reason we
can't have them. Conda Forge, for example, has tens of thousands of conda packages that
are maintained by volunteers. Packaging is a lot of work, too. I feel that the key to
success is making this work more accessible by providing quality support.


### Version control

Specifications should be written in Markdown and version-controlled on GitHub to
maximize accessibility.


### Reproduction

I feel reproducibility is very important to a technique specification, so I think it's
important to include a "reference implementation" of the specification, which really is
just a fancy way to say "tutorial". Tutorials should be very low-level step-by-step
instructions written for someone with no prior knowledge.


### Value proposition

Should specifications include an argument for their own value?


### Findability

How do you _find_ technique specifications?


## :test_tube: Ideas

* Do some research... is anyone else thinking about this or doing this?
* Write a technique specification for documenting technique specifications
* Create a GitHub org to aggregate specifications and help people author them?
    * Build a website that's generated from this org to aid in findability?
