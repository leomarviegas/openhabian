#!/usr/bin/env bats

load habapp.bash
load helpers.bash
load openhab.bash

teardown_file() {
  systemctl kill habapp.service || true
}

@test "installation-habapp_install" {
  # required packages are not in the package cache
  run apt-get update

  #
  # install
  #
  echo -e "# ${COL_CYAN}$(timestamp) [openHABian] HABApp installation starting...${COL_DEF}" >&3
  run habapp_setup install 3>&-
  if [ "$status" -ne 0 ]; then echo "$output" >&3; fi
  [ "$status" -eq 0 ]
  echo -e "# ${COL_GREEN}$(timestamp) [openHABian] HABApp installation successful.${COL_DEF}" >&3
  
  # Ensure that HABApp doesn't crash on startup
  sleep 5s

  echo -e "# ${COL_CYAN}$(timestamp) [openHABian] Checking if HABApp service is running...${COL_DEF}" >&3
  run systemctl is-active --quiet habapp.service
  if [ "$status" -ne 0 ]; then systemctl status habapp.service; fi
  [ "$status" -eq 0 ]
  echo -e "# ${COL_GREEN}$(timestamp) [openHABian] HABApp service is running.${COL_DEF}" >&3

  #
  # remove
  #
  echo -e "# ${COL_CYAN}$(timestamp) [openHABian] HABApp removal starting...${COL_DEF}" >&3
  run habapp_setup remove 3>&-
  if [ "$status" -ne 0 ]; then echo "$output" >&3; fi
  [ "$status" -eq 0 ]
  echo -e "# ${COL_GREEN}$(timestamp) [openHABian] HABApp removal successful...${COL_DEF}" >&3

  echo -e "# ${COL_CYAN}$(timestamp) [openHABian] Checking if HABApp service is running...${COL_DEF}" >&3
  run systemctl is-active habapp.service 3>&-
  if [ "$status" -eq 0 ]; then echo "$output" >&3; fi
  [ "$status" -ne 0 ]
  echo -e "# ${COL_GREEN}$(timestamp) [openHABian] HABApp service is not running...${COL_DEF}" >&3
}
