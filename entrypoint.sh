#!/bin/bash

cd ${GITHUB_WORKSPACE}

#debdir is from puppet:/modules/custom_debs/files
echo "## install debdir"
dpkg -i /debdir/*.deb

echo "## reviewdog --version"
reviewdog --version
echo "## perl --version"
perl --version
echo "## perlcritic --version"
perlcritic --version
echo "## cpanm -V"
cpanm -V

echo "## Running cpanm --installdeps ."
#cpanm --installdeps --force --notest . 
#TODO: much slower, but maybe the above line doesn't install module sub-depedencies?
cpanm --installdeps . 

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"
export PERL5LIB="${GITHUB_WORKSPACE}/modules"
FILES=`git diff --name-only origin/master | grep -P "(\.pl|\.pm|\.cgi)$"`

echo "## Running perlcritic"
perlcritic --gentle --profile /.perlcriticrc $FILES |
    reviewdog -name="perlcritic" -filter-mode=file -efm="%f:%l:%c:%m" -reporter="github-pr-check"

#export ESC_GITHUB_WORKSPACE=$(echo "$GITHUB_WORKSPACE" | perl -pe 's/\//\\\//g')

# SUBSTR below puts the "perl -c format" into "file:line:error" format for reviewdog.
# (Also trims ./ or ../../ or /somedir/ from beginning of file path.)
export SUBSTR="s/(.*) at (.\/|\/github\/workspace\/|)(.*) line (\d+)(.*)/\$3:\$4:\$1/g"

echo "## Running perl -c (on *.pm)"
temp_file=$(mktemp)

for x in $FILES
do
   perl -c $x |& grep -v " syntax OK" | perl -pe "$SUBSTR" >>$temp_file
done

cat ${temp_file} |
   reviewdog -name="perl-syntax" -filter-mode=file  -efm="%f:%l:%m" -reporter="github-pr-check"

rm ${temp_file}
