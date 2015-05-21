for branch in `git branch --no-merged`; do
    git merge $branch
done
