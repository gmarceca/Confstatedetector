#!/bin/bash
# testing script for CI

## test type
if [[ -z "$1" ]]
then
  echo 'usage:'
  echo ' Run matlab basic tests: '
  echo '     test_script $matlabversoin $test_to_run'
  echo '     will call required matlab and launch test_matlab($test_to_run)'
  echo '   $matlabcommand is the binary used to launch the correct matlab version'
  echo ' works on SPC lac clusters for now'
  exit 1
fi

matlabbin=$1
testargument=$2

matlabcmd="$matlabbin -nodesktop -nosplash "
matlab_call="tests_matlab('$testargument')"
full_cmd="$matlabcmd -r $matlab_call";
echo $full_cmd
$full_cmd ## execute
CODE=$?
echo "exit with CODE" $CODE
exit $CODE
