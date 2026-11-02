-- Configure LSP clients

-- Set default root markers for all clients
vim.lsp.config("*", {
    root_markers = { ".git" },
})

-- LSP clients
local servers = {
    clangd = {
        cmd = { "clangd" },
        filetypes = { "c", "cpp" },
    },
    tsc = {
        cmd = { "tsc", "--lsp", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        rootmarkers = { "package.json", "tsconfig.json", ".git" }
    },
    tailwindcss = {
        cmd = { "tailwindcss-language-server" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        rootmarkers = { "package.json", "tsconfig.json", ".git" }
    },
    --svelte = {
    --    cmd = { "svelteserver", "--stdio" },
    --    filetypes = { "svelte" },
    --},
    gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_markers = { "go.work", "go.mod", ".git" },
        settings = {
            gopls = {
                semanticTokens = true,
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
            },
        },
    },
    lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false },
            },
        },
    },
   --  basedpyright = {
   --      cmd = { "basedpyright-langserver", "--stdio" },
   --      filetypes = { "python" },
   --      root_markers = { "pyproject.toml", "setup.py", "pyrightconfig.json", ".git" },
   --      settings = {
   --          basedpyright = {
   --              analysis = {
   --                  autoSearchPaths = true,
   --                  useLibraryCodeForTypes = true,
   --                  diagnosticMode = "workspace",
   --              },
   --          },
   --      },
   --      before_init = function(_, config)
   --          local venv = (config.root_dir or "") .. "/.venv"
   --          local python = venv .. "/bin/python"
   --          if vim.fn.executable(python) == 1 then
   --              config.settings = config.settings or {}
   --              config.settings.python = { pythonPath = python }
   --              local venv_bp = venv .. "/bin/basedpyright-langserver"
   --              if vim.fn.executable(venv_bp) == 1 then
   --                  config.cmd = { venv_bp, "--stdio" }
   --              end
   --          end
   --      end,
   --  },
   html = {
       cmd = { "vscode-html-language-server", "--stdio" },
       filetypes = { "html" },
   },
   cssls = {
       cmd = { "vscode-css-language-server", "--stdio" },
       filetypes = { "css" },
   },
   -- tailwindcss = {
   --     cmd = { "tailwindcss-language-server", "--stdio" },
   --     filetypes = {
   --         "html",
   --         "razor",
   --         "typescriptreact",
   --         "typescript",
   --         "javascript",
   --         "javascriptreact",
   --     },
   -- },
    --rust_analyzer = {
    --    cmd = { "rust-analyzer" },
    --    filetypes = { "rust" },
    --},
    --tinymist = {
    --    cmd = { "tinymist" },
    --    filetypes = { "typst" },
    --},
}

-- Enable the LSPs
for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end

-- Setup buffer-local LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf

        -- Clear unwanted defaults
        vim.bo[bufnr].formatexpr = nil
        vim.bo[bufnr].omnifunc = nil

        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Go to definition
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        -- Hover documentation
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        -- Rename symbol
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        -- Code actions
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        -- Show references
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        -- Implementation
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        -- Type definition
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        -- Signature help
        vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
        -- Diagnostics
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        -- Trigger completion manually (<M-i> in insert mode shows completions)
        vim.keymap.set("i", "<M-i>", function()
            local ok, cmp = pcall(require, "blink.cmp")
            if ok then cmp.show() end
        end, opts)
    end,
})
