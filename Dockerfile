# Dockerfile

FROM ubuntu:18.04

# Install necessary packages
RUN apt update && \
    apt install -y build-essential && \
    apt install -y sudo git curl fuse

# Rustup and Cargo
ENV PATH=/tmp/.cargo/bin:$PATH
ENV CARGO_HOME=/tmp/.cargo
ENV RUSTUP_HOME=/tmp/.rustup
RUN curl -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly --no-modify-path -y && \
    chmod 777 -R /tmp/.cargo /tmp/.rustup

# Install wezterm dependencies
COPY wezterm/get-deps /tmp/get-deps
COPY wezterm/ci/check-rust-version.sh /tmp/ci/check-rust-version.sh
RUN  cd /tmp && \
     /tmp/get-deps

# Add entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["bash"]
