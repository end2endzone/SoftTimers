# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate GitHub CI environment
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
cmake -DCMAKE_INSTALL_PREFIX=$GITHUB_WORKSPACE/third_parties/googletest/install -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_GMOCK=OFF -DBUILD_GTEST=ON ..
cmake --build . -- -j4
echo

echo ============================================================================
echo Installing into $GITHUB_WORKSPACE/third_parties/googletest/install
echo ============================================================================
make install
echo
