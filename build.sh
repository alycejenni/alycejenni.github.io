#! /bin/bash

set -e

DEPLOY_REPO="https://${GITHUB_TOKEN}@github.com/alycejenni/alycejenni.github.io.git"

# enable error reporting to the console
set -e

# build
bundle exec jekyll build

# copy the git repo into the _site folder
cp -r .git _site/
cd _site

# push
git config user.email "alycejenni@gmail.com"
git config user.name "Travis"
git add --all
git commit -a -m ":rocket: #$TRAVIS_BUILD_NUMBER"
git push --force --no-verify origin dev:master
