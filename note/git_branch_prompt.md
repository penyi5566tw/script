# Prompt: show git branch

## Where
`~/.bashrc`, lines ~52-58.

## Function
```bash
parse_git_branch() {
    git branch --show-current 2>/dev/null | sed -e 's/\(.*\)/ (\1)/'
}
```
- `git branch --show-current` prints the current branch name, empty if not in a repo or
  in detached HEAD.
- `2>/dev/null` swallows the "not a git repository" error so it stays silent outside repos.
- The `sed` wraps a non-empty result in a leading space + parens, e.g. `main` -> ` (main)`.
  If there's no branch, the sed pattern still runs on an empty line but produces no output
  because there's no input line to match (empty stdin -> empty stdout).

## Wiring into PS1
```bash
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\$ '
```
- `$(parse_git_branch)` is embedded directly in the PS1 string (single-quoted so it's
  evaluated fresh on every prompt draw, not just once at shell startup).
- Wrapped in `\[\033[01;33m\] ... \[\033[00m\]` so the branch shows in yellow, matching the
  color scheme already used for user@host (green) and cwd (blue).
- There's a non-color fallback `PS1` (no branch coloring escapes) used when
  `color_prompt` isn't set, still calling the same `parse_git_branch` function.

## Gotcha
- This runs `git branch --show-current` on every single prompt render. In a huge repo or
  on a slow filesystem this adds latency to every command. Not an issue for normal repos.
- Only shows the branch name — no dirty/staged indicator. Add `git status --porcelain`
  checks to `parse_git_branch` if that's wanted later.
