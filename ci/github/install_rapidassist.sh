# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate github's environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

export CMAKE_INSTALL_PREFIX=$GITHUB_WORKSPACE/third_parties/RapidAssist/install
unset CMAKE_PREFIX_PATH
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH;$GITHUB_WORKSPACE/third_parties/googletest/install"

echo ============================================================================
echo Cloning RapidAssist into $GITHUB_WORKSPACE/third_parties/RapidAssist
echo ============================================================================
mkdir -p $GITHUB_WORKSPACE/third_parties
cd $GITHUB_WORKSPACE/third_parties
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
