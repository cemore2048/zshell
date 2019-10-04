# From https://github.com/nathanchapman/bash-functions/blob/master/.bashrc#L140

# Create a pull request for a repo
pr() {
    gitURL="$(git config --get remote.origin.url)"
    gitURL="${gitURL%.git}" # Remove .git from the end of the git URL
    if [[ $gitURL =~ ^git@ ]]; then
        gitURL="$(echo $gitURL | sed 's/git@//')" # Remove git@ from the start of the git URL
        github="$(echo $gitURL | sed 's/\:/\//')" # Replace the : between the URL and org with a / in the URL for GitHub
        branch="$(git symbolic-ref --short HEAD)"
        # open http://"$github"/compare/${1:-master}...${2:-"$branch"}?expand=1
        open http://"$github"/pull-requests/new\?source=${2:-"$branch"}
    elif [[ $gitURL =~ ^https?:// ]]; then
        branch="$(git symbolic-ref --short HEAD)"
        # open "$gitURL"/compare/${1:-master}...${2:-"$branch"}?expand=1
        open "$gitURL"/pull-requests/new\?source=${2:-"$branch"}
    elif [[ ! -z $1 && ! -z $2 ]]; then
        # open https://github.x.com/"$1"/"$2"/compare/${3:-master}...${4:-master}?expand=1
        open https://bitbucket.org/"$1"/"$2"/pull-requests/new\?source=${4:-master}
    else
        echo "⚠️  Usage: pr <org*> <repo*> <base-branch> <branch-to-compare>"
        return 1
    fi
    echo "✏️  Creating pull request"
}
