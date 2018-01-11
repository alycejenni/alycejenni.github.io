#! /bin/bash
# shamelessly lifted from https://ayastreb.me/deploy-jekyll-to-github-pages-with-travis-ci/

set -e

DEPLOY_REPO="https://${DEPLOY_BLOG_TOKEN}@github.com/alycejenni/alycejenni.github.io.git"

# skip if build is triggered by pull request
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  exit 0
fi

# enable error reporting to the console
set -e

# cleanup "_site"
rm -rf _site
mkdir _site

# clone remote repo
git clone -b dev ${DEPLOY_REPO}
cd alycejenni.github.io

# switch to master
git checkout master

# build with Jekyll into "_site"
bundle exec jekyll build

# push
git config user.email "alycejenni@gmail.com"
git config user.name "Alice Butcher"
git add --all
git commit -a -m ":rocket: #$TRAVIS_BUILD_NUMBER"
git push
