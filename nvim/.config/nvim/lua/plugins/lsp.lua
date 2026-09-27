return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- {
      --   "williamboman/mason.nvim",
      --   config = true,
      -- },
      -- {
      --   "williamboman/mason-lspconfig.nvim",
      -- },
      -- {
      --   "WhoIsSethDaniel/mason-tool-installer.nvim"
      -- },
      {
        "folke/neodev.nvim",
        opts = {},
      },
      {
        'j-hui/fidget.nvim',
        opts = {}
      },
    },
    config = function ()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { buffer = event.buf, desc = "Hover" })
          vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { buffer = event.buf, desc = "Go to definition" })
--           map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
--           map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "Go to declaration" })
--           map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { buffer = event.buf, desc = "Go to implementation" })
--           map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
--           map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--           map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          vim.keymap.set("n", "<leader>ls", require("telescope.builtin").lsp_document_symbols, { buffer = event.buf, desc = "Document [S]ymbols" })
--           map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Code [A]ction" })
        end,
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
        end
      })
      -- require("mason").setup()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      local servers = {
        ['ada-language-server'] = {},
        clangd = {},
        cobol_ls = {},
        -- hls = {},
        julials = {},
        lua_ls = {},
        nimlangserver = {},
        gopls = {},
        ocamllsp = {},
        pyright = {},
        rust_analyzer = {},
        texlab = {},
      }
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "bibtex-tidy",
        "latexindent",
      })
      -- require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      -- require('mason-lspconfig').setup {
      --   handlers = {
      --     function(server_name)
      --       local server = servers[server_name] or {}
      --       -- This handles overriding only values explicitly passed
      --       -- by the server configuration above. Useful when disabling
      --       -- certain features of an LSP (for example, turning off formatting for tsserver)
      --       server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      --       require('lspconfig')[server_name].setup(server)
      --     end,
      --   },
      -- }
      if vim.fn.executable("haskell-language-server") == 1 then
        require("lspconfig").hls.setup({})
      end
    end,
  }
}





--     config = function()
--       vim.api.nvim_create_autocmd('LspAttach', {
--         callback = function(event)
--           -- The following two autocommands are used to highlight references of the
--           -- word under your cursor when your cursor rests there for a little while.
--           --    See `:help CursorHold` for information about when this is executed
--           --
--           -- When you move your cursor, the highlights will be cleared (the second autocommand).
--           local client = vim.lsp.get_client_by_id(event.data.client_id)
--           if client and client.server_capabilities.documentHighlightProvider then
--             local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
--             vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--               buffer = event.buf,
--               group = highlight_augroup,
--               callback = vim.lsp.buf.document_highlight,
--             })
--
--             vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--               buffer = event.buf,
--               group = highlight_augroup,
--               callback = vim.lsp.buf.clear_references,
--             })
--
--             vim.api.nvim_create_autocmd('LspDetach', {
--               group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
--               callback = function(event2)
--                 vim.lsp.buf.clear_references()
--                 vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
--               end,
--             })
--           end
--
--           -- The following autocommand is used to enable inlay hints in your
--           -- code, if the language server you are using supports them
--           --
--           -- This may be unwanted, since they displace some of your code
--           if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
--             map('<leader>th', function()
--               vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
--             end, '[T]oggle Inlay [H]ints')
--           end
--         end,
--       })
--
--       -- LSP servers and clients are able to communicate to each other what features they support.
--       --  By default, Neovim doesn't support everything that is in the LSP specification.
--       --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--       --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
--       local capabilities = vim.lsp.protocol.make_client_capabilities()
--       capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
--
--       -- Enable the following language servers
--       --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--       --
--       --  Add any additional override configuration in the following tables. Available keys are:
--       --  - cmd (table): Override the default command used to start the server
--       --  - filetypes (table): Override the default list of associated filetypes for the server
--       --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--       --  - settings (table): Override the default settings passed when initializing the server.
--       --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--
--
--     end,
--   }
