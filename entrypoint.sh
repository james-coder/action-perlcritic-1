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

echo "## Running cpanm --installdeps ."
cpanm --installdeps . 

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

export PERL5LIB="${GITHUB_WORKSPACE}/modules"

echo "## Running perlcritic"
perlcritic --gentle --profile /.perlcriticrc modules/NFFS/*.pm |
   reviewdog -name="perlcritic" -filter-mode=file -fail-on-error -efm="%f:%l:%c:%m" -reporter="github-pr-check"

export ESC_GITHUB_WORKSPACE=$(echo "$GITHUB_WORKSPACE" | perl -pe 's/\//\\\//g')

# SUBSTR below puts the "perl -c format" into "file:line:error" format for reviewdog.
# (Also trims ./ or ../../ or /somedir/ from beginning of file path.)
#export SUBSTR="s/(.*) at (\.\/|\.\.\/\.\.\/|$ESC_GITHUB_WORKSPACE)(.*) line (\d+)(.*)/\$3:\$4:\$1/g"
export SUBSTR="s/(.*) at (.\/|\/github\/workspace\/)(.*) line (\d+)(.*)/\$3:\$4:\$1/g"

echo "## Running perl -c (on *.pm)"
find . -name \*.pm -exec perl -c {} 2>&1 \; |
   grep -v " syntax OK" |
   perl -pe "$SUBSTR" |
   reviewdog -name="perl-syntax" -efm="%f:%l:%m" -reporter="github-pr-check"

# "\.pm$" -e "\.pl$" -e "\.cgi$"`
