# Neovim Configuration

This is a modern Neovim configuration built with Lua, featuring a modular plugin architecture and optimized for development in Python, Ruby, Rust, C, and DevOps workflows.

## Structure

```
.config/nvim/
├── init.lua              # Entry point - loads core settings and initializes Lazy.nvim
├── lazy-lock.json        # Plugin version lock file
└── lua/
    ├── core/
    │   ├── options.lua   # Neovim options and settings
    │   ├── keymaps.lua   # Global key mappings
    │   └── snippets.lua  # Snippet configuration
    └── plugins/          # Individual plugin configurations
        ├── alpha.lua         # Start screen
        ├── bufferline.lua    # Buffer tabs
        ├── colorscheme.lua   # Color scheme loader
        ├── comment.lua       # Commenting
        ├── conform.lua       # Code formatting
        ├── git.lua           # Git integration (NEW)
        ├── gitsigns.lua      # Git decorations
        ├── harpoon.lua       # Quick file navigation
        ├── lazydev.lua       # Lua development
        ├── lazygit.lua       # Git TUI
        ├── lualine.lua       # Status line
        ├── luvit-meta.lua    # Luvit types
        ├── mini.lua          # Mini plugins
        ├── neo-tree.lua      # File explorer
        ├── neotest.lua       # Test runner (NEW)
        ├── nvim-cmp.lua      # Autocompletion
        ├── nvim-lspconfig.lua # LSP configuration
        ├── quality-of-life.lua # QoL improvements (NEW)
        ├── render-markdown.lua # Markdown rendering
        ├── rose-pine.lua     # Theme
        ├── telescope.lua     # Fuzzy finder
        ├── todo-comments.lua # TODO highlighting
        ├── treesitter.lua    # Syntax highlighting
        ├── vim-kitty.lua     # Kitty syntax
        ├── vim-sleuth.lua    # Auto-detect indentation
        └── which-key.lua     # Keybinding hints
```

## Core Features

### Package Manager

