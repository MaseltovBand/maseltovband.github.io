#!/bin/bash
# Helper file for development.. probably there is a such a tool for elm hot reload, but
# when you are on firefox and linux, you dont need fancy stuff..
# so lets hardcode it for this specific usecase here: compile the website, then reload the currently open firefox tab
elm make src/Website.elm --output=elm.js

CURRENT_WID=$(xdotool getwindowfocus)

# Assumes we have two open windows of firefox..
List=`xdotool search --name "Mozilla Firefox"`
set -- $List
WID=$2

xdotool windowactivate $WID
xdotool key F5

xdotool windowactivate $CURRENT_WID
