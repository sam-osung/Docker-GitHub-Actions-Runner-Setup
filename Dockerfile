FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl sudo git jq iputils-ping ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create actions user
RUN useradd -m actions && echo "actions ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER actions
WORKDIR /home/actions

# Download GitHub Runner
RUN curl -O -L https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64-2.319.1.tar.gz \
    && tar xzf actions-runner-linux-x64-2.319.1.tar.gz \
    && rm actions-runner-linux-x64-2.319.1.tar.gz

# Copy entrypoint
COPY entrypoint.sh /home/actions/entrypoint.sh
RUN chmod +x /home/actions/entrypoint.sh

# Install runner dependencies
RUN sudo ./bin/installdependencies.sh

ENTRYPOINT ["/home/actions/entrypoint.sh"]
