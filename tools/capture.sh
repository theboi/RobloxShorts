#!/bin/sh
# Manual Studio capture. Requires macOS screen-recording permission for the terminal.
set -eu
if [ "${1:-}" = "--list" ]; then
  ffmpeg -hide_banner -f avfoundation -list_devices true -i "" 2>&1 || true
  exit 0
fi
if [ "$#" -ne 7 ]; then
  echo "Usage: sh tools/capture.sh DEVICE SECONDS OUTPUT.mp4 LEFT TOP WIDTH HEIGHT"
  echo "First: sh tools/capture.sh --list"
  echo "Select the exact 9:16 Studio viewport rectangle; recording starts immediately."
  exit 1
fi
capture_device="$1"
capture_seconds="$2"
capture_output="$3"
capture_left="$4"
capture_top="$5"
capture_width="$6"
capture_height="$7"
case "$capture_device:$capture_seconds:$capture_left:$capture_top:$capture_width:$capture_height" in
  *[!0-9:]*) echo "Device, duration, and rectangle values must be nonnegative integers."; exit 1 ;;
esac
if [ "$capture_seconds" -le 0 ] || [ "$capture_width" -le 0 ] || [ "$capture_height" -le 0 ]; then
  echo "Duration and dimensions must be positive."
  exit 1
fi
if [ $((capture_width * 16)) -ne $((capture_height * 9)) ]; then
  echo "Capture rectangle must be exactly 9:16; do not stretch a landscape viewport."
  exit 1
fi
ffmpeg -hide_banner -n -f avfoundation -framerate 30 -capture_cursor 0 \
  -i "$capture_device:none" -t "$capture_seconds" \
  -vf "crop=$capture_width:$capture_height:$capture_left:$capture_top,scale=1080:1920:flags=lanczos" \
  -an -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p "$capture_output"
