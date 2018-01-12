#! /bin/bash
# shamelessly lifted from https://ayastreb.me/deploy-jekyll-to-github-pages-with-travis-ci/

set -e

REPO="https://github.com/alycejenni/alycejenni.github.io.git"

# skip if build is triggered by pull request
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  exit 0
fi

# enable error reporting to the console
set -e

rm -rf alycejenni.github.io

# clone remote repo
git clone -b dev ${DEPLOY_REPO}
cd alycejenni.github.io

# build with Jekyll
bundle exec jekyll build
