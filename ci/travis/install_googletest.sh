# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$TRAVIS_BUILD_DIR" = "" ]; then
  echo "Please define 'TRAVIS_BUILD_DIR' environment variable.";
  exit 1;
fi

export CMAKE_INSTALL_PREFIX=$TRAVIS_BUILD_DIR/third_parties/googletest/install

echo ============================================================================
echo Cloning googletest into $TRAVIS_BUILD_DIR/third_parties/googletest
echo ============================================================================
mkdir -p $TRAVIS_BUILD_DIR/third_parties
cd $TRAVIS_BUILD_DIR/third_parties
git clone "https://github.com/google/googletest.git"
cd googletest
echo

echo Checking out version 1.8.0...
git -c advice.detachedHead=false checkout release-1.8.0
echo

echo ============================================================================
echo Compiling googletest...
echo ============================================================================
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_GMOCK=OFF -DBUILD_GTEST=ON ..
cmake --build . -- -j4
echo

echo ============================================================================
echo Installing googletest into $CMAKE_INSTALL_PREFIX
echo ============================================================================
make install
echo
