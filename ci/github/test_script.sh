# Any commands which fail will cause the shell script to exit immediately
set -e

# Validate github's environment
if [ "$GITHUB_WORKSPACE" = "" ]; then
  echo "Please define 'GITHUB_WORKSPACE' environment variable.";
  exit 1;
fi

echo ============================================================================
echo Running unit tests...
echo ============================================================================
cd $GITHUB_WORKSPACE/build/bin;
./softtimers_unittest || true; #do not fail build even if a test fails.

# Note:
#  GitHub Action do not support uploading test results in a nice GUI. There is no build-in way to detect a failed test.
#  Do not reset the error returned by unit test execution. This will actually fail the build and will indicate in GitHub that a test has failed.
# 
# || true; #do not fail build even if a test fails.
