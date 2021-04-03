# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

export GTEST_ROOT=$GITHUB_WORKSPACE/third_parties/googletest/install
export rapidassist_DIR=$GITHUB_WORKSPACE/third_parties/RapidAssist/install
export win32arduino_DIR=$GITHUB_WORKSPACE/third_parties/win32Arduino/install

echo ============================================================================
echo Generating SoftTimers...
echo ============================================================================
cd $GITHUB_WORKSPACE
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DSOFTTIMERS_BUILD_EXAMPLES=ON ..

echo ============================================================================
echo Compiling SoftTimers...
echo ============================================================================
cmake --build .
echo

# Delete all temporary environment variable created
unset GTEST_ROOT
unset rapidassist_DIR
unset win32arduino_DIR
