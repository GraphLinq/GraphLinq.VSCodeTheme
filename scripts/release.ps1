# GraphLinq VS Code Theme - Release Script
# Automated release workflow

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("patch", "minor", "major")]
    [string]$BumpType,
    
    [switch]$SkipPublish
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting release workflow for $BumpType version..." -ForegroundColor Green

# Step 1: Bump version
Write-Host "`n1️⃣ Bumping version..." -ForegroundColor Cyan
& ".\scripts\bump-version.ps1" $BumpType

# Wait for user to update changelog
Read-Host "`n⏸️  Press Enter after updating CHANGELOG.md to continue"

# Step 2: Package extension  
Write-Host "`n2️⃣ Packaging extension..." -ForegroundColor Cyan
npm run package

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Packaging failed"
    exit 1
}

# Step 3: Get new version for commit
$packageJson = Get-Content "package.json" | ConvertFrom-Json
$newVersion = $packageJson.version

# Step 4: Git operations
Write-Host "`n3️⃣ Committing changes..." -ForegroundColor Cyan
git add .
git commit -m "Release v$newVersion"

Write-Host "`n4️⃣ Creating git tag..." -ForegroundColor Cyan
git tag "v$newVersion"

Write-Host "`n5️⃣ Pushing to GitHub..." -ForegroundColor Cyan
git push origin main --tags

# Step 6: Publish (optional)
if (-not $SkipPublish) {
    Write-Host "`n6️⃣ Publishing to marketplace..." -ForegroundColor Cyan
    npm run publish
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Successfully published v$newVersion to VS Code marketplace!" -ForegroundColor Green
    } else {
        Write-Warning "⚠️  Publishing failed. You may need to authenticate first."
        Write-Host "Run: npx @vscode/vsce login GraphLinq" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n⏭️  Skipping marketplace publish (use --SkipPublish $false to publish)" -ForegroundColor Yellow
}

Write-Host "`n🎉 Release workflow completed for v$newVersion!" -ForegroundColor Green