# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

echo ============================================================================
echo Generating SoftTimers...
echo ============================================================================
cd $GITHUB_WORKSPACE
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$GITHUB_WORKSPACE/third_parties/googletest/install;$GITHUB_WORKSPACE/third_parties/RapidAssist/install;$GITHUB_WORKSPACE/third_parties/win32Arduino/install" -DSOFTTIMERS_BUILD_EXAMPLES=ON ..

echo ============================================================================
echo Compiling SoftTimers...
echo ============================================================================
cmake --build .
echo
