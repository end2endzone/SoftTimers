# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

export GTEST_ROOT=$GITHUB_WORKSPACE/third_parties/googletest/install
export rapidassist_DIR=$GITHUB_WORKSPACE/third_parties/RapidAssist/install
echo rapidassist_DIR=$rapidassist_DIR

echo ============================================================================
echo Cloning RapidAssist into $GITHUB_WORKSPACE/third_parties/RapidAssist
echo ============================================================================
mkdir -p $GITHUB_WORKSPACE/third_parties
cd $GITHUB_WORKSPACE/third_parties
git clone "https://github.com/end2endzone/RapidAssist.git"
cd RapidAssist
echo

echo Checking out version v0.5.0...
git checkout 0.5.0
echo

echo ============================================================================
echo Compiling...
echo ============================================================================
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$rapidassist_DIR ..
cmake --build .
echo

echo ============================================================================
echo Installing into $rapidassist_DIR
echo ============================================================================
make install
echo
