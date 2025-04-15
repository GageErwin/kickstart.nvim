return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    keys = {
      {
        '<leader>-',
        '<cmd>Oil<cr>',
        desc = 'Oil',
      },
    },
    -- dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  {
    'akinsho/bufferline.nvim',
    lazy = false,
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        always_show_bufferline = false,
      },
    },
    keys = {
      {
        '<S-h>',
        '<cmd>BufferLineCyclePrev<cr>',
      },
      {
        '<S-l>',
        '<cmd>BufferLineCycleNext<cr>',
      },
      {
        '<leader>bd',
        function()
          require('mini.bufremove').delete(0, false)
        end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>bD',
        function()
          require('mini.bufremove').delete(0, true)
        end,
        desc = 'Delete Buffer (Force)',
      },
    },
  },
}
