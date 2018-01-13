#! /bin/bash

set -e

DEPLOY_REPO="https://${GITHUB_TOKEN}@github.com/alycejenni/alycejenni.github.io.git"

# remove _site
rm -rf _site

# build
bundle exec jekyll build

shopt -s extglob
rm -rf -- !(.git|_site|.|..)
mv _site/* ./
ls -A

# push
git remote set-url origin $DEPLOY_REPO
git add .
git reset Gemfile*
git reset build.sh
git commit -a -m ":rocket: #$TRAVIS_BUILD_NUMBER"
git push --force --no-verify origin HEAD:master
