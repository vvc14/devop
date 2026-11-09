
#!/usr/bin/env bash
#
# setup_dev_environment.sh
# Installs missing development and DevOps tools on Ubuntu/Debian.
#

set -euo pipefail

# Check root access
if [ "$EUID" -ne 0 ]; then
    echo "[!] Run using: sudo bash setup_dev_environment.sh"
    exit 1
fi

TARGET_USER="${SUDO_USER:-$USER}"

# Detect OS
source /etc/os-release

if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
    echo "[!] Only Ubuntu and Debian are supported."
    exit 1
fi

ARCH="$(dpkg --print-architecture)"
CODENAME="${VERSION_CODENAME:-$(lsb_release -cs)}"

echo "=========================================="
echo " Checking system"
echo "=========================================="

echo "OS: $PRETTY_NAME"
echo "Architecture: $ARCH"
echo "User: $TARGET_USER"

# Install only missing APT packages
install_missing_packages() {
    local missing=()
    local package

    for package in "$@"; do
        if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null |
            grep -q "install ok installed"; then
            missing+=("$package")
        else
            echo "[=] $package already installed"
        fi
    done

    if [ "${#missing[@]}" -gt 0 ]; then
        echo "[+] Installing: ${missing[*]}"
        apt-get install -y "${missing[@]}"
    fi
}

echo "=========================================="
echo " 1. Updating package lists"
echo "=========================================="

apt-get update -y

echo "=========================================="
echo " 2. Installing development essentials"
echo "=========================================="

install_missing_packages \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    git \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    pkg-config \
    unzip \
    zip \
    jq \
    tree \
    htop \
    nano \
    vim \
    rsync \
    openssh-client \
    dnsutils \
    net-tools \
    iproute2 \
    openssl \
    tar

echo "=========================================="
echo " 3. Installing Python"
echo "=========================================="

install_missing_packages \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python-is-python3

echo "=========================================="
echo " 4. Installing Node.js and npm"
echo "=========================================="

install_missing_packages nodejs npm

echo "=========================================="
echo " 5. Installing Docker"
echo "=========================================="

if ! command -v docker >/dev/null 2>&1; then

    echo "[+] Docker not found. Installing Docker..."

    install -m 0755 -d /etc/apt/keyrings

    curl -fsSL "https://download.docker.com/linux/${ID}/gpg" |
        gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg

    chmod a+r /etc/apt/keyrings/docker.gpg

    cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/${ID}
Suites: ${CODENAME}
Components: stable
Architectures: ${ARCH}
Signed-By: /etc/apt/keyrings/docker.gpg
EOF

    apt-get update -y

    install_missing_packages \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

    systemctl enable docker
    systemctl start docker

else
    echo "[=] Docker already installed. Skipping."
fi

# Configure Docker group
if command -v docker >/dev/null 2>&1; then
    if [ -n "$TARGET_USER" ] &&
       [ "$TARGET_USER" != "root" ] &&
       getent passwd "$TARGET_USER" >/dev/null; then

        if ! getent group docker >/dev/null; then
            groupadd docker
        fi

        usermod -aG docker "$TARGET_USER"

        echo "[+] Docker group configured for $TARGET_USER"
    fi
fi

echo "=========================================="
echo " 6. Installing kubectl"
echo "=========================================="

if ! command -v kubectl >/dev/null 2>&1; then

    KUBECTL_VERSION="$(curl -fsSL \
        https://dl.k8s.io/release/stable.txt)"

    echo "[+] Installing kubectl $KUBECTL_VERSION"

    curl -fsSLo /tmp/kubectl \
        "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl"

    install -o root -g root -m 0755 /tmp/kubectl \
        /usr/local/bin/kubectl

    rm -f /tmp/kubectl

else
    echo "[=] kubectl already installed. Skipping."
fi

echo "=========================================="
echo " 7. Installing Kind"
echo "=========================================="

if ! command -v kind >/dev/null 2>&1; then

    if [[ "$ARCH" != "amd64" && "$ARCH" != "arm64" ]]; then
        echo "[!] Kind installation unsupported for $ARCH"
    else
        KIND_VERSION="$(curl -fsSL \
            https://api.github.com/repos/kubernetes-sigs/kind/releases/latest |
            jq -r .tag_name)"

        echo "[+] Installing Kind $KIND_VERSION"

        curl -fsSLo /tmp/kind \
            "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-${ARCH}"

        install -o root -g root -m 0755 /tmp/kind \
            /usr/local/bin/kind

        rm -f /tmp/kind
    fi

else
    echo "[=] Kind already installed. Skipping."
fi

echo "=========================================="
echo " 8. Installing Helm"
echo "=========================================="

if ! command -v helm >/dev/null 2>&1; then

    echo "[+] Installing Helm"

    curl -fsSL \
        https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 |
        bash

else
    echo "[=] Helm already installed. Skipping."
fi

echo "=========================================="
echo " 9. Installing Postman Desktop"
echo "=========================================="

if ! command -v postman >/dev/null 2>&1; then

    case "$ARCH" in
        amd64)
            POSTMAN_URL="https://dl.pstmn.io/download/latest/linux64"
            ;;
        arm64)
            POSTMAN_URL="https://dl.pstmn.io/download/latest/linux_arm64"
            ;;
        *)
            echo "[!] Postman unsupported architecture: $ARCH"
            POSTMAN_URL=""
            ;;
    esac

    if [[ -n "$POSTMAN_URL" ]]; then

        echo "[+] Downloading Postman..."

        curl -fL "$POSTMAN_URL" -o /tmp/postman.tar.gz

        rm -rf /opt/Postman

        tar -xzf /tmp/postman.tar.gz -C /opt

        ln -sfn /opt/Postman/Postman /usr/local/bin/postman

        rm -f /tmp/postman.tar.gz

        # Create desktop launcher
        cat > /usr/share/applications/postman.desktop <<'EOF'
[Desktop Entry]
Name=Postman
Comment=API Development Environment
Exec=/opt/Postman/Postman %U
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF

        chmod 644 /usr/share/applications/postman.desktop

        echo "[+] Postman installed successfully"

    fi

else
    echo "[=] Postman already installed. Skipping."
fi

echo "=========================================="
echo " 10. Verification"
echo "=========================================="

check_tool() {
    local tool="$1"

    if command -v "$tool" >/dev/null 2>&1; then
        echo "[OK] $tool: $(command -v "$tool")"
    else
        echo "[MISSING] $tool"
    fi
}

for tool in \
    git python3 pip3 node npm \
    gcc g++ make cmake \
    curl wget jq \
    docker kubectl kind helm postman; do

    check_tool "$tool"

done

echo ""
echo "=========================================="
echo " Installation completed!"
echo "=========================================="

echo "Python:"
python3 --version

echo "Git:"
git --version

echo "Node:"
node --version

echo "NPM:"
npm --version

echo "Docker:"
docker --version

echo "Docker Compose:"
docker compose version

echo "kubectl:"
kubectl version --client

echo "Kind:"
if command -v kind >/dev/null 2>&1; then
    kind version
fi

echo "Helm:"
if command -v helm >/dev/null 2>&1; then
    helm version --short
fi

echo "Postman:"
if command -v postman >/dev/null 2>&1; then
    echo "Postman installed at $(command -v postman)"
fi

echo ""
echo "[!] Log out and back in to activate Docker group permissions."
echo "[+] Setup completed."
