#!/bin/bash
# WSL bootstrap — loads global aliases, then active project aliases.
# Called from ~/.bashrc on every interactive shell start.
#
# Configure active project:
#   echo "/path/to/your/project" > ~/.wsl-project
# Or use the alias:
#   ruu-project-set /home/r-uu/develop/github/app-pragma-java
#
# Each project exposes its WSL configuration in:
#   <project>/env/wsl/*.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Global aliases (wsl-env)
source "$SCRIPT_DIR/aliases.sh"

# 2. Project-specific aliases
WSL_PROJECT_FILE="$HOME/.wsl-project"
if [ -f "$WSL_PROJECT_FILE" ]; then
    PROJECT_DIR="$(cat "$WSL_PROJECT_FILE" | tr -d '[:space:]')"
    if [ -n "$PROJECT_DIR" ] && [ -d "$PROJECT_DIR/env/wsl" ]; then
        for f in "$PROJECT_DIR"/env/wsl/*.sh; do
            [ -f "$f" ] && source "$f"
        done
    fi
fi
