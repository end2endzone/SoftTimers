# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate Travis CI environment
if [ "$TRAVIS_BUILD_DIR" = "" ]; then
  echo "Please define 'TRAVIS_BUILD_DIR' environment variable.";
  exit 1;
fi

export ARDUINO_IDE_VERSION=1.8.13

# Download
wget http://downloads.arduino.cc/arduino-$ARDUINO_IDE_VERSION-linux64.tar.xz

# Installing
tar xf arduino-$ARDUINO_IDE_VERSION-linux64.tar.xz
mv arduino-$ARDUINO_IDE_VERSION $HOME/arduino-ide

# Add Arduino IDE to PATH
export PATH=$PATH:$HOME/arduino-ide

# Create libraries folder for current user
mkdir -p $HOME/Arduino/libraries

# Install current library to Arduino Library repository
ln -s $TRAVIS_BUILD_DIR $HOME/Arduino/libraries/.
