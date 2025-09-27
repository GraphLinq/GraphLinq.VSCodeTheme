# GraphLinq VS Code Theme - Version Bump Script
# Usage: .\scripts\bump-version.ps1 [patch|minor|major]

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("patch", "minor", "major")]
    [string]$BumpType
)

Write-Host "🔧 Bumping $BumpType version..." -ForegroundColor Cyan

# Read current version from package.json
$packageJson = Get-Content "package.json" | ConvertFrom-Json
$currentVersion = $packageJson.version
Write-Host "Current version: $currentVersion" -ForegroundColor Yellow

# Calculate new version
$versionParts = $currentVersion.Split('.')
$major = [int]$versionParts[0]
$minor = [int]$versionParts[1] 
$patch = [int]$versionParts[2]

switch ($BumpType) {
    "major" { 
        $major++; $minor = 0; $patch = 0 
    }
    "minor" { 
        $minor++; $patch = 0 
    }
    "patch" { 
        $patch++ 
    }
}

$newVersion = "$major.$minor.$patch"
Write-Host "New version: $newVersion" -ForegroundColor Green

# Update package.json
$packageJson.version = $newVersion
$packageJson | ConvertTo-Json -Depth 10 | Set-Content "package.json"

# Update npm script for install-local
$installScript = "code --install-extension graphlinq-vscode-theme-$newVersion.vsix"
$packageJson.scripts.'install-local' = $installScript
$packageJson | ConvertTo-Json -Depth 10 | Set-Content "package.json"

Write-Host "✅ Updated package.json to version $newVersion" -ForegroundColor Green

# Prompt for changelog update
Write-Host "`n📝 Please update CHANGELOG.md with the new version $newVersion" -ForegroundColor Yellow
Write-Host "Opening CHANGELOG.md for editing..." -ForegroundColor Cyan

# Open changelog for editing
if (Get-Command code -ErrorAction SilentlyContinue) {
    code CHANGELOG.md
} else {
    notepad CHANGELOG.md
}

Write-Host "`n🎯 Next steps:" -ForegroundColor Cyan
Write-Host "1. Update CHANGELOG.md with release notes" -ForegroundColor White
Write-Host "2. Run: npm run package" -ForegroundColor White  
Write-Host "3. Run: git add . && git commit -m `"Release v$newVersion`"" -ForegroundColor White
Write-Host "4. Run: git tag v$newVersion" -ForegroundColor White
Write-Host "5. Run: git push origin main --tags" -ForegroundColor White
Write-Host "6. Run: npm run publish (if authenticated)" -ForegroundColor White