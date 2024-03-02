function delete_squashed_branches --description 'Delete local branches that have been squash-merged into the default branch'
    # Define the default branch name
    set default_branch (get_default_branch)

    # Fetch the latest changes from the remote
    git fetch origin

    # Get a list of all local branches
    set branches (git for-each-ref --format='%(refname:short)' refs/heads/)

    # Loop through each branch
    for branch in $branches
        # Skip the default branch
        if test $branch = $default_branch
            continue
        end
        
        # Check if the current branch has been squash-merged into the default branch
        # This command checks if all commits in $branch are also in $default_branch
        set is_merged (git cherry -v $default_branch $branch | grep -v '^+' | wc -l)
        
        if test $is_merged -eq 0
            # The branch has been merged or all its commits are in the default branch, so it can be safely deleted
	    git branch -d $branch
        end
    end
end

