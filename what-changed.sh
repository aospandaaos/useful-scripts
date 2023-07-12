#!/bin/bash

if [ $# -eq 2 ]; then
	FIRST_TAG=$1
	SECOND_TAG=$2
	SHOW_DIFF=false
elif [ $# -eq 3 ]; then
	if [ $1 == "-diff" ]; then
		FIRST_TAG=$2
		SECOND_TAG=$3
		SHOW_DIFF=true
	else
		REPO_NAME=$1
		FIRST_TAG=$2
		SECOND_TAG=$3
		echo "one repo: $REPO_NAME"
		REPOCMD="git diff ${FIRST_TAG}..${SECOND_TAG}"
		echo "repo forall $REPO_NAME -c $REPOCMD"
		repo forall $REPO_NAME -c $REPOCMD
		exit
	fi
else
	echo "Show what changed between two git tags"
	echo "Usage 1: $0 first-tag second-tag         - list projects with changes"
	echo "Usage 2: $0 -diff first-tag second-tag   - show diff of projects with changes"
	echo "Usage 3: $0 repo first-tag second-tag    - show diff for one project"
	exit 0
fi


# Check that the first tag is a branch in this repo
REPOCMD="if ! git tag | grep ${FIRST_TAG} 2>&1 > /dev/null; then "
REPOCMD+='echo -n $REPO_PATH;'
REPOCMD+="echo -n ' WAS ADDED ';"
#REPOCMD+="${FIRST_TAG};"
# If the second tag does not exit, this repo was added since FIRST_TAG
#REPOCMD+="elif ! git tag | grep ${SECOND_TAG} 2>&1 > /dev/null; then "
#REPOCMD+='echo -n $REPO_PATH;'
#REPOCMD+="echo -n ' NEW FILE ';"
REPOCMD+="elif ! git diff --exit-code --quiet ${FIRST_TAG}..${SECOND_TAG} 2>&1 > /dev/null;then "
REPOCMD+='echo $REPO_PATH CHANGED;'
if ${SHOW_DIFF}; then
	REPOCMD+="git diff ${FIRST_TAG}..${SECOND_TAG};"
fi
REPOCMD+="fi"

# echo $REPOCMD

repo forall -c "$REPOCMD"


