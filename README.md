# Utility Scripts

Utility Scripts is a small collection of shell scripts and shell configuration files for setting up a Git and GitHub workflow quickly on a new machine. The repository is organized by operating system and focuses on common developer setup tasks such as creating SSH keys, creating GPG signing keys, configuring global Git settings, syncing a local project to GitHub, and bootstrapping a productive shell and editor environment.

The goal is to make repeatable setup easier: instead of remembering every command, you can run the script for the task you need and follow the prompts.

## What This Repository Helps With

- Configure your global Git identity and preferred editor.
- Generate an SSH key and add it to GitHub for passwordless Git operations.
- Generate a GPG key and configure Git to sign commits.
- Copy public SSH/GPG keys to your clipboard when a clipboard tool is available.
- Open the relevant GitHub settings page so you can paste the generated key.
- Sync a local directory to a GitHub repository from the command line.
- Reuse a Linux Zsh configuration with Oh My Zsh, Powerlevel10k, common aliases, clipboard helpers, and lazy NVM loading.
- Reuse a Linux Vim configuration with modern editing defaults, persistent undo, safe backup locations, and practical key mappings.

## Repository Structure

```text
.
├── Linux/
│   ├── generate_gpg_key.sh    # Generate a Linux GPG key and enable Git commit signing
│   ├── generate_ssh_key.sh    # Generate a Linux SSH key and test GitHub SSH access
│   ├── vimrc                  # Linux Vim configuration for software development
│   └── zshrc                  # Linux Zsh configuration for Oh My Zsh and developer aliases
├── Mac/
│   ├── generate_gpg_key.sh    # Generate a macOS GPG key and enable Git commit signing
│   ├── generate_ssh_key.sh    # Generate a macOS SSH key and test GitHub SSH access
│   ├── setup_git_config.sh    # Configure global Git name, email, editor, and signing options
│   └── sync-to-github.sh      # Initialize/sync a local project with a GitHub repository
├── LICENSE
└── README.md
```

## Prerequisites

Before running the scripts, make sure the basic command-line tools are installed.

### Required for Most Scripts

- Bash
- Git
- A GitHub account
- Terminal access on macOS or Linux

### Required for SSH Scripts

- OpenSSH tools: `ssh-keygen`, `ssh-agent`, and `ssh-add`

### Required for GPG Scripts

- GnuPG: `gpg`
- A global Git name and email configured before generating a GPG key

You can set your Git identity manually with:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### Optional Clipboard Tools

The scripts try to copy generated public keys automatically:

- macOS: `pbcopy`
- Linux X11: `xclip`
- Linux Wayland: `wl-copy`

If no clipboard tool is available, the scripts print the public key in the terminal so you can copy it manually.

### Optional for `Linux/zshrc`

- Zsh
- Oh My Zsh installed at `~/.oh-my-zsh`
- Powerlevel10k installed as an Oh My Zsh theme
- `zsh-autosuggestions` and `zsh-syntax-highlighting` installed as Oh My Zsh plugins
- `xclip` for `pbcopy` and `pbpaste` compatibility aliases on Linux
- NVM installed at `~/.nvm` if you want the lazy-loaded `node`, `npm`, `npx`, and `nvm` functions

### Optional for `Linux/vimrc`

- Vim with clipboard support if you want OS clipboard integration
- A terminal that supports mouse input if you want mouse mode
- Writable Vim state directories for persistent undo, backups, and swap files

Create the state directories once before using the config:

```bash
mkdir -p ~/.vim/{undo,backup,swap}
```

## Getting Started

Clone the repository:

```bash
git clone https://github.com/SleepLove111/utility-scripts.git
cd utility-scripts
```

Make a script executable before running it:

```bash
chmod +x Mac/generate_ssh_key.sh
```

Run it:

```bash
./Mac/generate_ssh_key.sh
```

Use the matching folder for your operating system:

```bash
./Mac/<script-name>.sh
./Linux/<script-name>.sh
```

## Script Guide

### `Mac/setup_git_config.sh`

Use this first on a new macOS machine if Git is not configured yet.

It asks for:

- Your full name
- Your email address
- Your preferred Git editor
- Whether you want to enable GPG commit signing

It configures:

```bash
git config --global user.name
git config --global user.email
git config --global core.editor
git config --global color.ui auto
git config --global init.defaultBranch main
```

