return {
	{
		'mfussenegger/nvim-dap',
		event = 'VeryLazy',
		dependencies = {
			'rcarriga/nvim-dap-ui',

			'nvim-telescope/telescope-dap.nvim',
			'theHamsta/nvim-dap-virtual-text',
			'williamboman/mason.nvim',
			'jay-babu/mason-nvim-dap.nvim',

			-- Add your own debuggers here
			'mfussenegger/nvim-dap-python',
			'leoluz/nvim-dap-go',
		},
		config = function()
			local dap = require 'dap'
			local dapui = require 'dapui'

			require('mason-nvim-dap').setup {
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_setup = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
					'delve',
					'debugpy',
				},
			}
			require('nvim-dap-virtual-text').setup()
			require('dap.ext.vscode').load_launchjs()

			-- Basic debugging keymaps, feel free to change to your liking!
			vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
			vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Debug: Terminate' })
			vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
			vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step Over' })
			vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Debug: Step Out' })
			vim.keymap.set('n', '<leader>de', dapui.eval, { desc = '[D]ebug [E]val' })
			vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
			vim.keymap.set('n', '<leader>B', function()
				dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
			end, { desc = 'Debug: Set Breakpoint' })
			vim.keymap.set('n', '<leader>dl', function()
				require('dap.ext.vscode').load_launchjs()
			end, { desc = 'Load VSCode Launch' })

			-- Dap UI setup
			-- For more information, see |:help nvim-dap-ui|
			dapui.setup {
				-- Set icons to characters that are more likely to work in every terminal.
				--    Feel free to remove or use ones that you like more! :)
				--    Don't feel like these are good choices.
				icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
				controls = {
					icons = {
						pause = '⏸',
						play = '▶',
						step_into = '⏎',
						step_over = '⏭',
						step_out = '⏮',
						step_back = 'b',
						run_last = '▶▶',
						terminate = '⏹',
						disconnect = '⏏',
					},
				},
			}

			-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
			vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: See last session result.' })

			dap.listeners.after.event_initialized['dapui_config'] = dapui.open
			dap.listeners.before.event_terminated['dapui_config'] = dapui.close
			dap.listeners.before.event_exited['dapui_config'] = dapui.close

			-- Install golang specific config
			require('dap-go').setup {
				dap_configurations = {
					{
						type = 'go',
						name = 'MNS L_Dev',
						request = 'launch',
						mode = 'debug',
						env = {
							STAGE_NAME = 'localdev',
						},
						program = '${fileDirname}',
					},
					{
						type = 'go',
						name = 'MNS L_Prod',
						request = 'launch',
						mode = 'debug',
						env = {
							STAGE_NAME = 'localprod',
						},
						program = '${fileDirname}',
					},
				},
			}
			-- Install python specific config
			require('dap-python').setup 'python'
			require('telescope').load_extension 'dap'
			-- stylua: ignore
			vim.keymap.set('n', '<leader>dPt', ':lua require("dap-python").test_method()<CR>',
				{ desc = 'Debug: Test Method' })
			vim.keymap.set('n', '<leader>dGt', ':lua require("dap-go").debug_test()<CR>', { desc = 'Debug: Test Method' })
		end,
	},
}
