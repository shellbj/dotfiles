# add a function path
fpath=($ZSH/functions $ZSH/completions $fpath)

# Load all of the config files 
for config_file ($ZSH/lib/*.zsh); do
  source $config_file
done

is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.zsh \
    || test -f $base_dir/plugins/$name/_$name
}
# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
    if is_plugin $ZSH $plugin; then
        fpath=($ZSH/plugins/$plugin $fpath)
    fi
done

# Load and run compinit
autoload -U compinit
compinit -i

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins); do
    if [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
        source $ZSH/plugins/$plugin/$plugin.plugin.zsh
    fi
done

# Load all of the environment specific config files
if [ -s "$ZSH/env/$(hostname)/zshrc.zsh" ]; then
    source $ZSH/env/$(hostname)/zshrc.zsh
fi

if [ ! "$ZSH_THEME" = ""  ]; then
    if [ -f $ZSH/themes/$ZSH_THEME.theme.zsh ]; then
        source $ZSH/themes/$ZSH_THEME.theme.zsh
    fi
fi



