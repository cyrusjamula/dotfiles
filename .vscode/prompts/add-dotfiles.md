# Add New Dotfiles Configuration

You are helping a user add a new configuration type to their cross-platform dotfiles repository. The repository structure follows this pattern:

## Current Repository Structure:
```
dotfiles/
├── git/                    # Git configuration
│   ├── .gitconfig         # Configuration file
│   ├── install.sh         # Linux/macOS/WSL installer
│   ├── install.ps1        # Windows PowerShell installer
│   └── README.md          # Documentation
├── install.sh             # Main installer (bash)
├── install.ps1            # Main installer (PowerShell)
└── README.md              # Main documentation
```

## Task: Add New Configuration Type

When the user asks to add a new dotfile configuration (e.g., shell, vim, tmux, etc.):

### 1. Create Directory Structure
- Create a new directory named after the configuration type
- Add the configuration files (dotfiles) to this directory

### 2. Create Cross-Platform Installers
- `install.sh` - Bash script for Linux/macOS/WSL
- `install.ps1` - PowerShell script for Windows

### 3. Installer Requirements
Both installers should:
- Backup existing configuration files before installation
- Create symbolic links (preferred) or copy files (fallback)
- Provide clear user feedback about what's happening
- Handle errors gracefully
- Follow the same pattern as the git installers

### 4. Documentation
Create a `README.md` in the new directory with:
- Description of the configuration
- List of files included
- Installation instructions for each platform
- Configuration highlights/features
- Manual installation instructions
- Platform-specific notes

### 5. Update Main Files
- Update main `install.sh` to include the new configuration
- Update main `install.ps1` to include the new configuration  
- Update main `README.md` to document the new configuration type

### 6. Commit Changes
Create a commit with:
- Conventional commit format: `feat: Add [configuration-type] dotfiles`
- Comprehensive description of what was added
- List of key features and benefits

## Example Commands to Use:
- Check existing config: `[tool] --version` or `[tool] config --list`
- Create directories: Use create_directory tool
- Create files: Use create_file tool
- Make scripts executable: `chmod +x filename.sh`
- Update existing files: Use replace_string_in_file or insert_edit_into_file
- Stage and commit: `git add -A && git commit -m "message"`

## Best Practices:
- Follow the existing naming conventions
- Keep installers simple and robust
- Provide fallback options for different environments
- Include comprehensive documentation
- Test cross-platform compatibility
- Use meaningful git commit messages
