# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

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
echo Compiling RapidAssist...
echo ============================================================================
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$GITHUB_WORKSPACE/third_parties/RapidAssist/install -DCMAKE_PREFIX_PATH=$GITHUB_WORKSPACE/third_parties/googletest/install ..
cmake --build .
echo

echo ============================================================================
echo Installing RapidAssist into $GITHUB_WORKSPACE/third_parties/RapidAssist/install
echo ============================================================================
make install
echo
