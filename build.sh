#!/bin/bash
# Build script

trap kill_all SIGINT SIGTERM SIGHUP

kill_all() {
  echo "Cleaning up!!"
  # for pid in $(jobs -p); do
  for pid in ${job_pid[@]}; do
    kill $pid
  done
  exit 0
}

bundle exec jekyll build --watch > /dev/null &
job_pid[1]=$!
bundle exec jekyll serve --incremental > /dev/null &
job_pid[2]=$!
sass --watch assets/_scss/main.scss:assets/css/main.css > /dev/null &
job_pid[3]=$!

echo "Starting build..."
sleep 5
echo "Jobs running. Visit http://localhost:4000."
while true; do
  read -p "Type (y) when done with testing: " yn;
  case $yn in
    y) kill_all;;
    *) echo "Invalid argument!!";;
  esac
done
