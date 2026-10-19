# Luis Vieira's DotFiles

## Setup:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lvieirajr/dotfiles/main/setup.sh)"
```

## pstack

After Homebrew installs Claude Code and Codex and Mise installs the development
tools, `setup.sh` installs pstack from `lvieirajr/pstack-claude` using the native
plugin commands:

```sh
claude plugin marketplace add lvieirajr/pstack-claude
claude plugin install pstack@pstack-claude
codex plugin marketplace add lvieirajr/pstack-claude
codex plugin add pstack@pstack-claude
```

Each harness manages its plugin files and configuration. Run `setup-pstack` in
each harness to configure models, and trust Codex's plugin hook through `/hooks`
when prompted. The shared `~/.agents` instructions and unrelated skills remain
separate from this installation; no pstack bundle or configuration is copied there.

The fork stays on inherited version `0.9.93` during development and will introduce
its own version at the first ready release. New commits at the same version do
not establish a native automatic update; versioned updates will be verified for
that release. Dotfiles installation does not run model-backed workflows.
