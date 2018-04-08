############################################
# Find third_party folder
############################################
function Get-AbsolutePath ($Path)
{
  # From https://stackoverflow.com/a/16964490
  # System.IO.Path.Combine has two properties making it necesarry here:
  #   1) correctly deals with situations where $Path (the second term) is an absolute path
  #   2) correctly deals with situations where $Path (the second term) is relative
  # (join-path) commandlet does not have this first property
  $Path = [System.IO.Path]::Combine( ((pwd).Path), ($Path) );

  # this piece strips out any relative path modifiers like '..' and '.'
  $Path = [System.IO.Path]::GetFullPath($Path);

  return $Path;
}
$parentdir = Split-Path -Path $MyInvocation.MyCommand.Path
$third_party = Get-AbsolutePath -Path "$parentdir\..\..\third_party"

############################################
# Install github package.
############################################
$name = "googletest"
Write-Output "Installing $name package..."

# Run install_github_package.ps1 script.
$argumentList = "-name $name -installpath $third_party -url `"http://codeload.github.com/google/googletest/zip/release-1.6.0`""
Invoke-Expression "& `"$parentdir\install_github_package.ps1`" $argumentList"

# Copy installation environment variable 
$env:GOOGLETEST_HOME = $env:INSTALL_HOME
$build = "$env:GOOGLETEST_HOME\build"

# Run run_cmake.ps1 script.
$argumentList = "-build `"$build`" -src `"$env:GOOGLETEST_HOME`""
Invoke-Expression "& `"$parentdir\run_cmake.ps1`" $argumentList"

Write-Output "done."
Write-Output ""
