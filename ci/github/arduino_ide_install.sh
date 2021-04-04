# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

export ARDUINO_IDE_VERSION=1.8.13

# Set download filename
export ARDUINO_IDE_FILENAME=""
if [ "$RUNNER_OS" = "Linux" ]; then
  export ARDUINO_IDE_FILENAME=arduino-$ARDUINO_IDE_VERSION-linux64.tar.xz
elif [ "$RUNNER_OS" = "macOS" ]; then
  export ARDUINO_IDE_FILENAME=arduino-$ARDUINO_IDE_VERSION-macosx.zip
fi

# Download
echo Downloading file http://downloads.arduino.cc/$ARDUINO_IDE_FILENAME
wget --no-verbose http://downloads.arduino.cc/$ARDUINO_IDE_FILENAME

# Installing
tar xf $ARDUINO_IDE_FILENAME
if [ "$RUNNER_OS" = "Linux" ]; then
  export ARDUINO_INSTALL_DIR=$PWD/arduino-ide
  mv arduino-$ARDUINO_IDE_VERSION $ARDUINO_INSTALL_DIR
elif [ "$RUNNER_OS" = "macOS" ]; then
  export ARDUINO_INSTALL_DIR=$PWD/Arduino.app/Contents/MacOS
fi

# Remember installation directory
echo Installing Arduino IDE to directory: $ARDUINO_INSTALL_DIR
echo ARDUINO_INSTALL_DIR=$ARDUINO_INSTALL_DIR>> $GITHUB_ENV

echo Searching for arduino executable...
export PATH=$PATH:$ARDUINO_INSTALL_DIR
if [ "$RUNNER_OS" = "Linux" ]; then
  which arduino
elif [ "$RUNNER_OS" = "macOS" ]; then
  which Arduino
fi

# Create libraries folder for current user
mkdir -p $HOME/Arduino/libraries

# Install current library to Arduino Library repository
ln -s $GITHUB_WORKSPACE $HOME/Arduino/libraries/.
