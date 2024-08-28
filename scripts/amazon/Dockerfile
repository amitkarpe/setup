FROM amazonlinux:2

# Install basic tools and development packages
RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y curl git unzip gcc make openssl-devel perl-IPC-Cmd tar gzip

# Install RustUp and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install GitHub CLI
RUN yum install -y yum-utils && \
    yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo && \
    yum install -y gh

# Install EXA
RUN cargo install exa


# Install Zellij
RUN curl -OL https://github.com/zellij-org/zellij/releases/download/v0.40.1/zellij-x86_64-unknown-linux-musl.tar.gz
RUN tar -xvf zellij-x86_64-unknown-linux-musl.tar.gz
RUN chmod +x zellij
RUN mv zellij /usr/local/bin/

# Install Taskfile
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# Verify installations
RUN rustc --version && \
    cargo --version && \
    gh --version && \
    zellij --version && \
    exa --version && \
    task --version

# Set the working directory
WORKDIR /app

# Set the default command
CMD ["/bin/bash"]