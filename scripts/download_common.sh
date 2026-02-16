#!/usr/bin/env bash
# Shared settings for image download scripts.
# Wikimedia Commons requires a User-Agent; requests without one often fail.
# See https://meta.wikimedia.org/wiki/User-Agent_policy
# Source this from each chapter script: source "$SCRIPT_DIR/download_common.sh"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Identify the project and a way to contact (GitHub repo). Required for reliable Commons downloads.
CURL_USER_AGENT="AmericanYawpMS-ImageDownloader/1.0 (https://github.com/shiebenaderet/yawpms; contact via GitHub Issues)"
