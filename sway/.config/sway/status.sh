#!/bin/sh
battery_info=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state|percentage" | awk '{print $2}')
date_formatted=$(date "+%a %b %_d %Y (W%W) %H:%M")

echo 🔋 $battery_info $date_formatted
