#!/bin/bash

echo "## reviewdog --version"
reviewdog --version
echo "## perl --version"
perl --version
echo "## perlcritic --version"
perlcritic --version
echo "## cpanm -V"
cpanm -V

cpanm --installdeps . 

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

export PERL5LIB="${GITHUB_WORKSPACE}/modules"

echo "## Running perlcritic"
perlcritic --gentle --profile /.perlcriticrc modules/NFFS/*.pm | reviewdog -name="perlcritic" -efm="%f:%l:%c:%m" -reporter="github-pr-check"

export ESC_GITHUB_WORKSPACE=$(echo "$GITHUB_WORKSPACE" | perl -pe 's/\//\\\//g')
export SUBSTR="s/(.*) at (\.\/|$ESC_GITHUB_WORKSPACE)(.*) line (\d+)(.*)/\$3:\$4:\$1/g"

echo "## Running perl -c (on *.pm)"
find . -name \*.pm -exec perl -c {} 2>&1 \; | grep -v " syntax OK" | perl -pe "$SUBSTR" | reviewdog -name="perl-syntax" -efm="%f:%l:%m" -reporter="github-pr-check"

# if [[ "$*" == "" ]]; then
# 	echo "Please specify paths in your repo to run Perl Critic on"
#     	exit 1
# fi

# if [[ "$*" == "git-diff" ]]; then
#     echo "Using SHA: $GITHUB_SHA"
#     FILES=`git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | grep -e "\.pm$" -e "\.pl$" -e "\.cgi$"`
#     violations=$(perlcritic $FILES)
# else
#     violations=$(perlcritic $*)
# fi

# success=$?
# echo "$violations"

# if [ $success -ne 0 ]; then
#     #Report the critic violations in a comment on the commit

#     COMMENT="#### Perl Critic Notes (Level 5 - gentle):
# <pre>$violations</pre>"
#     PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
#     COMMIT_URL="https://api.github.com/repos/"$GITHUB_REPOSITORY/commits/$GITHUB_SHA/comments
#     echo "Pushing payload to $COMMIT_URL"
#     curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMIT_URL" > /dev/null

#     exit 1
# fi

# exit 0