Run it with:

```bash
chmod +x Mac/setup_git_config.sh
./Mac/setup_git_config.sh
```

### `Mac/generate_ssh_key.sh`

Use this to create an SSH key for GitHub on macOS.

It will:

- Generate an SSH key at `~/.ssh/id_rsa`.
- Use your Git email as the key comment when available.
- Ask before overwriting an existing key.
- Let you choose whether to protect the key with a passphrase.
- Start `ssh-agent` and add the new key.
- Copy the public key to the clipboard when possible.
- Open GitHub's new SSH key page.
- Test the SSH connection to GitHub.

Run it with:

```bash
chmod +x Mac/generate_ssh_key.sh
./Mac/generate_ssh_key.sh
```

### `Linux/generate_ssh_key.sh`

Use this to create an SSH key for GitHub on Linux.

It will:

- Generate an SSH key at `~/.ssh/id_ed25519`.
- Create `~/.ssh` if needed and set safe permissions.
- Ask before overwriting an existing key.
- Let you choose whether to protect the key with a passphrase.
- Start `ssh-agent` and add the new key.
- Copy the public key to the clipboard when possible.
- Open GitHub's new SSH key page when a browser opener is available.
- Test the SSH connection to GitHub.

Run it with:

```bash
chmod +x Linux/generate_ssh_key.sh
./Linux/generate_ssh_key.sh
```

### `Mac/generate_gpg_key.sh`

Use this to create a GPG key for signing Git commits on macOS.

It will:

- Read your Git name and email from global Git config.
- Generate a 4096-bit RSA GPG key.
- Configure Git to sign commits with the new key.
- Copy the public GPG key to the clipboard when possible.
- Open GitHub's SSH and GPG keys settings page.
- Optionally revoke and delete older GPG keys for the same email.

Run it with:

```bash
chmod +x Mac/generate_gpg_key.sh
./Mac/generate_gpg_key.sh
```

### `Linux/generate_gpg_key.sh`

Use this to create a GPG key for signing Git commits on Linux.

It will:

- Read your Git name and email from global Git config.
- Generate a 4096-bit RSA GPG key.
- Configure Git to sign commits with the new key.
- Copy the public GPG key to the clipboard when possible.
- Open GitHub's SSH and GPG keys settings page when a browser opener is available.
- Print the generated key ID for reference.

Run it with:

```bash
chmod +x Linux/generate_gpg_key.sh
./Linux/generate_gpg_key.sh
```

### `Linux/zshrc`

Use this as a reusable Linux `~/.zshrc` configuration for a developer-focused Zsh environment.

It includes:

- Powerlevel10k instant prompt support.
- Oh My Zsh configured with the Powerlevel10k theme.
- `git`, `zsh-autosuggestions`, and `zsh-syntax-highlighting` plugins.
- `vim` as the default `EDITOR` and `VISUAL`.
- Linux clipboard aliases for `pbcopy` and `pbpaste` when `xclip` is installed.
- Common system, Git, file, directory, and utility aliases.
- Safer interactive aliases for `rm`, `cp`, and `mv`.
- A helper function for switching a Linux desktop setup to LightDM.
- Custom `LS_COLORS`.
- Lazy loading for NVM commands so shell startup stays faster.
- Optional Powerlevel10k user config loading from `~/.p10k.zsh`.

Install it by backing up your current config and copying this file:

```bash
cp ~/.zshrc ~/.zshrc.backup
cp Linux/zshrc ~/.zshrc
source ~/.zshrc
```

Review the file before copying it if you already have custom aliases, PATH changes, plugins, or shell initialization logic.

### `Linux/vimrc`

Use this as a reusable Linux `~/.vimrc` configuration for fast, practical software development in Vim.

It includes:

- Modern Vim behavior with `nocompatible`, filetype detection, syntax highlighting, and UTF-8 support.
- `,` as the leader key for common commands.
- Absolute and relative line numbers for easier navigation.
- Cursor line, matching bracket, ruler, command, and always-on status line display.
- Dark-background styling with the `retrobox` colorscheme.
- Consistent 4-space indentation with spaces instead of tab characters.
- Highlighted, incremental, smart-case search.
- Double `Esc` to clear search highlighting.
- Hidden buffers, larger command history, modern backspace behavior, and improved command-line completion.
- Mouse support and OS clipboard integration when Vim has clipboard support.
- Persistent undo, backup files, swap files, and write backups stored under `~/.vim`.
- Terminal performance settings for smoother redraws and faster mapped key handling.
- Leader shortcuts for save, quit, save-and-quit, editing `~/.vimrc`, and reloading the config.
- `Ctrl+h`, `Ctrl+j`, `Ctrl+k`, and `Ctrl+l` split navigation.

