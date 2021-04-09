# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$TRAVIS_BUILD_DIR" = "" ]; then
  echo "Please define 'TRAVIS_BUILD_DIR' environment variable.";
  exit 1;
fi

export CMAKE_INSTALL_PREFIX=$TRAVIS_BUILD_DIR/third_parties/win32Arduino/install
unset CMAKE_PREFIX_PATH
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH;$TRAVIS_BUILD_DIR/third_parties/googletest/install"
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH;$TRAVIS_BUILD_DIR/third_parties/RapidAssist/install"

echo ============================================================================
echo Cloning win32Arduino into $TRAVIS_BUILD_DIR/third_parties/win32Arduino
echo ============================================================================
mkdir -p $TRAVIS_BUILD_DIR/third_parties
cd $TRAVIS_BUILD_DIR/third_parties
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
