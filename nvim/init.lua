-- Enhanced Neovim Lua configuration with improved plugins, native LSP, and autocompletion

--[[
PERFORMANCE IMPROVEMENTS:
1. Replaced NERDTree with nvim-tree (faster, native lua)
2. Replaced fzf with Telescope (better integration)
3. Added Treesitter for better syntax highlighting
4. Added which-key for keybinding management
5. Improved LSP configuration with null-ls for formatting/linting
6. Added Mason for easy LSP/DAP/linter management
7. Added lualine instead of vim-airline (faster, native lua)
8. Better navigation with hop.nvim
9. Added bufferline for improved buffer management
10. Added gitsigns instead of gitgutter (faster, native lua)
]]

-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Basic Settings
vim.g.mapleader = " " -- Set leader key to space
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.title = true
vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.mouse = "a"
vim.opt.showcmd = true
vim.opt.showmode = false -- Not needed with lualine
vim.opt.ruler = true
vim.opt.wildmenu = true
vim.opt.laststatus = 3 -- Global statusline
vim.opt.hidden = true
vim.opt.lazyredraw = true
vim.opt.backup = true
vim.opt.swapfile = true

-- Set directory paths explicitly as strings
local config_path = vim.fn.stdpath("config")
local swapdir = config_path .. "/swapfiles"
local backupdir = config_path .. "/backups"
local undodir = config_path .. "/undodir"

vim.opt.directory = swapdir
vim.opt.backupdir = backupdir
vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Better folding with treesitter
vim.opt.foldlevel = 99
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true -- Enable true colors
vim.opt.updatetime = 100     -- Faster update time for better experience
vim.opt.timeoutlen = 300     -- Faster which-key popup

-- Indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftround = true

-- Wildignore
vim.opt.wildignore = {
    "*.swp", "*.bak", "*.pyc", "*.class", "*.jar", "*.gif", "*.png", "*.jpg",
    "*/node_modules/*", "*/.git/*", "*/venv/*", "*/__pycache__/*", "*/dist/*", "*/build/*"
}

-- Keymaps
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<leader><space>", "za")            -- Changed from space to leader+space for folding
vim.keymap.set("n", "<leader>tt", ":TagbarToggle<CR>")
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- Toggle file explorer

