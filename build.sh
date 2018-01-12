#! /bin/bash

set -e

DEPLOY_REPO="https://${TOKEN}@github.com/alycejenni/alycejenni.github.io.git"

# remove _site
rm -rf _site

# build
bundle exec jekyll build

# copy the git repo into the _site folder
cp -r .git _site/
cd _site

# push
git remote set-url origin $DEPLOY_REPO
git add .
git commit -a -m ":rocket: #$TRAVIS_BUILD_NUMBER"
git push --force --no-verify origin dev:master
