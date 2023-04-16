#!/bin/bash

# Parse command line arguments
while getopts ":p:t:" opt; do
  case ${opt} in
    p )
      pid=$OPTARG
      ;;
    t )
      time=$OPTARG
      ;;
    \? )
      echo "Usage: $0 [-p pid] [-t time]"
      exit 1
      ;;
  esac
done

# Set default values for PID and time if not provided
pid=${pid:-0}
time=${time:-30}

# Generate profiling data using offcputime and convert to flame graph
offcputime -p $pid $time | /FlameGraph/flamegraph.pl --color=io --title="Off-CPU Time Flame Graph" --countname=us