function get_default_branch --description 'Get the default branch of the current repository'
    git remote show origin | grep 'HEAD branch' | sed 's/.*: //'
end
