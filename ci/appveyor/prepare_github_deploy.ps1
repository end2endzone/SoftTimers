#Script for preparing for GitHub deploy.

#For prerelease branches:
#  Every commits to a prerelease branch is tagged and binaries are deployed to GitHub.
#For non-prerelease branches:
#  Each other branches (including master) are build after each commits.
#  One version of the latest binaries is kept per branch (allow 1 public nightly build per branch)
#  A dummy tag is created named: nightly-$(BRANCH_NAME). This seems to be required by GitHub.

$ScriptName = $MyInvocation.MyCommand.Name
Write-Output "Running $ScriptName..."
Write-Output "Current branch: $env:APPVEYOR_REPO_BRANCH"
Write-Output "Current build version: $env:APPVEYOR_BUILD_VERSION"
If ("$env:APPVEYOR_REPO_BRANCH".contains("prerelease")) {
  Write-Output "Tagging each commits with a unique version..."
  Write-Output "Deploying each commits to GitHub..."

  $env:GITHUB_TAG_NAME="v$env:PRODUCT_VERSION"
  $env:GITHUB_RELEASE_NAME="$env:APPVEYOR_PROJECT_NAME-v$env:PRODUCT_VERSION"
}
Else
{
  Write-Output "Tagging current build as a nightly build..."

  # allow 1 public nightly build per branch
  $env:GITHUB_TAG_NAME="nightly-$env:APPVEYOR_REPO_BRANCH"
  $env:GITHUB_RELEASE_NAME="Nightly build (branch $env:APPVEYOR_REPO_BRANCH)"
}

#Show final values...
Write-Output "GITHUB_TAG_NAME=$env:GITHUB_TAG_NAME"
Write-Output "GITHUB_RELEASE_NAME=$env:GITHUB_RELEASE_NAME"
