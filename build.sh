#! /bin/bash

set -e

DEPLOY_REPO="https://${GITHUB_TOKEN}@github.com/alycejenni/alycejenni.github.io.git"

# remove _site
rm -rf _site

# build
bundle exec jekyll build

rm -rf !(.git|_site)
mv _site/* ./

# push
git remote set-url origin $DEPLOY_REPO
git add .
git commit -a -m ":rocket: #$TRAVIS_BUILD_NUMBER"
git push --force --no-verify origin dev:master
