# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate github's environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

export CMAKE_INSTALL_PREFIX=$GITHUB_WORKSPACE/third_parties/win32Arduino/install
unset CMAKE_PREFIX_PATH
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH;$GITHUB_WORKSPACE/third_parties/googletest/install"
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH;$GITHUB_WORKSPACE/third_parties/RapidAssist/install"

echo ============================================================================
echo Cloning win32Arduino into $GITHUB_WORKSPACE/third_parties/win32Arduino
echo ============================================================================
mkdir -p $GITHUB_WORKSPACE/third_parties
cd $GITHUB_WORKSPACE/third_parties
git clone "https://github.com/end2endzone/win32Arduino.git"
cd win32Arduino
echo

echo Checking out version 2.4.0...
git -c advice.detachedHead=false checkout 2.4.0
echo

echo ============================================================================
echo Compiling win32Arduino...
echo ============================================================================
mkdir -p build
cd build
echo Configure...
cmake -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX -DCMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH" ..
echo Buliding...
cmake --build .
echo

echo ============================================================================
echo Installing win32Arduino into $CMAKE_INSTALL_PREFIX
echo ============================================================================
make install
echo
