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
export PATH=$PATH:$HOME/arduino-ide

echo ==========================================================================================================
echo Compiling $ARDUINO_INO_FILE
echo ==========================================================================================================

# --verbose-build
arduino --verify --board $ARDUINO_BOARD $ARDUINO_INO_FILE
