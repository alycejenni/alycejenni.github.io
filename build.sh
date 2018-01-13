#! /bin/bash

set -e

# remove _site
rm -rf _site

# build
bundle exec jekyll build

# change to build directory
cd _site

# set up a new git repo
git init
DEPLOY_REPO="https://${GITHUB_TOKEN}@github.com/alycejenni/alycejenni.github.io.git"
git remote add origin $DEPLOY_REPO

# deploy
git add .
git reset Gemfile*
git reset build.sh
git commit -a -m ":rocket: #$TRAVIS_BUILD_NUMBER"
git push --force --no-verify origin HEAD:master
