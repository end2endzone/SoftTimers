# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

export ARDUINO_IDE_VERSION=1.8.13

# Set download filename
if [ "$RUNNER_OS" = "Linux" ]; then
  export ARDUINO_IDE_FILENAME=arduino-$ARDUINO_IDE_VERSION-linux64.tar.xz
elif [ "$RUNNER_OS" = "macOS" ]; then
  export ARDUINO_IDE_FILENAME=arduino-$ARDUINO_IDE_VERSION-macosx.zip
else
  # unknown
  export ARDUINO_IDE_FILENAME=arduino-$ARDUINO_IDE_VERSION-unknown.zip
fi

# Download
echo Downloading file http://downloads.arduino.cc/$ARDUINO_IDE_FILENAME
wget http://downloads.arduino.cc/$ARDUINO_IDE_FILENAME

# Installing
export ARDUINO_INSTALL_DIR=$HOME/arduino-ide
echo Installing Arduino IDE to '$ARDUINO_INSTALL_DIR'...
tar xf $ARDUINO_IDE_FILENAME
mv arduino-$ARDUINO_IDE_VERSION $ARDUINO_INSTALL_DIR

# Remember installation directory
echo ARDUINO_INSTALL_DIR=$ARDUINO_INSTALL_DIR>> $GITHUB_ENV

# Create libraries folder for current user
mkdir -p $HOME/Arduino/libraries

# Install current library to Arduino Library repository
ln -s $GITHUB_WORKSPACE $HOME/Arduino/libraries/.
