#!/bin/bash
echo 'Fetch Data and Reset Head'
git fetch --all
git reset --hard origin/hexo
echo 'Install Dependences'
npm install
echo 'Hexo Build'
hexo g
echo 'travis auto deploy success'