-- Plugin Manager: Lazy.nvim
require("lazy").setup({
    -- UI Improvements
    {
        "nvim-tree/nvim-tree.lua", -- Replacement for NERDTree (faster)
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                hijack_cursor = true,
                update_focused_file = { enable = true },
                view = { width = 30, side = "left" },
            })
        end
    },
    {
        "nvim-lualine/lualine.nvim", -- Replacement for vim-airline (faster)
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = { theme = "codedark" }
            })
        end
    },
    {
        "akinsho/bufferline.nvim", -- Buffer line at the top
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = {
                    separator_style = "thin",
                    always_show_bufferline = true,
                }
            })
        end
    },

    -- AI Code Assistance
    {
        "zbirenbaum/copilot.lua", -- GitHub Copilot
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end
    },
    {
        "zbirenbaum/copilot-cmp", -- Copilot integration with nvim-cmp
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end
    },
    {
        "jackMort/ChatGPT.nvim", -- ChatGPT integration
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        },
        config = function()
            require("chatgpt").setup({
                api_key_cmd = nil, -- Will use OPENAI_API_KEY environment variable
                yank_register = "+",
                edit_with_instructions = {
                    diff = false,
                    keymaps = {
                        accept = "<C-y>",
                        toggle_diff = "<C-d>",
                        toggle_settings = "<C-o>",
                        cycle_windows = "<Tab>",
                        use_output_as_input = "<C-i>",
                    },
                },
                chat = {
                    welcome_message = "Welcome to ChatGPT! How can I help you today?",
                    loading_text = "Loading, please wait ...",
                    question_sign = "🙂",
                    answer_sign = "🤖",
                    max_line_length = 120,
                    sessions_window = {
                        border = {
                            style = "rounded",
                            text = {
                                top = " Sessions ",
                            },
                        },
                        win_options = {
                            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                        },
                    },
                    keymaps = {
                        close = { "<C-c>", "q" },
                        yank_last = "<C-y>",
                        yank_last_code = "<C-k>",
                        scroll_up = "<C-u>",
                        scroll_down = "<C-d>",
                        new_session = "<C-n>",
                        cycle_windows = "<Tab>",
                        cycle_modes = "<C-f>",
                        next_message = "<C-j>",
                        prev_message = "<C-k>",
                        select_session = "<Space>",
                        rename_session = "r",
                        delete_session = "d",
                        draft_message = "<C-r>",
                        edit_message = "e",
                        delete_message = "d",
                        toggle_settings = "<C-o>",
                        toggle_sessions = "<C-p>",
                        toggle_help = "<C-h>",
                        toggle_message_role = "<C-r>",
                        toggle_system_role_open = "<C-s>",
                        stop_generating = "<C-x>",
                    },
                },
                popup_layout = {
                    default = "center",
                    center = {
                        width = "80%",
                        height = "80%",
                    },
                    right = {
                        width = "30%",
                        width_settings_open = "50%",
                    },
                },
                popup_window = {
                    border = {
                        highlight = "FloatBorder",
                        style = "rounded",
                        text = {
                            top = " ChatGPT ",
                        },
                    },
                    win_options = {
                        wrap = true,
                        linebreak = true,
                        foldcolumn = "1",
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                    buf_options = {
                        filetype = "markdown",
                    },
                },
                system_window = {
                    border = {
                        highlight = "FloatBorder",
                        style = "rounded",
                        text = {
                            top = " SYSTEM ",
                        },
                    },
                    win_options = {
                        wrap = true,
                        linebreak = true,
                        foldcolumn = "2",
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
                popup_input = {
                    prompt = "  ",
                    border = {
                        highlight = "FloatBorder",
                        style = "rounded",
                        text = {
                            top_align = "center",
                            top = " Prompt ",
                        },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                    submit = "<C-Enter>",
                    submit_n = "<Enter>",
                    max_visible_lines = 20
                },
                settings_window = {
                    border = {
                        style = "rounded",
                        text = {
                            top = " Settings ",
                        },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                    },
                },
                openai_params = {
                    model = "gpt-4",
                    frequency_penalty = 0,
                    presence_penalty = 0,
                    max_tokens = 4000,
                    temperature = 0,
                    top_p = 1,
                    n = 1,
                },
                openai_edit_params = {
                    model = "gpt-4",
                    temperature = 0,
                    top_p = 1,
                    n = 1,
                },
            })

            -- Add keybindings for ChatGPT
            vim.keymap.set("n", "<leader>gc", "<cmd>ChatGPT<CR>", { desc = "ChatGPT" })
            vim.keymap.set("n", "<leader>ge", "<cmd>ChatGPTEditWithInstruction<CR>", { desc = "Edit with instruction" })
            vim.keymap.set("v", "<leader>ge", "<cmd>ChatGPTEditWithInstruction<CR>", { desc = "Edit with instruction" })
            vim.keymap.set("n", "<leader>gg", "<cmd>ChatGPTRun grammar_correction<CR>", { desc = "Grammar Correction" })
            vim.keymap.set("v", "<leader>gg", "<cmd>ChatGPTRun grammar_correction<CR>", { desc = "Grammar Correction" })
            vim.keymap.set("n", "<leader>gt", "<cmd>ChatGPTRun translate<CR>", { desc = "Translate" })
            vim.keymap.set("v", "<leader>gt", "<cmd>ChatGPTRun translate<CR>", { desc = "Translate" })
            vim.keymap.set("n", "<leader>go", "<cmd>ChatGPTRun optimize_code<CR>", { desc = "Optimize Code" })
            vim.keymap.set("v", "<leader>go", "<cmd>ChatGPTRun optimize_code<CR>", { desc = "Optimize Code" })
            vim.keymap.set("n", "<leader>gs", "<cmd>ChatGPTRun summarize<CR>", { desc = "Summarize" })
            vim.keymap.set("v", "<leader>gs", "<cmd>ChatGPTRun summarize<CR>", { desc = "Summarize" })
            vim.keymap.set("n", "<leader>gd", "<cmd>ChatGPTRun docstring<CR>", { desc = "Docstring" })
            vim.keymap.set("v", "<leader>gd", "<cmd>ChatGPTRun docstring<CR>", { desc = "Docstring" })
            vim.keymap.set("n", "<leader>ga", "<cmd>ChatGPTRun add_tests<CR>", { desc = "Add Tests" })
            vim.keymap.set("v", "<leader>ga", "<cmd>ChatGPTRun add_tests<CR>", { desc = "Add Tests" })
            vim.keymap.set("n", "<leader>gx", "<cmd>ChatGPTRun explain_code<CR>", { desc = "Explain Code" })
            vim.keymap.set("v", "<leader>gx", "<cmd>ChatGPTRun explain_code<CR>", { desc = "Explain Code" })
        end
    },

    -- Core Features
    {
        "nvim-treesitter/nvim-treesitter", -- Better syntax highlighting
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "python", "javascript", "typescript", "html", "css", "json", "vim", "bash", "markdown" },
                highlight = { enable = true },
                indent = { enable = true },
                folding = { enable = true },
            })
        end
    },
    {
        "nvim-telescope/telescope.nvim", -- Replacement for fzf (more features)
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
        },
        config = function()
            require("telescope").setup({
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    }
                }
            })
            require("telescope").load_extension("fzf")

            -- Telescope keymaps
            vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
            vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
            vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
            vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")
        end
    },
    {
        "folke/which-key.nvim", -- Keybinding helper
        config = function()
            require("which-key").setup()
        end
    },
    {
        "phaazon/hop.nvim", -- Easy motion replacement (faster navigation)
        config = function()
            require("hop").setup()
            vim.keymap.set("n", "<leader>w", ":HopWord<CR>")
            vim.keymap.set("n", "<leader>j", ":HopLine<CR>")
            vim.keymap.set("n", "<leader>k", ":HopLineStart<CR>")
        end
    },

    -- Development
    {
        "lewis6991/gitsigns.nvim", -- Replacement for gitgutter (faster)
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                current_line_blame = true,
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    -- Navigation
                    vim.keymap.set('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, buffer = bufnr })

                    vim.keymap.set('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, buffer = bufnr })

                    -- Actions
                    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr })
                    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr })
                    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr })
                    vim.keymap.set('n', '<leader>hb', function() gs.blame_line { full = true } end, { buffer = bufnr })
                end
            })
        end
    },
    { "tpope/vim-fugitive" }, -- Git integration

    -- Programming Language Support
    { "vim-python/python-syntax" },
    { "Vimjas/vim-python-pep8-indent" },
    { "fatih/vim-go",                 build = ":GoInstallBinaries", cond = function() return vim.fn.executable("go") == 1 end }, -- Only load if Go is installed

    -- LSP, Completion & Snippets
    {
        "williamboman/mason.nvim", -- LSP/DAP/Linter manager
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim", -- Bridge mason and lspconfig
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "lua_ls", "html", "cssls", "jsonls" }, -- Removed gopls to avoid errors
                automatic_installation = true,
            })
        end
    },
    { "neovim/nvim-lspconfig" },  -- LSP configuration
    {
        "nvimtools/none-ls.nvim", -- Formatting and linting (newer fork of null-ls)
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.diagnostics.flake8,
                    null_ls.builtins.diagnostics.eslint,
                },
            })

            -- Format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                callback = function()
                    vim.lsp.buf.format({ timeout_ms = 2000 })
                end,
            })
        end
    },

    -- Completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "rafamadriz/friendly-snippets" }, -- Additional snippets

    -- UI
    { "folke/tokyonight.nvim" },                            -- Modern colorscheme
    { "catppuccin/nvim",             name = "catppuccin" }, -- Modern colorscheme
    { "tomasiser/vim-code-dark" },
    { "morhetz/gruvbox" },
    { "rakr/vim-one" },
    { "joshdick/onedark.vim" },

    -- Dev Tools
    { "preservim/tagbar" },
    { "windwp/nvim-autopairs",       config = function() require("nvim-autopairs").setup() end }, -- Better auto-pairs
    { "numToStr/Comment.nvim",       config = function() require("Comment").setup() end },        -- Better commenting
    { "kylechui/nvim-surround",      config = function() require("nvim-surround").setup() end },  -- Better surround

    -- Utilities
    {
        "folke/trouble.nvim", -- Better error display
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup()
            vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<CR>")
            vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<CR>")
            vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<CR>")
        end
    },
    {
        "folke/todo-comments.nvim", -- Highlight TODO comments
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup()
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim", -- Indentation guides
        main = "ibl",
        config = function()
            require("ibl").setup()
        end
    }
})

