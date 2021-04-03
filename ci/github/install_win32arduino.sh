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
echo win32arduino_DIR=$win32arduino_DIR

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
echo Compiling...
echo ============================================================================
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$win32arduino_DIR ..
cmake --build .
echo

echo ============================================================================
echo Installing into $win32arduino_DIR
echo ============================================================================
make install
echo
