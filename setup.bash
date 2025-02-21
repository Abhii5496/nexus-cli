#!/bin/bash

# Create and navigate to the directory
mkdir -p nexus-cli
cd nexus-cli || exit

# Install Rust
if ! command -v rustc &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust is already installed."
fi

# Add Rust target
rustup target add riscv32i-unknown-none-elf

# Update system package list
sudo apt update

# Install required packages if missing
REQUIRED_PKGS=("pkg-config" "libssl-dev" "protobuf-compiler")
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! dpkg -l | grep -qw "$pkg"; then
        echo "Installing $pkg..."
        sudo apt install -y "$pkg"
    else
        echo "$pkg is already installed."
    fi
done

# Install Nexus CLI
curl https://cli.nexus.xyz/ | sh

echo "Setup completed successfully."
