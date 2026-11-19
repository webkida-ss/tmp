function peco-select-history() {
    BUFFER=$(\history -n -r 1 | awk '!seen[$0]++' | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-select-history
bindkey '^h' peco-select-history

# git
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gcm='git commit'
alias gpo='git push origin'
alias grb='git rebase'
alias gpo-f='git push origin --force-with-lease'
alias gfo='git fetch origin'
alias gm='git merge'
alias gms='git merge --squash'
alias gmf='git merge FETCH_HEAD'
alias gb='git branch'
alias gl='git log'
alias gsw='git switch'
alias gsc='git switch -c'
alias gre='git restore'

unalias gsb 2>/dev/null
gsb() {
    local branch
    branch=$(git branch --sort=-committerdate --format='%(refname:short)' 2>/dev/null | fzf --prompt='branch> ')
    [ -n "$branch" ] && git switch "$branch" || echo "No branch selected"
}

unalias gbd 2>/dev/null
gbd() {
    local branch
    local current
    local answer
    local force_answer
    current=$(git branch --show-current 2>/dev/null)
    branch=$(git branch --sort=-committerdate --format='%(refname:short)' 2>/dev/null | awk -v current="$current" '$0 != current' | fzf --prompt='delete branch> ')

    if [ -z "$branch" ]; then
        echo "No branch selected"
        return 1
    fi

    printf "Delete branch '%s'? [y/N] " "$branch"
    read -r answer
    case "$answer" in
        [Yy]*)
            if ! git branch -d "$branch"; then
                printf "Force delete branch '%s' with -D? [y/N] " "$branch"
                read -r force_answer
                case "$force_answer" in
                    [Yy]*) git branch -D "$branch" ;;
                    *) echo "Force delete cancelled" ;;
                esac
            fi
            ;;
        *) echo "Branch delete cancelled" ;;
    esac
}

alias gwa='git worktree add'
alias gwr='git worktree remove'
alias gwl='git worktree list'
alias gwp='git worktree prune'

unalias gwt 2>/dev/null
gwt() {
    local dir
    dir=$(git worktree list --porcelain | awk '/^worktree / {print $2}' | fzf --prompt='worktree> ')
    [ -n "$dir" ] && cd "$dir" || echo "No worktree selected"
}

alias gar="git reset HEAD" # git add 取り消し
alias gcr="git reset --soft HEAD^" # git commit 取り消し（直前）

# terraform
alias tf='terraform'
alias tfin='terraform init'
alias tfa='terraform apply'
alias tfp='terraform plan'
alias tff='terraform fmt --recursive'
alias tfim='terraform import'
alias tfss='terraform state show'
alias tfsl='terraform state list'
alias tfsr='terraform state rm'
alias tfsm='terraform state mv'
alias tui='tftui'
