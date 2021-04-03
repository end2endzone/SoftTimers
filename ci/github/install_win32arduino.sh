# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

echo ============================================================================
echo Cloning win32Arduino into $GITHUB_WORKSPACE/third_parties/win32Arduino
echo ============================================================================
mkdir -p $GITHUB_WORKSPACE/third_parties
cd $GITHUB_WORKSPACE/third_parties
git clone "https://github.com/end2endzone/win32Arduino.git"
cd win32Arduino
echo

echo Checking out version 2.3.1...
git checkout 2.3.1
echo

echo ============================================================================
echo Compiling win32Arduino...
echo ============================================================================
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$win32arduino_DIR -DCMAKE_PREFIX_PATH=$GITHUB_WORKSPACE\third_parties\googletest\install;$GITHUB_WORKSPACE\third_parties\RapidAssist\install ..
cmake --build .
echo

echo ============================================================================
echo Installing win32Arduino into $win32arduino_DIR
echo ============================================================================
make install
echo
