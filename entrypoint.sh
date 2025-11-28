#!/bin/bash
set -e

cd /home/actions

if [ -z "$GITHUB_URL" ] || [ -z "$GITHUB_PAT" ] || [ -z "$RUNNER_NAME" ]; then
  echo "Missing required environment variables!" 
  exit 1
fi

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --token "$RUNNER_TOKEN"
  exit 0
}

trap cleanup SIGINT SIGTERM

# Get registration token
echo "Requesting registration token..."
RUNNER_TOKEN=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" \
  ${GITHUB_URL}/actions/runners/registration-token | jq -r .token)

# Configure runner
./config.sh \
  --url "${GITHUB_URL}" \
  --token "${RUNNER_TOKEN}" \
  --name "${RUNNER_NAME}" \
  --work "_work" \
  --unattended \
  --replace

# Start runner
./run.sh
