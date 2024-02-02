export BROWSER=sensible-browser
if [[ ! -d "$HOME/.local/bin" ]]; then
	mkdir "$HOME/.local/bin"
fi
export PATH="$HOME/.local/bin:$PATH"



################################################################################
################################################################################
################################## fzf config ##################################
################################################################################
################################################################################

 # Use the CLI fd to respect ignore files (like '.gitignore'),
# display hidden files, and exclude the '.git' directory.
export FZF_DEFAULT_COMMAND='fd . --hidden --exclude ".git" --exclude .venv'

# Use the CLI ripgrep to respect ignore files (like '.gitignore'),
# display hidden files, and exclude the '.git' directory.
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git" --glob "!.venv"'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=$PATH:/usr/local/go/bin
