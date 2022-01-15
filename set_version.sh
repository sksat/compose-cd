#!/bin/bash

new_ver="$1"
sed -i -e "s/compose_cd_ver=\".*\"/compose_cd_ver=\"${new_ver}\"/g" compose-cd
git status
git add compose-cd
git commit -m "release: ${new_ver}"
git tag "${new_ver}"
