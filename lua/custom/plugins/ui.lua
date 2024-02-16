return {

	-- colorscheme
	{ 'navarasu/onedark.nvim' },
	{
		'catppuccin/nvim',
		priority = 1000,
		config = function()
			vim.g.everforest_backgroun = 'hard'
			vim.cmd.colorscheme 'catppuccin'
		end,
	},

	-- Alpha Dashboard
	{
		'goolord/alpha-nvim',
		dependencies = { 'MaximilianLloyd/ascii.nvim' },
		event = 'VimEnter',
		opts = function()
			local ascii = require 'ascii.text'
			local dashboard = require 'alpha.themes.dashboard'
			dashboard.section.header.val = ascii.neovim.dos_rebel
			dashboard.section.buttons.val = {
				dashboard.button('f', ' ' .. 'Find File', ':Telescope find_files <CR>'),
				dashboard.button('r', ' ' .. ' Recent files', ':Telescope oldfiles <CR>'),
				dashboard.button('g', ' ' .. ' Find text', ':Telescope live_grep <CR>'),
				dashboard.button('c', ' ' .. ' Config', ':e $MYVIMRC <CR>'),
				dashboard.button('l', '鈴' .. ' Lazy', ':Lazy<CR>'),
				dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
			}
			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = 'AlphaButtons'
				button.opts.hl_shortcut = 'AlphaShortcut'
			end
			dashboard.section.footer.opts.hl = 'Type'
			dashboard.section.header.opts.hl = 'AlphaHeader'
			dashboard.section.buttons.opts.hl = 'AlphaButtons'
			dashboard.opts.layout[1].val = 8
			return dashboard
		end,
		config = function(_, dashboard)
			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == 'lazy' then
				vim.cmd.close()
				vim.api.nvim_create_autocmd('User', {
					pattern = 'AlphaReady',
					callback = function()
						require('lazy').show()
					end,
				})
			end

			require('alpha').setup(dashboard.opts)
			--
			vim.api.nvim_create_autocmd('User', {
				pattern = 'LazyVimStarted',
				callback = function()
					local stats = require('lazy').stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},

	{
		'akinsho/bufferline.nvim',
		event = 'VeryLazy',
		opts = {
			options = {
				diagnostics = 'nvim_lsp',
				always_show_bufferline = false,
				offsets = {
					{
						filetype = 'neo-tree',
						text = 'Neo-tree',
						highlight = 'Directory',
						text_align = 'left',
					},
				},
			},
		},
	},

	{
		'echasnovski/mini.bufremove',
		event = 'VeryLazy',
		-- stylua: ignore
		keys = {
			{ "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
			{
				"<leader>bD",
				function() require("mini.bufremove").delete(0, true) end,
				desc =
				"Delete Buffer (Force)"
			},
		},
	},

	-- Trouble + TODO
	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		event = 'VeryLazy',
		config = true,
		keys = {
			{ '<leader>xt', '<cmd>TodoTrouble<cr>',   'Show Trouble' },
			{ '<leader>st', '<cmd>TodoTelescope<cr>', 'Show TODOs' },
		},
	},
	{
		'folke/trouble.nvim',
		config = true,
		event = 'VeryLazy',
	},
	{
		'iamcco/markdown-preview.nvim',
		cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
		build = 'cd app && npm install',
		init = function()
			vim.g.mkdp_filetypes = { 'markdown' }
		end,
		ft = { 'markdown' },
	},
}
