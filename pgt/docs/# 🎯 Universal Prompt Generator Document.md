# 🎯 Universal Prompt Generator Documentation

## Clear Explanation

The Universal Prompt Generator (`pg.sh`) is a professional command-line tool that instantly creates optimized prompts for AI tools like Claude, GitHub Copilot, and others. Instead of manually crafting prompts or dealing with complex interactive interfaces, you simply describe your task in natural language and get a perfectly structured, context-aware prompt ready to paste into any AI tool.

### Key Features
- **One-command operation**: No questions, no menus - just instant results
- **Smart task detection**: Automatically optimizes prompts based on task type (debugging, creation, testing, documentation, etc.)
- **Context awareness**: Auto-detects your git repository, programming language, and current directory
- **Multi-target support**: Generates different formats optimized for Claude, Copilot, or universal use
- **Professional output**: Clean, colorized interface with token counting and clipboard integration

## Code Examples

### Basic Usage
```bash
# Generate a prompt for Claude (default)
pg "create a React login component"

# Generate for GitHub Copilot
pg "fix authentication bug in user.js" --target copilot

# Generate universal format (works with any AI)
pg "write unit tests for payment API" --target universal
```

### Advanced Examples
```bash
# Documentation task
pg "document the database schema"

# Code review task  
pg "review the security of this authentication system"

# Debugging task
pg "debug memory leak in Node.js application"

# Testing task
pg "create comprehensive tests for user registration flow"
```

### Checking History and Help
```bash
# View recent prompts
pg --history

# Get help and see all options
pg --help
```

### Sample Output
When you run `pg "create a login form"`, you get:
```xml
<task>create a login form</task>

<persona>You are a senior software architect with expertise in modern development practices and clean code principles.</persona>

<context>
Repository: my-project, Branch: main
Current working directory: /Users/user/projects/my-app
</context>

<constraints>
- Write production-ready, maintainable code
- Follow best practices and patterns
- Include proper error handling
- Add clear documentation
Mark [UNCERTAIN] if you need clarification.
</constraints>

<output-format>
1. Working code with explanations 2. Usage examples 3. Testing approach
Provide working, tested solutions.
</output-format>
```

## Usage Scenarios

### 1. Daily Development Workflow
```bash
# Morning standup prep
pg "create status update for sprint progress"

# Feature development
pg "implement user authentication with JWT tokens"

# Code maintenance  
pg "refactor legacy payment processing code"

# End of day documentation
pg "document today's API changes"
```

### 2. Debugging Sessions
```bash
# Production issues
pg "debug 500 error in checkout process"

# Performance problems
pg "analyze slow database queries in user dashboard"

# Integration issues
pg "troubleshoot third-party API connection failures"
```

### 3. Code Quality Tasks
```bash
# Code reviews
pg "review pull request for security vulnerabilities"

# Testing
pg "create integration tests for order management system"

# Documentation
pg "write comprehensive README for new microservice"
```

### 4. Learning and Research
```bash
# Technology research
pg "compare React state management solutions"

# Best practices
pg "explain clean code principles for JavaScript"

# Architecture decisions
pg "design scalable architecture for chat application"
```

### 5. Different AI Tool Optimization

**For Claude (XML format):**
```bash
pg "optimize React component performance" --target claude
# Generates structured XML with thinking tags
```

**For GitHub Copilot (natural language):**
```bash
pg "create user profile component" --target copilot  
# Generates markdown format optimized for Copilot
```

**For Universal use:**
```bash
pg "explain database indexing strategies" --target universal
# Generates clean markdown that works with any AI tool
```

### 6. Context-Aware Intelligence

The tool automatically detects and optimizes based on:

- **Git context**: Includes repository name, current branch
- **Programming language**: Detects from files (package.json, requirements.txt, etc.)
- **Task type**: Debugging vs creation vs testing vs documentation
- **Working directory**: Provides current path context

### 7. Professional Output Features

- **Token counting**: Shows estimated cost (~200 tokens average)
- **Auto-clipboard**: Instantly ready to paste
- **History tracking**: Access previous prompts with `pg --history`
- **Clean UI**: Professional colorized output
- **Error handling**: Clear messages for invalid usage

### 8. Integration with Development Workflow

```bash
# Before opening Claude Code
pg "fix race condition in webhook handler" --target claude-code

# Before using GitHub Copilot
pg "implement data validation layer" --target copilot

# Before consulting any AI tool
pg "explain microservices communication patterns" --target universal
```

This tool transforms the prompt creation process from a manual, time-consuming task into a single command that generates professional, optimized prompts tailored to your specific context and needs.