return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    config = function()
      -- vim.g.copilot_proxy = 'http://sysproxy.wal-mart.com:8080'
      require('copilot').setup {
        panel = {
          enabled = false,
        },
        suggestions = {
          enabled = false,
        },
      }
    end,
  },
}
