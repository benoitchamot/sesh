# About Sesh
Sesh creates a session in tmux with a nice little environment:
- a terminal in the left pane
- Neovim in the right pane

## How to use Sesh
```bash
sesh [project]
```

- If `sesh` is run without argument, it opens `fzf` to list the files in the base directory.
- If an argument is passed, `sesh` attach to a session with the name passed in the argument, which is located in the base directory.
- The session name is always `dev_` + project.
- If a session with this name already exists, we just attach to it
- If the project doesn't exist, `sesh` creates a directory

## What is `deploy.sh`
I'm lazy, so I have a script to copy `sesh` to `/usr/local/bin` when I update it.

## Dependencies
- `nvim`
- `fzf`
- `tmux` (duh)

I use bash, I have no idea whether `sesh` works with other shells. To be sure, the shabang has been changed.

## What is missing?
- There's some code in there to activate a venv if `.venv/` exists, but it doesn't seem to work
- `sesh` doesn't work if I'm already in tmux, that should be handled
- We could have some options to handle the base directory definition, for instance with a config file
- Error handling is poor. The base directory must exist, it must contain at least one project and the dependencies must all be there

