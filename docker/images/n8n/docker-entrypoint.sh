#!/bin/sh
if [ -d /opt/custom-certificates ]; then
  echo "Trusting custom certificates from /opt/custom-certificates."
  export NODE_OPTIONS="--use-openssl-ca $NODE_OPTIONS"
  export SSL_CERT_DIR=/opt/custom-certificates
  c_rehash /opt/custom-certificates
fi

# Configure Claude Code to use persistent storage in /data
# If auth files exist in /data, symlink them to node user's home
if [ -d /data/.claude ]; then
  echo "Claude Code auth found in /data, linking to home directory"
  ln -sf /data/.claude /home/node/.claude
  ln -sf /data/.claude.json /home/node/.claude.json
fi

# Set ANTHROPIC_HOME for future auth
export ANTHROPIC_HOME=/data/.anthropic
mkdir -p $ANTHROPIC_HOME

# If ANTHROPIC_API_KEY is set, configure Claude Code to use it
if [ -n "$ANTHROPIC_API_KEY" ]; then
  echo "ANTHROPIC_API_KEY detected, Claude Code will use API key authentication"
fi

if [ "$#" -gt 0 ]; then
  # Got started with arguments
  exec n8n "$@"
else
  # Got started without arguments
  exec n8n
fi
