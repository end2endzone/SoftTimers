# Any commands which fail will cause the shell script to exit immediately
set -e

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

# Check Arduino CLI installation
echo Expecting Arduino IDE installed in directory: $ARDUINO_CLI_INSTALL_DIR
echo Searching for arduino cli executable...
export PATH=$PATH:$ARDUINO_CLI_INSTALL_DIR
which arduino-cli
echo

export ARDUINO_INO_FILE=$PRODUCT_SOURCE_DIR/examples/$1/$1.ino

echo ==========================================================================================================
echo Compiling $ARDUINO_INO_FILE
echo ==========================================================================================================
cd $PRODUCT_SOURCE_DIR/examples/$1
arduino-cli compile -b arduino:avr:nano:cpu=atmega328 $1.ino

cd "$(dirname "$0")"
