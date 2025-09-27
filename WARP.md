# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Visual Studio Code theme extension for GraphLinq Chain, a no-code blockchain platform. The theme provides a dark color scheme based on GraphLinq's brand colors and is published to the VS Code marketplace.

## Architecture

The project follows the standard VS Code extension structure:
- **`package.json`**: Extension manifest defining metadata, theme contribution point, and dependencies
- **`themes/dark.json`**: Complete theme definition with UI colors and syntax highlighting tokens
- **`.vscode/launch.json`**: VS Code debug configuration for extension development
- **`.vscodeignore`**: Files excluded from the extension package

### Theme Structure

The `themes/dark.json` file contains two main sections:
- **`colors`**: UI theme colors (462 color definitions covering editor, sidebar, terminal, debug console, etc.)
- **`tokenColors`**: Syntax highlighting rules for different code elements (comments, keywords, strings, etc.)

### Key Brand Colors
- Primary purple: `#5029e5`
- Accent pink: `#ff007a`, `#ff286f`
- Background dark: `#131026`, `#1c1836`  
- Foreground light: `#ece7fd`, `#ede8fd`
- Secondary purple: `#685b93`, `#8833de`
- Highlight yellow: `#fdfe54`
- Success green: `#05f24f`
- Blue accents: `#008aff`, `#3a49d0`

## Development Commands

### Package Extension
```powershell
npm run package
```
Creates a `.vsix` file for distribution.

### Install Locally for Testing
```powershell
npm run install-local
# or
npm run test-local  # packages and installs in one command
```

### Debug Extension
Use F5 or Run > Start Debugging to launch Extension Development Host with the theme loaded.

### Version Management
```powershell
# Bump patch version (0.1.1 -> 0.1.2)
npm run version:patch

# Bump minor version (0.1.1 -> 0.2.0)
npm run version:minor

# Bump major version (0.1.1 -> 1.0.0)
npm run version:major
```

### Release Workflow
```powershell
# Complete release with publishing
npm run release:patch
npm run release:minor
npm run release:major

# Release without publishing (for testing)
powershell -ExecutionPolicy Bypass -File ./scripts/release.ps1 patch -SkipPublish
```

### Manual Publishing
```powershell
# Setup publisher authentication (one-time)
npx @vscode/vsce login GraphLinq

# Publish current version
npm run publish
```

## Theme Development Workflow

1. **Modify theme**: Edit color values in `themes/dark.json`
2. **Test changes**: Use F5 to launch debug instance or reload VS Code window if already installed
3. **Update version**: Increment version in `package.json` following semantic versioning
4. **Document changes**: Add entry to `CHANGELOG.md` following Keep a Changelog format
5. **Package and test**: Create `.vsix` package and test installation
6. **Publish**: Use vsce to publish to marketplace

## Color Scheme Consistency

When modifying colors, maintain consistency with GraphLinq brand:
- Use existing palette defined in the theme
- Ensure sufficient contrast for accessibility
- Test with multiple programming languages to verify syntax highlighting
- Verify UI elements maintain visual hierarchy

## Marketplace Publishing Setup

### Prerequisites
1. **Microsoft Account**: Sign up at [Visual Studio Marketplace](https://marketplace.visualstudio.com/manage)
2. **Azure DevOps**: Create organization if needed
3. **Publisher Account**: Create publisher "GraphLinq" if not exists
4. **Personal Access Token**: Generate with Marketplace (publish) scope

### Authentication Setup
```powershell
# Login to marketplace (one-time setup)
npx @vscode/vsce login GraphLinq

# Verify authentication
npx @vscode/vsce verify-pat GraphLinq

# List authenticated publishers
npx @vscode/vsce ls-publishers
```

### Publishing States
- ✅ **Ready**: Publisher authenticated, can use `npm run publish`
- ⚠️ **Needs Auth**: Run `npx @vscode/vsce login GraphLinq` first
- ❌ **No Publisher**: Create publisher account at VS Code marketplace

## File Modifications

- **Theme colors**: Only modify `themes/dark.json`
- **Metadata changes**: Update `package.json` for version, description, or contribution changes
- **Documentation**: Update `README.md` for user-facing changes, `CHANGELOG.md` for version history
- **Version bumps**: Use `npm run version:*` scripts to handle version changes automatically
