return {
  "stevearc/oil.nvim",
  lazy = false,
  ---@module 'oil'
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  config = function()
    local oil = require("oil")
    oil.setup({
      skip_confirm_for_simple_edits = true,
      hide_dotfiles = false,
      view_options = {
        show_hidden = true,
        -- Go test files are hidden unless toggled on with <leader>ot.
        is_always_hidden = function(name)
          return not vim.g.oil_show_go_tests and name:match("_test%.go$") ~= nil
        end,
      },
      float = {
        padding = 2,
        border = "single",
      },
      confirmation = {
        border = "single",
      }
    })
    vim.keymap.set("n", "_", oil.toggle_float, {})

    -- Show or hide Go test files in oil.
    vim.keymap.set("n", "<leader>ot", function()
      vim.g.oil_show_go_tests = not vim.g.oil_show_go_tests
      require("oil.view").rerender_all_oil_buffers({ refetch = false })
      vim.notify("Go test files " .. (vim.g.oil_show_go_tests and "shown" or "hidden"))
    end, { desc = "Oil: toggle Go test files" })

    -- Jump between foo.go and foo_test.go.
    vim.keymap.set("n", "<leader>a", function()
      local file = vim.api.nvim_buf_get_name(0)
      if not file:match("%.go$") then
        return
      end
      local other
      if file:match("_test%.go$") then
        other = file:gsub("_test%.go$", ".go")
      else
        other = file:gsub("%.go$", "_test.go")
      end
      if vim.fn.filereadable(other) == 0 then
        vim.notify("No such file: " .. vim.fn.fnamemodify(other, ":t"), vim.log.levels.WARN)
        return
      end
      vim.cmd.edit(vim.fn.fnameescape(other))
    end, { desc = "Go: switch between a file and its test" })
  end,
}
