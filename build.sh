#!/bin/bash
# Build script

set -eu

TIMEOUT=2
trap cleanup SIGINT SIGTERM SIGHUP

cleanup() {
  echo "⇒ Cleaning up!!"
  for pid in "${job_pid[@]}"; do
    kill "$pid"
  done
  exit $1
}

startBuild() {
  bundle exec jekyll build --watch &> /dev/null &
  job_pid[1]=$!
  bundle exec jekyll serve --incremental &> /dev/null &
  job_pid[2]=$!
  sass --watch assets/_scss/main.scss:assets/css/main.css &> /dev/null &
  job_pid[3]=$!
}

echo "Starting build..."
if startBuild; then
  echo -e "\e[1;32mJobs running. Visit http://localhost:4000\e[0m"
else
  cleanup 1
fi

while true; do
  read -p "Exit? [Y] " response;
  if [[ -z $response ]]; then
    cleanup 0
  fi
done
