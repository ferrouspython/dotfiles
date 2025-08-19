#!/bin/bash

# Neovim Configuration Setup Script
# This script installs all external dependencies for the nvim configuration

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt; then
            echo "ubuntu"
        elif command_exists dnf; then
            echo "fedora"
        elif command_exists pacman; then
            echo "arch"
        else
            echo "linux"
        fi
    else
        echo "unknown"
    fi
}

# Install packages based on OS
install_system_packages() {
    local os=$(detect_os)
    
    log_info "Detected OS: $os"
    log_info "Installing system packages..."
    
    case $os in
        "macos")
            if ! command_exists brew; then
                log_error "Homebrew not found. Please install Homebrew first:"
                log_error "https://brew.sh"
                exit 1
            fi
            
            # Update Homebrew
            brew update
            
            # Install packages
            local packages=(
                "neovim"
                "ripgrep" 
                "fd"
                "make"
                "gcc"
                "node"
                "lazygit"
                "python3"
            )
            
            for package in "${packages[@]}"; do
                if brew list "$package" &>/dev/null; then
                    log_success "$package already installed"
                else
                    log_info "Installing $package..."
                    brew install "$package"
                fi
            done
            ;;
            
        "ubuntu")
            log_info "Updating package lists..."
            sudo apt update
            
            # Install packages
            local packages=(
                "neovim"
                "ripgrep"
                "fd-find"
                "make"
                "gcc"
                "nodejs"
                "npm"
                "python3"
                "python3-pip"
                "python3-venv"
                "git"
            )
            
            sudo apt install -y "${packages[@]}"
            
            # Install lazygit (not in default repos)
            if ! command_exists lazygit; then
                log_info "Installing lazygit..."
                LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                tar xf lazygit.tar.gz lazygit
                sudo install lazygit /usr/local/bin
                rm lazygit lazygit.tar.gz
            fi
            ;;
            
        "fedora")
            log_info "Installing packages with dnf..."
            sudo dnf install -y neovim ripgrep fd-find make gcc nodejs npm python3 python3-pip git lazygit
            ;;
            
        "arch")
            log_info "Installing packages with pacman..."
            sudo pacman -S --noconfirm neovim ripgrep fd make gcc nodejs npm python python-pip git lazygit
            ;;
            
        *)
            log_error "Unsupported operating system: $os"
            log_error "Please install the following packages manually:"
            log_error "neovim, ripgrep, fd, make, gcc, nodejs, npm, python3, python3-pip, git, lazygit"
            exit 1
            ;;
    esac
    
    log_success "System packages installed successfully!"
}

# Setup Python virtual environment for Neovim
setup_python_venv() {
    log_info "Setting up Python virtual environment for Neovim..."
    
    local nvim_venv="$HOME/.config/nvim/venv"
    
    if [[ -d "$nvim_venv" ]]; then
        log_warning "Virtual environment already exists at $nvim_venv"
        read -p "Do you want to recreate it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$nvim_venv"
        else
            log_info "Skipping virtual environment setup"
            return
        fi
    fi
    
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$nvim_venv")"
    
    # Create virtual environment
    python3 -m venv "$nvim_venv"
    
    # Install pynvim
    "$nvim_venv/bin/pip" install --upgrade pip
    "$nvim_venv/bin/pip" install pynvim
    
    log_success "Python virtual environment created and pynvim installed"
}

# Install Node.js packages globally
install_node_packages() {
    log_info "Installing Node.js packages..."
    
    if ! command_exists npm; then
        log_error "npm not found. Please install Node.js first."
        return 1
    fi
    
    local packages=(
        "prettier"
    )
    
    for package in "${packages[@]}"; do
        log_info "Installing $package globally..."
        npm install -g "$package"
    done
    
    log_success "Node.js packages installed successfully!"
}

