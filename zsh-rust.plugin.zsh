#!/usr/bin/env zsh
# shellcheck disable=SC1090

# Exit if the 'rustup', 'rustc' or 'cargo' commands can not be found
if ! (( $+commands[rustup] && $+commands[rustc] && $+commands[cargo] )); then
    echo "WARNING: 'rustup', 'rustc' or 'cargo' commands not found"
    return
fi

# Completions directory for `rustup` and `cargo` commands
local COMPLETIONS_DIR="${0:A:h}/completions"

# Add completions to the FPATH
typeset -TUx FPATH fpath
fpath=("$COMPLETIONS_DIR" $fpath)

# If the completion file does not exist yet, then we need to autoload
# and bind it to `rustup`. Otherwise, compinit will have already done that.
if [[ ! -f "$COMPLETIONS_DIR/_rustup" ]]; then
    typeset -g -A _comps
    autoload -Uz _rustup
    _comps[rustup]=_rustup
fi

# If the completion file does not exist yet, then we need to autoload
# and bind it to `cargo`. Otherwise, compinit will have already done that.
if [[ ! -f "$COMPLETIONS_DIR/_cargo" ]]; then
    typeset -g -A _comps
    autoload -Uz _cargo
    _comps[cargo]=_cargo
fi

# Generate and load completion in the background
rustup completions zsh rustup >| "$COMPLETIONS_DIR/_rustup" &|
cat "$(rustc --print sysroot)/share/zsh/site-functions/_cargo" >| "$COMPLETIONS_DIR/_cargo" &|
