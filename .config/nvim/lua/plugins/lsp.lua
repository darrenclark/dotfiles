return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neodev.nvim", opts = { pathStrict = true } },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp"
    },
    keys = {
      { "<leader>ee", vim.lsp.buf.rename, desc = "Rename", mode = "n" },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "" },
        severity_sort = true,
      },
      diagnosticColors = {
        DiagnosticError = "#990000",
        DiagnosticWarn = "#cc9900",
      },
      servers = {
        clangd = {
          -- use system installed clangd (for now)
          mason = false,
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        },
        clojure_lsp = {
          on_attach = function(client, bufnr)
            local name = vim.api.nvim_buf_get_name(bufnr)
            if string.find(name, "conjure%-log") then
              vim.lsp.buf_detach_client(bufnr, client.id)
            end
          end
        },
        elp = {}, -- erlang
        gopls = {},
        jsonls = {},
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              telemetry = {
                enabled = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        ocamllsp = {},
        omnisharp = {},
        nim_langserver = {
          -- intalled via ./install.sh
          mason = false,
        },
        pyright = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
            },
          },
        },
        tilt_ls = {
          -- tilt installed via brewfile
          mason = false,
        },
        -- YAML
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                kubernetes = "*.{yml,yaml}",
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
                "*api*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                "*docker-compose*.{yml,yaml}",
                ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
                "*flow*.{yml,yaml}",
              },
            },
          },
        },
        -- Zig
        zls = {},
      },
      setup = {}
    },
    config = function(_, opts)
      -- Diagnostic configuration
      vim.diagnostic.config(opts.diagnostics)
      for hl, color in pairs(opts.diagnosticColors) do
        vim.cmd("highlight " .. hl .. " guifg=" .. color)
      end
      local signToHl = {
        DiagnosticSignError = 'DiagnosticError',
        DiagnosticSignWarn = 'DiagnosticWarn',
        DiagnosticSignInfo = 'DiagnosticInfo',
        DiagnosticSignHint = 'DiagnosticHint',
      }
      for sign, hl in pairs(signToHl) do
        vim.cmd("sign define " .. sign .. " text= numhl=" .. hl)
      end

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available thourgh mason-lspconfig
      local mlsp = require("mason-lspconfig")
      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      mlsp.setup({ ensure_installed = ensure_installed })
      mlsp.setup_handlers({ setup })
    end
  },
  {
    "williamboman/mason.nvim",
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)
    end
  }
}
