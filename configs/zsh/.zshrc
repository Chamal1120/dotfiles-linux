# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =========================
# 1. Shell options & history
# =========================
# Keep Ctrl-S available for tmux prefix (disable XON/XOFF flow control)
#[[ -o interactive ]] && stty -ixon 2>/dev/null

setopt EXTENDED_GLOB
DISABLE_AUTO_TITLE="true"
FUNCNEST=10000

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# Ignore Ctrl-D exit in TMUX
if [[ -n "$TMUX" ]]; then
  setopt ignoreeof
fi

# =========================
# 2. Environment variables
# =========================

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Core PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$PATH:$HOME/.local/scripts/"
export MANPATH="$HOME/.local/man:$MANPATH"

# Neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# Java
export JAVA_HOME="/usr/lib/jvm/temurin-21-jdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/.local/bin/jdtls/bin:$PATH"
# Alternative: WSL2 native Java (OpenJDK 17)
# export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
# export PATH=$JAVA_HOME/bin:$PATH

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

# Flutter / Dart (FVM)
export PATH="$HOME/develop/flutter/bin:$PATH"
export PUB_CACHE="$HOME/.pub-cache"
export PATH="$PATH:$PUB_CACHE/bin"

# Maven
export M2_HOME="/opt/maven"

# .NET
export DOTNET_CLI_TELEMETRY_OPTOUT=1
#export PATH="$PATH:$HOME/.dotnet/tools"

# Node / npm
export PATH="$HOME/.npm-global/bin:$PATH"
export NODE_REPL_MODE=sloppy
export NODE_REPL_HISTORY_FILE=~/.node_repl_history
export NODE_NO_READLINE=0
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust / Bun
export PATH="$HOME/.cargo/bin:$HOME/.bun/bin:$PATH"

# Snap
export PATH="$PATH:/snap/bin"

# Golang
export PATH=$PATH:/usr/local/go/bin
export PATH="$PATH:$(go env GOPATH)/bin"

# opencode
export PATH=/home/chamal/.opencode/bin:$PATH

# Misc tooling
export FLASK_DEBUG=1
export BAT_CONFIG_PATH="$HOME/.config/bat/config/bat.conf"
export BAT_THEME="base16"
export COLORTERM=truecolor
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

# FZF
export FZF_DEFAULT_OPTS="--color=fg:#cdcdcd,bg:#141415,hl:#f3be7c,fg+:#bebeda,bg+:#252530,hl+:#f3be7c,\
border:#606079,header:#6e94b2,gutter:#141415,spinner:#7fa563,info:#f3be7c,\
pointer:#aeaed1,marker:#d8647e,prompt:#bb9dbd"
# Disable preview specifically for Ctrl+T file picker
export FZF_CTRL_T_OPTS="--preview ''"

# =========================
# 3. Vi-mode for Zsh
# =========================
bindkey -v
bindkey "^?" backward-delete-char
#bindkey '^S' undefined-key

# =========================
# 4. Aliases
# =========================
alias ls='eza --icons'
alias la='eza -a'
alias lla='eza -la'
alias ll='eza -l'
alias lt='eza -TL 2'
alias vim='nvim'
alias oc='opencode'
alias cl='claude --permission-mode bypassPermissions --model opus'
alias cx='codex --yolo'
alias cpl='copilot'
#alias cat='bat'
#alias yt-dlp-fhd='yt-dlp --config-location ~/.config/yt-dlp/yt-dlp.conf'
#alias yt-dlp-hd='yt-dlp --config-location ~/.config/yt-dlp/yt-dlp-720.conf'
#alias yt-dlp-audio='yt-dlp --config-location ~/.config/yt-dlp/yt-dlp-audio.conf'
#alias jrun='java --enable-preview --source 21'
#alias myed="ed -p ':'"

# Maven aliases
alias mvn-new-cli='mvn archetype:generate -DgroupId=com.myapp -DartifactId=my-cli-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false'
alias mci='mvn clean install'
#alias mcp='mvn clean package'
#alias mc='mvn clean'
#alias mrun='mvn exec:java -Dexec.mainClass="com.myapp.App"'
#alias mcit='mvn clean install -DskipTests'
#alias m-update='mvn versions:display-dependency-updates'

# =========================
# 5. Completion system
# =========================
autoload -Uz compinit
compinit

# Load bash completions
autoload -U bashcompinit && bashcompinit

# Completion behavior
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a=z}={A-Za-z}'
zstyle ':completions:*' list-colors ''
zstyle ':completions:*' squeeze-slashes true

# =========================
# 6. Plugins
# =========================
# Fast syntax highlighting
source $HOME/.zsh-plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# FZF integration (Ctrl+T, etc.)
source <(fzf --zsh)

# =========================
# 7. Custom keybinds
# =========================
bindkey -s '^f' 'tsesh\n'
bindkey -s '^g' 'gtr\n'

# =========================
# 8. Theme
# =========================
source ~/.zsh-plugins/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pnpm
export PNPM_HOME="/home/chamal/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

