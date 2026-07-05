# fzf + bat setup

## Binaries
- Download bianry from github
- `~/tool/bin/fzf` (0.73.1)
- `~/tool/bin/bat` (0.26.1)
- Both on PATH via `~/.bashrc`: `export PATH="$HOME/.local/bin:$HOME/tool/bin:$PATH"`

## Shell integration
- `~/.fzf.bash` runs `eval "$("$HOME/tool/bin/fzf" --bash)"` — this is what wires up the
  Ctrl-T / Ctrl-R keybindings and completion. Without it, env vars like `FZF_CTRL_T_OPTS`
  do nothing since the widgets themselves don't exist.
- Sourced from `~/.bashrc`: `[ -f "$HOME/.fzf.bash" ] && . "$HOME/.fzf.bash"`

## bat preview
- `~/.bashrc` sets:
  ```bash
  export FZF_DEFAULT_OPTS="--preview '$HOME/tool/bin/bat --color=always --style=numbers {}' --bind 'page-up:preview-page-up,page-down:preview-page-down'"
  ```
- `FZF_DEFAULT_OPTS` applies to plain `fzf` invocations (e.g. `find . | fzf`).
- `FZF_CTRL_T_OPTS` would be needed too if the Ctrl-T widget should have its own preview
  config separately (currently not set — Ctrl-T falls back to `FZF_DEFAULT_OPTS`).
- `--color=always` is required or bat drops ANSI colors when piped.
- Page Up / Page Down scroll the preview pane via the `--bind` clause above.

## Gotchas hit during setup
- `~/.bashrc` returns early for non-interactive shells (`[ -z "$PS1" ] && return` near the
  top) — env vars set below that line won't show up when testing from scripts/tools, only
  in a real interactive terminal.
- Setting `FZF_CTRL_T_OPTS` alone does not enable the Ctrl-T keybinding — the shell
  integration script (`~/.fzf.bash`) must be sourced too.
