Param(
  [Parameter(Mandatory=$True)]
  [string]$build,
  [Parameter(Mandatory=$True)]
  [string]$src
)

Write-Host "Running cmake generator..."

############################################
# Deleting previous build folder (if any)
############################################
if ( Test-Path $build -PathType Container )
{
  Write-Host "Deleting previous build directory: $build"
  Remove-Item –Path "$build" –recurse | Out-Null
}

############################################
# Create build directory
############################################
New-Item -ItemType Directory -Force -Path $build | Out-Null

############################################
Write-Output "Launching cmake..."
############################################
cd $build
cmake -G "Visual Studio 10 2010" -Dgtest_force_shared_crt=ON -DCMAKE_CXX_FLAGS_DEBUG=/MDd -DCMAKE_CXX_FLAGS_RELEASE=/MD "$src"
