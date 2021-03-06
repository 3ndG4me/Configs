# Zeta theme for oh-my-zsh
# Tested on Linux, Unix and Windows under ANSI colors.
# Copyright: Skyler Lee, 2015

# Colors: black|red|blue|green|yellow|magenta|cyan|white
local black=$fg[black]
local red=$fg[red]
local blue=$fg[blue]
local green=$fg[green]
local yellow=$fg[yellow]
local magenta=$fg[magenta]
local cyan=$fg[cyan]
local white=$fg[white]
local orange="\033[38;5;214m"

local black_bold=$fg_bold[black]
local red_bold=$fg_bold[red]
local blue_bold=$fg_bold[blue]
local green_bold=$fg_bold[green]
local yellow_bold=$fg_bold[yellow]
local magenta_bold=$fg_bold[magenta]
local cyan_bold=$fg_bold[cyan]
local white_bold=$fg_bold[white]

local highlight_bg=$bg[red]

local blink="\e[5m"
local underlined="\e[4m"
local bold="\e[1m"

local hax='|\n└'

local LSCOLORS=Fx
local CLICOLOR=1


# Greeting Header

cat << "EOF"
                        |'-'-'|
                         |===|
                         |   |
                         |   |
                         )___(
                        (=====)
                        }====={
EOF
local MOTD1="57 65 6c 63 "
local MOTD2="6f 6d 65 20 "
local MOTD3="62 61 63 6b "
local MOTD4="20 33 6e 64 "
local MOTD5="47 34 6d 65 21"
echo -e "${bold}${blink}${underlined}${cyan}$MOTD1${reset_color}${bold}${blink}${underlined}${red}$MOTD2${reset_color}${bold}${blink}${underlined}${green}$MOTD3${reset_color}${bold}${blink}${underlined}${orange}$MOTD4${reset_color}${bold}${blink}${underlined}${magenta}$MOTD5${reset_color}"

# Machine name.
function get_box_name {
    if [ -f ~/.box-name ]; then
        cat ~/.box-name
    else
        echo $HOST
    fi
}

# User name.
function get_usr_name {
    local name="%n"
    if [[ "$USER" == 'root' ]]; then
        name="%{$highlight_bg%}%{$white_bold%}$name%{$reset_color%}"
    fi
    echo $name
}

# Directory info.
function get_current_dir {
    echo "${PWD/#$HOME/~}"
}

# Git info.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$blue_bold%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$green_bold%} ✔ "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$red_bold%} ✘ "

# Git status.
ZSH_THEME_GIT_PROMPT_ADDED="%{$green_bold%}+"
ZSH_THEME_GIT_PROMPT_DELETED="%{$red_bold%}-"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$magenta_bold%}*"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$blue_bold%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$cyan_bold%}="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$yellow_bold%}?"

# Git sha.
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="[%{$yellow%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}]"

function get_git_prompt {
    if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
        local git_status="$(git_prompt_status)"
        if [[ -n $git_status ]]; then
            git_status="[$git_status%{$reset_color%}]"
        fi
        local git_prompt=" <$(git_prompt_info)$git_status>"
        echo $git_prompt
    fi
}

function get_time_stamp {
    echo "%D - %*"
}

function get_space {
    local str=$1$2
    local zero='%([BSUbfksu]|([FB]|){*})'
    local len=${#${(S%%)str//$~zero/}}
    local size=$(( $COLUMNS - $len - 1 ))
    local space=""
    while [[ $size -gt 0 ]]; do
        space="$space "
        let size=$size-1
    done
    echo $space
}

# Prompt: # USER@MACHINE: DIRECTORY <BRANCH [STATUS]> --- (TIME_STAMP)
# > command
function print_prompt_head {
    local left_prompt="\
%{$white%}┌————— \
%{$cyan_bold%}$(get_usr_name)\
%{$red%}@\
%{$green_bold%}$(get_box_name): \
%{$yellow_bold%}$(get_current_dir)%{$reset_color%}\
$(get_git_prompt) "
    local right_prompt="%{$red%}[$(get_time_stamp)]%{$reset_color%} "
    print -rP "$left_prompt$(get_space $left_prompt $right_prompt)$right_prompt"
}

function get_prompt_indicator {
    echo "%{$white%}$hax%{$red_bold%}>%{$green_bold%}>%{$yellow_bold%}>%{$reset_color%} "
}

autoload -U add-zsh-hook
add-zsh-hook precmd print_prompt_head
setopt prompt_subst

PROMPT='$(get_prompt_indicator)'
RPROMPT='$(git_prompt_short_sha) '
