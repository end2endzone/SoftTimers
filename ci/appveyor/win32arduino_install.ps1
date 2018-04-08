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
$name = "win32Arduino"
Write-Output "Installing $name package..."

# Run install_github_package.ps1 script.
$argumentList = "-name $name -installpath $third_party -url `"http://codeload.github.com/end2endzone/win32Arduino/zip/v2.0.0.37`""
Invoke-Expression "& `"$parentdir\install_github_package.ps1`" $argumentList"

# Copy installation environment variable 
$env:WIN32ARDUINO_HOME = $env:INSTALL_HOME

# Run run_cmake.ps1 script.
$build = "$env:WIN32ARDUINO_HOME\cmake\build"
$sources = "$env:WIN32ARDUINO_HOME\src"
Invoke-Expression "& `"$parentdir\run_cmake.ps1`" -build `"$build`" -src `"$sources`""

Write-Output "done."
Write-Output ""