Install it by creating the required directories, backing up your current config, and copying this file:

```bash
mkdir -p ~/.vim/{undo,backup,swap}
[ -f ~/.vimrc ] && cp ~/.vimrc ~/.vimrc.backup
cp Linux/vimrc ~/.vimrc
```

Review the file before copying it if you already have custom mappings, indentation rules, colorscheme settings, or plugin configuration.

### `Mac/sync-to-github.sh`

Use this to initialize a local folder and push it to a GitHub repository.

Usage:

```bash
./Mac/sync-to-github.sh <github_repo_url> [commit_message] [target_directory]
```

Example:

```bash
chmod +x Mac/sync-to-github.sh
./Mac/sync-to-github.sh git@github.com:your-username/my-project.git "Initial commit" my-project
```

Arguments:

- `<github_repo_url>`: Required. The GitHub repository URL to push to.
- `[commit_message]`: Optional. Defaults to `Initial commit or update from script`.
- `[target_directory]`: Optional. Defaults to the repository name from the URL.

The script will:

- Create the target directory if it does not exist.
- Initialize a Git repository.
- Add the GitHub remote as `origin`.
- Try to pull from `main` using `--allow-unrelated-histories`.
- Add all files.
- Create a commit.
- Rename the current branch to `main`.
- Push to GitHub.

## Recommended Setup Order

For a new machine, a good order is:

1. Configure Git identity.
2. Generate and add an SSH key to GitHub.
3. Generate and add a GPG key to GitHub if you want signed commits.
4. Test cloning or pushing with SSH.

On macOS:

```bash
./Mac/setup_git_config.sh
./Mac/generate_ssh_key.sh
./Mac/generate_gpg_key.sh
```

On Linux:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
./Linux/generate_ssh_key.sh
./Linux/generate_gpg_key.sh
# Optional: review and install the shared Zsh config
cp Linux/zshrc ~/.zshrc
# Optional: review and install the shared Vim config
mkdir -p ~/.vim/{undo,backup,swap}
cp Linux/vimrc ~/.vimrc
```

## Safety Notes

- Read each prompt carefully before confirming.
- The SSH scripts ask before overwriting an existing SSH key.
- The macOS GPG script can revoke and delete older GPG keys for the same email if you approve it. Only choose that option if you are sure.
- GPG keys generated by these scripts use no passphrase protection. If you need stronger local key protection, review and modify the script before running it.
- The sync script runs `git add .`, so check the target directory before using it to avoid committing files you did not intend to publish.
- Back up your existing `~/.zshrc` before replacing it with `Linux/zshrc`; it may overwrite personal aliases, PATH entries, or plugin settings.
- Back up your existing `~/.vimrc` before replacing it with `Linux/vimrc`; it may overwrite personal mappings, indentation rules, colorscheme choices, or plugin settings.

## Troubleshooting

### `gpg: command not found`

Install GnuPG, then run the script again.

### `ssh-keygen: command not found`

Install OpenSSH tools for your operating system.

### SSH test fails after adding the key to GitHub

Try:

```bash
ssh -vT git@github.com
```

This prints detailed connection information that can help identify whether the wrong key is being used or the key was not added to GitHub correctly.

### GitHub does not show verified commits

Make sure:

- The GPG public key was added to GitHub.
- The GPG key email matches a verified email on your GitHub account.
- Git is configured with `commit.gpgsign true`.
- Your commit was created after GPG signing was configured.

Check your current signing config:

```bash
git config --global user.signingkey
git config --global commit.gpgsign
git config --global gpg.format
```

## Contributing

Contributions are welcome.

If you add a new script or configuration file:

1. Put it in the correct platform folder.
2. Use a clear, descriptive filename.
3. Add prompts or comments for anything that changes user settings.
4. Update this README with what the script does and how to run it.
5. Test the script on the target operating system before opening a pull request.

## License

This repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.
