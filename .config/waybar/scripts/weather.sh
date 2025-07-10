#!/bin/bash

# Replace with location cords
LOCATION=""

curl -s "https://wttr.in/${LOCATION}?format=%t+%c"
