---
layout: "post"
title: "deploying to github pages with travis ci"
date: "2018-01-13"
excerpt_separator:  <!--more-->
---

Anyone who looks at the commit history for my github.io page will notice that I had a _little_ bit of trouble getting it to work the way I wanted.

So partly for my benefit and partly for anyone in the same boat who might stumble across this, I'm going to go through my now functional deployment process. It might not be the best way to do anything, and it might not be pretty, but it works and at the moment I'm happy with that.

<!--more-->

The local site was easy to set up. Everything built and ran fine. Then as soon as I `git push`, I've got an email saying my page build has failed. Turns out GitHub Pages is quite fussy about what it can build.

After reading a few guides and blog posts much like this one, I decided to try and build the page using [Travis CI](https://travis-ci.org) instead, then deploy to GitHub Pages from there. Unfortunately I'm an idiot who didn't really know anything about either service beforehand, so this took _a lot_ of trial, error, and commit messages like `:construction: gonna cry` and `:construction: aghhhh`.

## requirements
- A working local install of your site (I'm using [Jekyll](https://jekyllrb.com) but I'm just using bash scripts so this could work for anything)
- A repository for your GitHub Pages site (see [here](https://pages.github.com))

## github setup

### branches
GitHub Pages will display content from a specific branch of your repository. If it's a project site, it'll display from `gh-pages`, and if it's a personal site, it'll display from `master`.

As far as I can tell, if it find something it could potentially build in that branch, like a `Gemfile`, it'll try to build it. But if it's just a collection of static HTML/CSS files then it'll just display those. So with that in mind, my repo has two branches: `dev`, which contains all the build information, and `master`, which is just the site files. I don't ever really need to push anything to `master` - everything goes to `dev`, Travis builds it, then pushes the build to `master`.

### tokens
To give Travis permission to deploy your site, you'll need to supply it with a **personal access token** from [github.com/settings/tokens](https://github.com/settings/tokens). I've given mine `repo`, `admin:repo_hook`, and `gist` permissions.

Add the token value as an environment variable called `GITHUB_TOKEN` in the project settings on Travis.

## build script
You need a script for Travis to run to build and deploy the site. I've called mine `build.sh` and it just lives in the root folder on `dev`.

It has three main parts:

### 1. build
Whatever commands you need to build the site. For mine, this is pretty much just:

```bash
bundle exec jekyll build
```

### 2. rearrange
Organise the repository so it can be pushed to master. My site is built to a folder called `_site`, so I can just switch to that directory and set it up as a new git repository.

```bash
# change to build directory
cd _site

# set up a new git repo
git init
DEPLOY_REPO="https://${GITHUB_TOKEN}@github.com/alycejenni/alycejenni.github.io.git"
git remote add origin $DEPLOY_REPO
```

### 3. deploy
Actually commit and push everything.


```bash
# deploy
git add .
git commit -a -m ":rocket: #$TRAVIS_BUILD_NUMBER"
git push --force --no-verify origin HEAD:master
```

This _will_ overwrite all your previous commits to the master branch, so if you want to keep them then you'll have to find some other way around it. All the commits to dev are preserved though so that should be fine.

## travis setup

### web setup
There are only really two things you need to do:

1. Enable builds for your repo (go to your profile and flip the switch next to your repo name to 'on');
2. Add the `GITHUB_TOKEN` environment variable (see above).

### .travis.yml
This is the file in your root directory that tells travis how to build your project. Mine is largely based on [this guide](https://jekyllrb.com/docs/continuous-integration/travis-ci) in the Jekyll docs.

```yaml
# language to use
language: ruby
rvm:
- 2.5.0

# build script to run; just a shell command
before_script:
- chmod +x ./build.sh
script: "./build.sh"

# only run for pushes to these branches
branches:
  only:
  - dev

# some variables for speed improvements
env:
  global:
  - NOKOGIRI_USE_SYSTEM_LIBRARIES=true
sudo: false
```

## that's it
Once that's all set up, push to dev and Travis should start building. It might take a couple of minutes, but at the end it should then push your site to the `master` branch, which will then be displayed at your URL.
