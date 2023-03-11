# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate mandatory environment variables
if [ "$PRODUCT_BUILD_TYPE" = "" ]; then
  echo "Please define 'PRODUCT_BUILD_TYPE' environment variable.";
  exit 1;
fi

# Set PRODUCT_SOURCE_DIR root directory
if [ "$PRODUCT_SOURCE_DIR" = "" ]; then
  RESTORE_DIRECTORY="$PWD"
  cd "$(dirname "$0")"
  cd ../..
  export PRODUCT_SOURCE_DIR="$PWD"
  echo "PRODUCT_SOURCE_DIR set to '$PRODUCT_SOURCE_DIR'."
  cd "$RESTORE_DIRECTORY"
  unset RESTORE_DIRECTORY
fi

unset CMAKE_PREFIX_PATH
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH;$PRODUCT_SOURCE_DIR/third_parties/googletest/install"
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH;$PRODUCT_SOURCE_DIR/third_parties/RapidAssist/install"
export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH;$PRODUCT_SOURCE_DIR/third_parties/win32Arduino/install"

echo ============================================================================
echo Generating SoftTimers...
echo ============================================================================
cd $PRODUCT_SOURCE_DIR
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH" -DSOFTTIMERS_BUILD_EXAMPLES=ON ..

echo ============================================================================
echo Compiling SoftTimers...
echo ============================================================================
cmake --build .
echo
