#!/bin/bash

cd ${GITHUB_WORKSPACE}

echo "## reviewdog --version"
reviewdog --version
echo "## perl --version"
perl --version
echo "## perlcritic --version"
perlcritic --version
echo "## cpanm -V"
cpanm -V

echo "## git status"
git status
echo "## git fetch --all"
git fetch --all
echo "## git branch"
git branch --all
echo "## git diff --name-only origin/master"
git diff --name-only origin/master

# echo "## Running cpanm --installdeps ."
# cpanm --installdeps --force --notest . 
#
# export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"
#
# export PERL5LIB="${GITHUB_WORKSPACE}/modules"

# echo "## Running perlcritic"
# find . -regex '.*\.\(pl\|pm\|cgi\)' -exec perlcritic --gentle --profile /.perlcriticrc {} \; |
#    reviewdog -name="perlcritic" -filter-mode=file -efm="%f:%l:%c:%m" -reporter="github-pr-check"

# #export ESC_GITHUB_WORKSPACE=$(echo "$GITHUB_WORKSPACE" | perl -pe 's/\//\\\//g')

# # SUBSTR below puts the "perl -c format" into "file:line:error" format for reviewdog.
# # (Also trims ./ or ../../ or /somedir/ from beginning of file path.)
# export SUBSTR="s/(.*) at (.\/|\/github\/workspace\/)(.*) line (\d+)(.*)/\$3:\$4:\$1/g"

# echo "## Running perl -c (on *.pm)"
# find . -regex '.*\.\(pl\|pm\|cgi\)' -exec perl -c {} 2>&1 \; |
#    grep -v " syntax OK" |
#    perl -pe "$SUBSTR" |
#    reviewdog -name="perl-syntax" -filter-mode=file  -efm="%f:%l:%m" -reporter="github-pr-check"
