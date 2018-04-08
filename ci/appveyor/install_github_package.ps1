Param(
  [Parameter(Mandatory=$True)]
  [string]$name,
  [Parameter(Mandatory=$True)]
  [string]$installpath,
  [Parameter(Mandatory=$True)]
  [string]$url
)

############################################
# Create installation directory
############################################
$command_output = New-Item -ItemType Directory -Force -Path $installpath

############################################
# Delete previous installations
############################################
Write-Host "Deleting previous $name installations..."
function DeleteIfExists($path)
{
  if ( Test-Path $path -PathType Container )
  {
    $command_output = Remove-Item –Path "$path" –recurse
  }
}
DeleteIfExists -Path "$installpath\$name"

############################################
# Download
############################################
$tempfile = "$env:temp\$name.tmp.zip"
Write-Host "Downloading $name zip archive from '$url' to file '$tempfile'..."
(New-Object System.Net.WebClient).DownloadFile($url, $tempfile)

############################################
# Search zip
############################################
function FindZipRootFolderName($file)
{
  $shell = new-object -com shell.application
  $zip = $shell.NameSpace($file)
  foreach($item in $zip.items())
  {
    return $item.Name
  }
  return ""
}
$zipRootFolderName = FindZipRootFolderName -File $tempfile
Write-Host "Found folder '$zipRootFolderName' in zip archive."

############################################
# Unzip
############################################
Write-Host "Extracting zip archive to directory '$installpath'..."
function Expand-ZIPFile($file, $destination)
{
  $shell = new-object -com shell.application
  $zip = $shell.NameSpace($file)
  foreach($item in $zip.items())
  {
    $shell.Namespace($destination).copyhere($item)
  }
}
Expand-ZIPFile -File $tempfile -Destination $installpath

############################################
# Delete temp.zip file
############################################
Write-Host "Deleting temporary zip file."
$command_output = Remove-Item –path $tempfile –recurse

############################################
# Rename actual file
############################################
Write-Host "Renaming folder '$zipRootFolderName' to '$name'..."
$command_output = Rename-Item -Path "$installpath\$zipRootFolderName" -NewName $name

############################################
# Define package HOME variable.
############################################
$envname  = $name + "_HOME"
$envname = $envname.ToUpper()
$envvalue = "$installpath\$name"
Write-Host "Setting environment variable '$envname' to value '$envvalue'."
[Environment]::SetEnvironmentVariable($envname, $envvalue, "User")

# Define an environment variable that can be retrieved from another script.
$env:INSTALL_HOME = $envvalue

Write-Host "GitHub release '$name' installed without error."
exit 0
