# 🎯 Universal Prompt Generator

> Professional command-line tool for generating optimized AI prompts

## Quick Start

```bash
# Navigate to prompt generator
cd prompt-generator

# Generate a prompt
./bin/pg "create a React login component"

# List saved prompts
./bin/pg --list

# Retrieve a saved prompt
./bin/pg --get 1
```

## Features

- **One-command generation**: No menus, no questions - just results
- **Smart AI optimization**: Auto-detects task types (debug, create, test, document)
- **Multi-target support**: Optimized for Claude, Copilot, and universal use
- **Context awareness**: Auto-detects git repo, language stack, working directory
- **Full prompt management**: Save, search, and reuse generated prompts
- **Professional output**: Clean interface with token counting and clipboard integration

## Installation

```bash
# Add to your shell configuration (~/.zshrc or ~/.bashrc)
alias pg="/opt/homebrew/bin/bash /path/to/prompt-generator/bin/pg"

# Reload shell
source ~/.zshrc
```

## Usage Examples

```bash
# Development tasks
pg "fix authentication bug in user.js"
pg "create unit tests for payment API" --target copilot
pg "optimize database queries" --target claude

# Documentation
pg "document the API endpoints"
pg "write README for this project"

# Code review
pg "review security vulnerabilities"
pg "analyze code performance"

# Prompt management
pg --list                    # Show all saved prompts
pg --get "authentication"    # Search for auth-related prompts
pg --get 3                   # Get prompt #3
```

## Project Structure

```
prompt-generator/
├── bin/
│   └── pg                   # Main executable
├── lib/                     # Core functionality (future)
├── data/
│   ├── prompts/            # Generated prompts storage
│   ├── templates/          # Prompt templates
│   ├── examples/           # Usage examples
│   ├── history.log         # Generation history
│   └── index.json          # Search index
├── docs/                   # Documentation
├── tests/                  # Test files
├── config/                 # Configuration
└── README.md              # This file
```

## Storage Locations

- **Generated prompts**: `data/prompts/`
- **Search index**: `data/index.json`
- **History log**: `data/history.log`
- **Templates**: `data/templates/`

All data is stored within the project directory - no scattered files.

## Development

See `docs/` directory for detailed documentation and `tests/` for testing utilities.