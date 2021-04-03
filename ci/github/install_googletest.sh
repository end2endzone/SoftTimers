# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

echo ============================================================================
echo Cloning googletest into $GITHUB_WORKSPACE/third_parties/googletest
echo ============================================================================
mkdir -p $GITHUB_WORKSPACE/third_parties
cd $GITHUB_WORKSPACE/third_parties
git clone "https://github.com/google/googletest.git"
cd googletest
echo

echo Checking out version 1.8.0...
git checkout release-1.8.0
echo

echo ============================================================================
echo Compiling...
echo ============================================================================
mkdir -p build
cd build
export GTEST_ROOT=$GITHUB_WORKSPACE/third_parties/googletest/install
cmake -DCMAKE_INSTALL_PREFIX=$GTEST_ROOT -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_GMOCK=OFF -DBUILD_GTEST=ON ..
cmake --build .
echo

echo ============================================================================
echo Installing into $GTEST_ROOT
echo ============================================================================
make install
echo
