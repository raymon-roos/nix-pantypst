## nix-pantypst 📚

> Tortured [portmanteau](https://en.wikipedia.org/wiki/Portmanteau) of Nix, pandoc, and Typst

A Nix flake to convert markdown files into nicely typeset, opinionated PDF documents
suitable for IT and other technical topics. Possible through the power of
[Pandoc](https://pandoc.org/) and [Typst](https://typst.app/). The flake outputs a wrapper
script, finagling pandoc arguments and bundling a Typst template based on [work by
JMax](https://imaginarytext.ca/posts/2025/typst-templates-for-pandoc/)

## Why?

For my study I do a lot of software projects. As software developers, we tend to write
project documentation in Markdown, as this tends to render/preview nicely on numerous
websites (case in point, this README). For my study I also have to assemble a portfolio of
materials for my grade each semester, and documentation is a big part of this. But the
online portfolio platforms thus far have not supported previewing Markdown, though they
support PDFs. Hence I often find myself converting Markdown to PDFs as part of my study.
It's also nice when sharing documents with outside stakeholders. Although Typst is really
ergonomic (10 times so compared to LaTeX!), writing plain Markdown is still simplest, so
I find myself reaching for that first.

Getting buy-in from a student team to adopt Typst for documentation is also no easy feat
(getting freshmen to adopt Markdown in favour of Micros\*\*\* Docx is already harder than
it should be 🙄). Hence, if I want to share markup documents with a team, it will have to
be Markdown.

I've used Pandoc in the past, but I've been styling the output in an ad-hoc fashion by
fiddling with the front matter and passing options. For my own sanity I want to automate
this process, so I don't have to worry about how to get the PDF to look right mere hours
before a deadline. On top of that, Typst has an order of magnitude faster compile time and
installation size compared to LaTeX. Typst produces high-quality accessible and durable
PDFs. Combined with the reproducibility of Nix, this project aims to guarantee identical
output, without running into missing fonts or packages.

## Usage

Run without installing:

```sh
nix run 'github:raymon-roos/nix-pantypst' -- <your_file>.md
```

Installation:

```nix
# flake.nix:
inputs = {
  pantypst.url = "github:raymon-roos/nix-pantypst";
  pantypst.inputs.nixpkgs.follows = "nixpkgs";
}

# home-manager configuration:
home.packages = [
    inputs.pantypst.packages.${pkgs.system}.default
];

# Alternatively, NixOS system configuration:
environment = {
  systemPackages = [
    inputs.pantypst.packages.${pkgs.system}.default
  ];
```

Now the following command is available for use:

```sh
mdtopdf document.md
```

Though not required, for the best results, the Markdown file should contain some basic
metadata inside a yaml frontmatter (just like with regular Pandoc).

```md
---
lang: nl # defaults to en
date: 2026-01-12
author: Raymon Roos
title: Vergelijking van API authenticatie- en sessiebeheer technieken voor ARSIevents
bibliography: references.bib
---

# Your document starts here
```

## Features

- [x] Trivial syntax, write ordinary Markdown. No need to fiddle with the pandoc
      invocation.
- [x] Template features only appear when used in the document. Works equally well with or
      without a title, or bibliography etc.
- [x] Opinionated typesetting. Minimal configuration in the source document.
- [x] IEEE style bibliography (when needed).
- [x] Dynamic title block.
- [ ] Passing options to pandoc/typst
- [ ] Pretty and functional code listings
- [ ] Pretty and functional block quotes
- [ ] Render diagrams-as-code
