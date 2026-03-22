# 📍 Prompt Storage Locations

## Professional Structure

All prompts and data are now organized in a **single, professional directory**:

```
📁 /Users/arog/Library/Mobile Documents/com~apple~CloudDocs/AROG/2026-03-22/claude-framework/claude-framework/prompt-generator/

├── 🎯 bin/pg                          # Main executable
├── 📊 data/
│   ├── 📝 prompts/                    # YOUR GENERATED PROMPTS
│   │   ├── 20260322_150314_create_a_simple_todo_app.prompt
│   │   ├── 20260322_150331_debug_API_timeout_issue.prompt
│   │   └── 20260322_151202_create_a_professional_navbar_c.prompt
│   ├── 🔍 index.json                  # Search index
│   ├── 📜 history.log                 # Generation history
│   ├── 📖 examples/                   # Sample prompts
│   └── 🎨 templates/                  # Prompt templates
├── ⚙️  config/settings.json           # Configuration
├── 📚 docs/                           # Documentation
└── 📖 README.md                       # Getting started guide
```

## Key Benefits

✅ **Single location**: Everything in one organized directory
✅ **No scattered files**: No more ~/.prompt-vault or random files
✅ **Professional structure**: Industry-standard project layout
✅ **Version control ready**: Can be committed to git as a project
✅ **Portable**: Easy to backup, share, or move
✅ **Self-contained**: All dependencies and data in one place

## Usage Examples

```bash
# Navigate to project
cd prompt-generator

# Generate prompt (saves automatically)
./bin/pg "create authentication middleware"

# List all saved prompts
./bin/pg --list

# Find specific prompts
./bin/pg --get "authentication"

# Use global alias (after shell reload)
source ~/.zshrc
pg "debug memory leak issue"
```

## Prompt Files

Each generated prompt is saved as:
- **Filename format**: `YYYYMMDD_HHMMSS_task_description.prompt`
- **Content includes**: Task, target AI, generation timestamp, character count, full prompt
- **Location**: `data/prompts/`
- **Searchable**: Via index for fast retrieval