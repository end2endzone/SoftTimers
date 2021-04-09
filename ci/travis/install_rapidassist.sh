# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$TRAVIS_BUILD_DIR" = "" ]; then
  echo "Please define 'TRAVIS_BUILD_DIR' environment variable.";
  exit 1;
fi

export CMAKE_INSTALL_PREFIX=$TRAVIS_BUILD_DIR/third_parties/RapidAssist/install
unset CMAKE_PREFIX_PATH
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH;$TRAVIS_BUILD_DIR/third_parties/googletest/install"

echo ============================================================================
echo Cloning RapidAssist into $TRAVIS_BUILD_DIR/third_parties/RapidAssist
echo ============================================================================
mkdir -p $TRAVIS_BUILD_DIR/third_parties
cd $TRAVIS_BUILD_DIR/third_parties
git clone "https://github.com/end2endzone/RapidAssist.git"
cd RapidAssist
echo

echo Checking out version v0.9.1...
git -c advice.detachedHead=false checkout 0.9.1
echo

echo ============================================================================
echo Compiling RapidAssist...
echo ============================================================================
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX -DCMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH" ..
cmake --build .
echo

echo ============================================================================
echo Installing RapidAssist into $CMAKE_INSTALL_PREFIX
echo ============================================================================
make install
echo
