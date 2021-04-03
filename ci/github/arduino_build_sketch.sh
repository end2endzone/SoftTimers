# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

export ARDUINO_BOARD="arduino:avr:nano:cpu=atmega328"
export ARDUINO_INO_FILE=$GITHUB_WORKSPACE/examples/$1/$1.ino

# Add Arduino IDE to PATH
echo Expecting Arduino IDE installed in directory: $ARDUINO_INSTALL_DIR
export PATH=$PATH:$ARDUINO_INSTALL_DIR

echo ==========================================================================================================
echo Compiling $ARDUINO_INO_FILE
echo ==========================================================================================================

# --verbose-build
if [ "$RUNNER_OS" = "Linux" ]; then
  arduino --verify --board $ARDUINO_BOARD $ARDUINO_INO_FILE
elif [ "$RUNNER_OS" = "macOS" ]; then
  Arduino --verify --board $ARDUINO_BOARD $ARDUINO_INO_FILE
fi
