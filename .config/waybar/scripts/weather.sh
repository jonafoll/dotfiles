#!/bin/bash

# Replace with location cords
LOCATION="latitude,longitude"

curl -s "https://wttr.in/${LOCATION}?format=%t+%c"