# Install language-specific development tools (optional)
install_language_tools() {
    log_info "Installing optional language-specific tools..."
    
    # Python tools
    if command_exists pip3 || command_exists pip; then
        local pip_cmd="pip3"
        if ! command_exists pip3; then
            pip_cmd="pip"
        fi
        
        log_info "Installing Python development tools..."
        local python_packages=(
            "pytest"
            "pytest-cov"
            "coverage"
            "ruff"
            "black"
            "isort"
        )
        
        for package in "${python_packages[@]}"; do
            $pip_cmd install --user "$package" 2>/dev/null || log_warning "Failed to install $package"
        done
    fi
    
    # Ruby tools (if Ruby is installed)
    if command_exists gem; then
        log_info "Installing Ruby development tools..."
        local ruby_packages=(
            "rspec"
            "standardrb"
            "rubocop"
        )
        
        for package in "${ruby_packages[@]}"; do
            gem install "$package" 2>/dev/null || log_warning "Failed to install $package"
        done
    fi
    
    # Rust tools (if Rust is installed)
    if command_exists rustup; then
        log_info "Installing Rust development tools..."
        rustup component add rustfmt clippy 2>/dev/null || log_warning "Failed to install Rust components"
    fi
    
    log_success "Language-specific tools installation completed!"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    local required_commands=(
        "nvim:Neovim"
        "rg:ripgrep"
        "fd:fd-find"
        "make:make"
        "gcc:gcc"
        "node:Node.js"
        "git:git"
    )
    
    local optional_commands=(
        "lazygit:LazyGit"
        "python3:Python 3"
        "npm:npm"
        "prettier:Prettier"
    )
    
    local missing_required=()
    local missing_optional=()
    
    # Check required commands
    for cmd_desc in "${required_commands[@]}"; do
        IFS=':' read -r cmd desc <<< "$cmd_desc"
        if command_exists "$cmd"; then
            log_success "$desc is installed"
        else
            log_error "$desc is missing"
            missing_required+=("$desc")
        fi
    done
    
    # Check optional commands
    for cmd_desc in "${optional_commands[@]}"; do
        IFS=':' read -r cmd desc <<< "$cmd_desc"
        if command_exists "$cmd"; then
            log_success "$desc is installed"
        else
            log_warning "$desc is missing (optional)"
            missing_optional+=("$desc")
        fi
    done
    
    # Check Python virtual environment
    if [[ -d "$HOME/.config/nvim/venv" ]] && [[ -f "$HOME/.config/nvim/venv/bin/python" ]]; then
        log_success "Neovim Python virtual environment is set up"
    else
        log_error "Neovim Python virtual environment is missing"
        missing_required+=("Python virtual environment")
    fi
    
    # Summary
    if [[ ${#missing_required[@]} -eq 0 ]]; then
        log_success "All required dependencies are installed!"
        
        if [[ ${#missing_optional[@]} -gt 0 ]]; then
            log_info "Missing optional dependencies: ${missing_optional[*]}"
        fi
        
        log_info "You can now start Neovim. Plugins will auto-install on first launch."
        log_info "Run ':checkhealth' in Neovim to verify the setup."
    else
        log_error "Missing required dependencies: ${missing_required[*]}"
        log_error "Please install the missing dependencies and run this script again."
        exit 1
    fi
}

# Main function
main() {
    echo "========================================"
    echo "  Neovim Configuration Setup Script"
    echo "========================================"
    echo
    
    # Check if we're in the right directory
    if [[ ! -f "init.lua" ]]; then
        log_warning "init.lua not found in current directory."
        log_warning "Make sure you're running this script from your nvim config directory."
        echo
    fi
    
    # Ask for confirmation
    log_info "This script will install system packages and set up your Neovim environment."
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup cancelled."
        exit 0
    fi
    
    echo
    
    # Run setup steps
    install_system_packages
    echo
    
    setup_python_venv
    echo
    
    install_node_packages
    echo
    
    # Ask about optional language tools
    read -p "Do you want to install optional language-specific development tools? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_language_tools
        echo
    fi
    
    verify_installation
    echo
    
    log_success "Setup completed successfully!"
    log_info "Next steps:"
    log_info "1. Start Neovim: nvim"
    log_info "2. Wait for plugins to auto-install"
    log_info "3. Run :Mason to verify LSP servers"
    log_info "4. Run :checkhealth to verify setup"
}

# Run main function
main "$@"