- **[Lazy.nvim](https://github.com/folke/lazy.nvim)**: Modern plugin manager with lazy loading capabilities

### Editor Settings (`core/options.lua`)

- Line numbers with relative numbering
- Mouse support enabled
- System clipboard integration
- Smart indentation (2 spaces, configurable to 4 for specific languages)
- UTF-8 encoding
- No swap files
- Persistent undo history
- Nerd fonts enabled for icons
- Split windows open right/below by default
- Live substitution preview
- Auto-indent and smart indent enabled

### Key Mappings (`core/keymaps.lua`)

- **Leader Key**: Space
- **File Operations**:
    - `<C-s>`: Save file
    - `<C-q>`: Quit
    - `<leader>sn`: Save without formatting
- **Window Management**:
    - `<leader>v`: Vertical split
    - `<leader>h`: Horizontal split
    - `<leader>se`: Make splits equal size
    - `<leader>xs`: Close current split
    - `<C-h/j/k/l>`: Navigate between splits
    - `<Up/Down/Left/Right>`: Resize windows
- **Buffer Navigation**:
    - `<Tab>`: Next buffer
    - `<S-Tab>`: Previous buffer
    - `<leader>x`: Close buffer
    - `<leader>b`: New buffer
- **Search**: `<Esc>` clears highlights
- **Quick Escape**: `jk` or `kj` in insert mode
- **Text Manipulation**:
    - `<leader>+/-`: Increment/decrement numbers
    - `<leader>j`: Replace word under cursor
    - `<leader>y`: Yank to system clipboard
    - `<leader>Y`: Yank line to system clipboard
    - `<leader>lw`: Toggle line wrapping
- **Diagnostics**:
    - `<leader>do`: Toggle diagnostics
    - `[d/]d`: Previous/next diagnostic
    - `<leader>d`: Open floating diagnostic
    - `<leader>q`: Open diagnostics list

## Installed Plugins

### UI & Aesthetics

- **[Rose Pine](https://github.com/rose-pine/neovim)**: Active colorscheme
- **[Alpha](https://github.com/goolord/alpha-nvim)**: Start screen
- **[Lualine](https://github.com/nvim-lualine/lualine.nvim)**: Status line
- **[Bufferline](https://github.com/akinsho/bufferline.nvim)**: Buffer tabs
- **[Which Key](https://github.com/folke/which-key.nvim)**: Keybinding hints
- **[Todo Comments](https://github.com/folke/todo-comments.nvim)**: Highlight TODO, FIXME, etc.
- **[Render Markdown](https://github.com/MeanderingProgrammer/render-markdown.nvim)**: Enhanced markdown rendering

### File Management

- **[Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)**: File explorer
- **[Telescope](https://github.com/nvim-telescope/telescope.nvim)**: Fuzzy finder
    - `<leader>sf`: Find files
    - `<leader>sg`: Live grep
    - `<leader>sh`: Search help
    - `<leader><leader>`: Buffer search
- **[Harpoon](https://github.com/ThePrimeagen/harpoon)**: Quick file navigation
    - `<leader>m`: Add file to Harpoon
    - `<leader>M`: View Harpoon menu
    - `<leader>1-4`: Jump to Harpoon files

### Code Intelligence

- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**: LSP configuration
- **[Mason](https://github.com/williamboman/mason.nvim)**: LSP/formatter installer
- **[Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: Advanced syntax highlighting
    - **Incremental Selection**:
        - `<C-space>`: Start/expand selection
        - `<bs>`: Shrink selection
    - **Text Objects**:
        - `af/if`: Outer/inner function
        - `ac/ic`: Outer/inner class
        - `ai/ii`: Outer/inner conditional
        - `al/il`: Outer/inner loop
        - `aa/ia`: Outer/inner parameter
    - **Navigation**:
        - `]m/[m`: Next/previous function
        - `]]/[[`: Next/previous class
        - `]o/[o`: Next/previous loop
    - **Swap**: `<leader>a/A`: Swap parameter with next/previous
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)**: Autocompletion
    - `<C-n/p>`: Navigate suggestions
    - `<C-y>`: Accept completion
    - `<C-Space>`: Trigger completion

### Code Editing

- **[Comment.nvim](https://github.com/numToStr/Comment.nvim)**: Smart commenting
- **[Mini.nvim](https://github.com/echasnovski/mini.nvim)**: Collection of minimal plugins
- **[Conform](https://github.com/stevearc/conform.nvim)**: Code formatting
    - `<leader>f`: Format buffer
    - Auto-format on save (except C/C++)
- **[vim-sleuth](https://github.com/tpope/vim-sleuth)**: Auto-detect indentation

### Git Integration

- **[Gitsigns](https://github.com/lewis6991/gitsigns.nvim)**: Git decorations
- **[Lazygit](https://github.com/kdheepak/lazygit.nvim)**: Git TUI integration
- **[Fugitive](https://github.com/tpope/vim-fugitive)**: Git commands in Vim
    - `<leader>gs`: Git status
    - `<leader>gb`: Git blame
    - `<leader>gd`: Git diff split
    - `<leader>gc`: Git commit
    - `<leader>gC`: Git commit with commitizen
    - `<leader>gp/gP`: Git push/pull
    - `<leader>gl/gL`: Git log (oneline/full)
- **[Diffview](https://github.com/sindrets/diffview.nvim)**: Advanced diff visualization
    - `<leader>gv`: Open diff view
    - `<leader>gh`: File history
    - `<leader>gH`: Branch history
    - `<leader>gx`: Close diff view

### Testing

- **[Neotest](https://github.com/nvim-neotest/neotest)**: Modern test runner
    - `<leader>tn`: Run nearest test
    - `<leader>tf`: Run file tests
    - `<leader>ts`: Run test suite
    - `<leader>tl`: Run last test
    - `<leader>td`: Debug nearest test
    - `<leader>to`: Show test output
    - `<leader>tO`: Toggle test output panel
    - `<leader>tt`: Toggle test summary
    - `<leader>tw`: Toggle watch mode
    - `[t/]t`: Jump to previous/next failed test
- **[nvim-coverage](https://github.com/andythigpen/nvim-coverage)**: Code coverage
    - `<leader>tc`: Toggle coverage display
    - `<leader>tC`: Load coverage data

### Language Support

- **[vim-kitty](https://github.com/fladson/vim-kitty)**: Kitty terminal config syntax
- **[crates.nvim](https://github.com/saecki/crates.nvim)**: Rust crate management
    - In `Cargo.toml`:
        - `<leader>ct`: Toggle crate info
        - `<leader>cr`: Reload
        - `<leader>cv`: Show versions
        - `<leader>cf`: Show features
        - `<leader>cd`: Show dependencies
        - `<leader>cu`: Update crate(s)
        - `<leader>ca`: Update all crates
        - `<leader>cU`: Upgrade crate(s)
        - `<leader>cA`: Upgrade all crates

### Development Tools

- **[Fidget](https://github.com/j-hui/fidget.nvim)**: LSP progress indicator
- **[Lazydev](https://github.com/folke/lazydev.nvim)**: Lua development
- **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)**: Snippet engine

### Quality of Life

- **[nvim-autopairs](https://github.com/windwp/nvim-autopairs)**: Auto-close brackets/quotes
    - `<M-e>`: Fast wrap (add surrounding pairs)
- **[nvim-surround](https://github.com/kylechui/nvim-surround)**: Manipulate surroundings
    - `ys{motion}{char}`: Add surrounding
    - `ds{char}`: Delete surrounding
    - `cs{target}{replacement}`: Change surrounding
- **[Trouble](https://github.com/folke/trouble.nvim)**: Pretty diagnostics
    - `<leader>dd`: Toggle diagnostics
    - `<leader>dD`: Buffer diagnostics
    - `<leader>dl`: Location list
    - `<leader>dq`: Quickfix list
- **[auto-session](https://github.com/rmagatti/auto-session)**: Session management
    - `<leader>Ss`: Search sessions
    - `<leader>Sr`: Restore session
    - `<leader>SS`: Save session
    - `<leader>Sd`: Delete session
    - Note: `<leader>ss/sl` in keymaps.lua (manual session save/load) may conflict
- **[toggleterm](https://github.com/akinsho/toggleterm.nvim)**: Terminal management
    - `<C-\>`: Toggle floating terminal
    - `<leader>tf`: Float terminal
    - `<leader>th`: Horizontal terminal
    - `<leader>tv`: Vertical terminal
    - `<leader>tg`: Lazygit terminal
    - `<leader>tp`: Python REPL
    - `<leader>tn`: Node REPL (Note: conflicts with neotest mapping)
    - `<leader>ti`: Ruby IRB
    - `<leader>tR`: Cargo run
    - In terminal: `<Esc>` or `jk` to exit insert mode

## LSP Configuration

Language servers (auto-installed via Mason):

- **lua_ls**: Lua
- **rust_analyzer**: Rust (with Clippy)
- **pyright**: Python (strict mode)
- **solargraph**: Ruby
- **clangd**: C/C++ (with clang-tidy)
- **yamlls**: YAML (with Kubernetes schemas)
- **jsonls**: JSON (with schema validation)
- **terraformls**: Terraform
- **dockerls**: Dockerfile
- **helm_ls**: Helm charts
- **sqlls**: SQL

## Formatting

Formatters (auto-installed via Mason):

- **stylua**: Lua
- **ruff**: Python (fast, replaces black/isort/flake8)
    - Alternatives: **black** (formatter), **isort** (import sorter)
- **standardrb**: Ruby
    - Alternative: **rubocop**
- **rustfmt**: Rust
- **clang-format**: C/C++ (LLVM style, 4-space indent)
- **prettier**: JSON, YAML, Markdown, HTML, CSS (4-space indent)
- **terraform fmt**: Terraform files

All languages auto-format on save.

## Testing Support

- **Python**: pytest with coverage support
- **Ruby**: RSpec
- **Rust**: cargo test
- **C**: No test runner configured (can be added if needed)

## External Dependencies

Required system tools:

- **git**: Plugin management
- **ripgrep**: Telescope grep functionality
- **fd**: Telescope file finding
- **make**: Building plugins
- **gcc/clang**: Treesitter parser compilation

### Neovim Python Support

A Python virtual environment is required at `~/.config/nvim/venv/` with the `pynvim` package:

```bash
python3 -m venv ~/.config/nvim/venv
~/.config/nvim/venv/bin/pip install pynvim
```

Language-specific tools (install via package manager):

- **Python**: `pip install pytest pytest-cov coverage`
- **Ruby**: `gem install rspec standardrb`
- **Rust**: `rustup component add rustfmt clippy`
- **Node.js**: For LSP servers and prettier

## Getting Started

1. Install Neovim 0.9 or later
2. Install system dependencies:

    ```bash
    # macOS (using Homebrew)
    brew install neovim ripgrep fd make gcc node

    # Ubuntu/Debian
    sudo apt install neovim ripgrep fd-find make gcc nodejs npm
    ```

3. Clone this config to `~/.config/nvim`:
    ```bash
    git clone <your-repo> ~/.config/nvim
    ```
4. Set up Python virtual environment for Neovim:
    ```bash
    python3 -m venv ~/.config/nvim/venv
    ~/.config/nvim/venv/bin/pip install pynvim
    ```
5. Start Neovim - plugins will auto-install on first launch
6. Run `:Mason` to verify LSP servers are installed
7. Run `:checkhealth` to verify setup and troubleshoot any issues
8. Install language-specific tools as needed (see External Dependencies)

## Tips and Tricks

- Use `<leader>` (Space) + key to access most features
- Press `<leader>` and wait to see available keybindings
- Use `:Telescope keymaps` to search all keybindings
- Treesitter text objects work with all vim motions (d, c, y, v)
- Sessions auto-save and restore per Git branch
- Virtual environments are auto-detected for Python projects:
    - Looks for `venv/` or `.venv/` in project root
    - Automatically sets Python interpreter for LSP

