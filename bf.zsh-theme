# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%} | %{$fg[red]%}✗"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%} | %{$fg[green]%}✔︎"
# 
# # function prompt_char {
# # 	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
# # }
# 
PROMPT='
%{$fg_bold[magenta]%}%~ %{$reset_color%}($(git_info))
→ '

RPROMPT='%{$fg[cyan]%}[%*]%{$reset_color%}'


setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

# Echoes information about Git repository status when inside a Git repository
git_info() {
  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return
  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}
  local MERGING="%{$fg[magenta]%}⤻ %{$reset_color%}"
  local UNTRACKED="%{$fg[yellow]%}🆕 %{$reset_color%}"
  local MODIFIED="%{$fg[red]%}* %{$reset_color%}"
  local STAGED="%{$fg[green]%}+ %{$reset_color%}"

  local -a FLAGS

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
	GIT_INFO+=( "\033[38;5;15m$GIT_LOCATION%{$reset_color%}" )
  [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  echo "${(j: :)GIT_INFO}"
}
