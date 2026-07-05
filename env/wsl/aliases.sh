#!/bin/bash
# Global WSL aliases — project-independent, loaded on every WSL start.
# Repository: wsl-env → env/wsl/aliases.sh
# Loaded by:  env/wsl/bootstrap.sh

unalias -a 2>/dev/null

# ═══════════════════════════════════════════════════════════════════
# Alias management
# ═══════════════════════════════════════════════════════════════════
alias ruu-aliases-reload='source ~/develop/github/wsl-env/env/wsl/bootstrap.sh && echo "✅ Aliases reloaded"'
alias ruu-aliases-edit='${EDITOR:-nano} ~/develop/github/wsl-env/env/wsl/aliases.sh'
ruu-aliases-edit-project() {
    local f="$HOME/.wsl-project"
    if [ ! -f "$f" ]; then echo "(no project set — run ruu-project-set first)"; return 1; fi
    local dir; dir="$(cat "$f" | tr -d '[:space:]')"
    ${EDITOR:-nano} "$dir/env/wsl/aliases.sh"
}

# ═══════════════════════════════════════════════════════════════════
# Shell Utilities
# ═══════════════════════════════════════════════════════════════════
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ruu-shell-reset='clear && exec $SHELL'

# ═══════════════════════════════════════════════════════════════════
# Java & Tool Versions
# ═══════════════════════════════════════════════════════════════════
alias ruu-java-version='java --version'
alias ruu-maven-version='mvn --version'
alias ruu-docker-version='docker --version && docker compose version'
alias ruu-graalvm-version='echo "GraalVM: $(java --version | head -n1)" && echo "Path: $JAVA_HOME"'
alias ruu-versions='echo "=== Tool Versions ===" && ruu-java-version && echo "" && ruu-maven-version && echo "" && ruu-docker-version'

# ═══════════════════════════════════════════════════════════════════
# IntelliJ IDEA / JetBrains Toolbox (WSL-native via WSLg)
# ═══════════════════════════════════════════════════════════════════
alias ruu-toolbox='_JAVA_AWT_WM_NONREPARENTING=1 jetbrains-toolbox &'
ruu-ij() {
    rm -f /run/user/1000/jb.station.ij.*.sock 2>/dev/null
    DISPLAY=:0 WAYLAND_DISPLAY= XDG_RUNTIME_DIR=/run/user/1000 \
        _JAVA_AWT_WM_NONREPARENTING=1 GDK_BACKEND=x11 \
        nohup /home/r-uu/.local/bin/idea-wsl-fixed "$@" \
        >/tmp/idea-wsl-start.log 2>&1 &
    echo "IntelliJ IDEA gestartet (PID $!)"
}

# ═══════════════════════════════════════════════════════════════════
# Project switching
# ═══════════════════════════════════════════════════════════════════
ruu-project-set() {
    local dir="${1:-}"
    if [ -z "$dir" ]; then
        echo "Usage: ruu-project-set <path-to-project>"
        return 1
    fi
    echo "$dir" > "$HOME/.wsl-project"
    source ~/develop/github/wsl-env/env/wsl/bootstrap.sh
    echo "✅ Active project: $dir"
}
ruu-project-show() {
    local f="$HOME/.wsl-project"
    if [ -f "$f" ]; then
        echo "Active project: $(cat "$f" | tr -d '[:space:]')"
    else
        echo "(no project set — run: ruu-project-set <path>)"
    fi
}

# ═══════════════════════════════════════════════════════════════════
# Help & Documentation
# ═══════════════════════════════════════════════════════════════════
ruu-help() {
    local wsl_env_dir=~/develop/github/wsl-env/env/wsl
    echo "── global (wsl-env) ──────────────────────────────────────────────"
    grep "^alias ruu-" "$wsl_env_dir/aliases.sh" 2>/dev/null \
        | sed 's/alias ruu-/  ruu-/' | sed "s/=.*//" | sort
    local p="$HOME/.wsl-project"
    if [ -f "$p" ]; then
        local d; d="$(cat "$p" | tr -d '[:space:]')"
        local proj_aliases="$d/env/wsl/aliases.sh"
        if [ -f "$proj_aliases" ]; then
            echo ""
            echo "── project: $(basename "$d") ─────────────────────────────────────"
            grep "^alias ruu-" "$proj_aliases" 2>/dev/null \
                | sed 's/alias ruu-/  ruu-/' | sed "s/=.*//" | sort
        fi
    fi
}

ruu-groups() {
    echo ""
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║         ruu-* Alias Groups — global (wsl-env)                 ║"
    echo "  ╠══════════════╦════════════════════════════════════════════════╣"
    echo "  ║ ruu-aliases  ║ Reload / edit aliases (global + project)       ║"
    echo "  ║ ruu-ij       ║ IntelliJ IDEA (start, toolbox)                 ║"
    echo "  ║ ruu-java     ║ Java / GraalVM / Maven versions                ║"
    echo "  ║ ruu-project  ║ Switch active project (set / show)             ║"
    echo "  ║ ruu-shell    ║ Reset shell                                    ║"
    echo "  ║ ruu-versions ║ Show all tool versions                         ║"
    echo "  ╠══════════════╩═════════════╦══════════════════════════════════╣"
    echo "  ║  ruu-help                  ║ list all aliases (global+project)║"
    echo "  ║  ruu-project-show          ║ show active project              ║"
    echo "  ╚════════════════════════════╩══════════════════════════════════╝"
    local p="$HOME/.wsl-project"
    [ -f "$p" ] && echo "  Active project: $(cat "$p" | tr -d '[:space:]')"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════
# Git Compatibility
# ═══════════════════════════════════════════════════════════════════
export GIT_ASKPASS=""
export SSH_ASKPASS=""

echo "✓  wsl-env aliases loaded"