-- LSP Setup
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Global LSP keybindings
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

-- Configure LSP servers manually to prevent errors
lspconfig.pyright.setup({
    capabilities = capabilities,
})

-- Only setup gopls if Go is installed
if vim.fn.executable("go") == 1 then
    lspconfig.gopls.setup({
        capabilities = capabilities,
    })
end

lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" } -- Recognize vim global
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
            telemetry = { enable = false }
        }
    }
})

lspconfig.html.setup({
    capabilities = capabilities,
})

lspconfig.cssls.setup({
    capabilities = capabilities,
})

lspconfig.jsonls.setup({
    capabilities = capabilities,
})

-- Setup TypeScript server separately
if vim.fn.executable("npm") == 1 then
    lspconfig.tsserver.setup({
        capabilities = capabilities,
    })
end

-- Completion
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
    }),
    sources = {
        { name = "copilot",  priority = 1100 },
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip",  priority = 750 },
        { name = "buffer",   priority = 500 },
        { name = "path",     priority = 250 },
    },
    formatting = {
        format = function(entry, vim_item)
            -- Set a max length for the menu item text
            local MAX_LABEL_WIDTH = 50
            if vim_item.abbr and #vim_item.abbr > MAX_LABEL_WIDTH then
                vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, MAX_LABEL_WIDTH) .. "..."
            end
            -- Add source info
            vim_item.menu = ({
                copilot = "[Copilot]",
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end,
    },
})

-- Use buffer source for / and ? (if you enabled native_menu, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled native_menu, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "html", "css", "json", "yaml", "markdown" },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.bo.tabstop = 8
        vim.bo.softtabstop = 8
        vim.bo.shiftwidth = 8
        vim.bo.expandtab = false
    end
})

-- Trim trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end
})

-- Theme
vim.cmd("colorscheme codedark") -- VSCode-like theme

-- Configure lualine with VSCode colors
require('lualine').setup {
    options = {
        theme = 'codedark',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    }
}

-- Configure bufferline with VSCode-like appearance
require("bufferline").setup({
    options = {
        separator_style = "thin",
        always_show_bufferline = true,
        indicator = {
            style = 'underline'
        },
        modified_icon = '●',
        buffer_close_icon = '',
        show_close_icon = false,
    },
    highlights = {
        fill = {
            bg = '#1E1E1E'
        }
    }
})

-- Create swap/backup/undo dirs if missing
for _, dir in ipairs({ swapdir, backupdir, undodir }) do
    local success, error_msg = pcall(function()
        vim.fn.mkdir(dir, "p")
    end)
    if not success then
        print("Failed to create directory " .. dir .. ": " .. error_msg)
    end
end
