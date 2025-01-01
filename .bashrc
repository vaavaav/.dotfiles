set -o vi                                         # vi mode
bind 'TAB:menu-complete'                          # cycle through matches
bind '"\eZ":menu-complete-backward'               # Cycle backwards
bind 'set show-all-if-ambiguous on'               # list multiple matches
bind 'set menu-complete-display-prefix on'        # try to complete and list all
bind 'set colored-completion-prefix on'           # colorize common prefix
bind 'set completion-ignore-case on'              # case insensitive completion
bind 'set mark-symlinked-directories on'          # mark symlinked directories
bind 'set enable-bracketed-paste on'              # paste as text not commands
bind -m vi-command '"?":reverse-search-history'   # reverse search
bind -m vi-insert '"\eK":history-search-backward' # backwards search
bind -m vi-insert '"\eJ":history-search-forward'  # forwards search
export HISTCONTROL=erasedups                      # ignore duplicate commands
alias kys="poweroff"
alias ls="ls --color=auto"

# Prompt
PROMPT_DIRTRIM=3
PS1='\[\e[40m\] \u@\h \[\e[0;30;44m\] \w $( \
    if git rev-parse --git-dir > /dev/null 2>&1; then \
        if git rev-parse --verify HEAD > /dev/null 2>&1; then \
            if git symbolic-ref HEAD > /dev/null 2>&1; then \
                branch_name=$(git rev-parse --abbrev-ref HEAD); \
            else \
                branch_name=$(git rev-parse --short HEAD); \
            fi; \
        else \
            branch_name="(no commits)"; \
        fi; \
        N=$( \
            if git diff --quiet && \
               git diff --cached --quiet && \
               ! git ls-files --others --exclude-standard | grep . > /dev/null 2>&1; then \
                echo "2"; \
            else \
                echo "3"; \
            fi; \
        ); \
        echo "\[\e[0;34;4${N}m\]\[\e[0;30;4${N}m\] $branch_name \[\e[0;3${N}m\]"; \
    else \
        echo "\[\e[0;34m\]"; \
    fi) \[\e[0m\]'

# Environment Vars
export VISUAL="nvim"
export EDITOR="nvim"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH" # Haskell

# Start SSH agent automatically
if ! pgrep -u "$USER" ssh-agent >/dev/null; then
  ssh-agent -t 1h >"$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
  source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
