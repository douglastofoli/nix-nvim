{config, ...}: {
  flake.nixNvimModules.plugins.debug.dap = {
    imports = [config.flake.nixNvimModules.plugin];

    enable = true;

    pluginNames = [
      "nvim-dap"
      "nvim-dap-ui"
      "nvim-dap-virtual-text"
      "nvim-nio"
    ];

    extraPackageNames = ["elixir-ls"];

    extraLua = ''
      -- Resolve through the Nix wrapper's runtime PATH; no adapter downloads.
      local adapter = vim.fn.exepath("elixir-debug-adapter")
      assert(adapter ~= "", "nix-nvim: elixir-debug-adapter missing; rebuild with elixir-ls")

      local dap = NixNvim.safe_require("dap")
      local dapui = NixNvim.safe_require("dapui")
      local dap_virtual_text = NixNvim.safe_require("nvim-dap-virtual-text")

      if dapui then
        dapui.setup({})
      end

      if dap_virtual_text then
        dap_virtual_text.setup({})
      end

      if dap then
        dap.adapters.mix_task = {
          type = "executable",
          command = adapter,
          args = {},
        }
        dap.configurations.elixir = {
          {
            type = "mix_task",
            name = "mix test",
            request = "launch",
            task = "test",
            taskArgs = { "--trace" },
            startApps = true,
            projectDir = function()
              local root = vim.fs.root(0, "mix.exs")
              assert(root, "nix-nvim: open a file inside a Mix project before debugging")
              return root
            end,
            requireFiles = { "test/**/test_helper.exs", "test/**/*_test.exs" },
          },
        }
      end

      if dap and dapui then
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end
      end
    '';

    keymaps = {
      nnoremap = [
        {
          lhs = "<leader>db";
          rhsLua = "function() local dap = NixNvim.safe_require('dap'); if dap then dap.toggle_breakpoint() end end";
          opts = {desc = "Toggle breakpoint";};
        }
        {
          lhs = "<leader>dc";
          rhsLua = "function() local dap = NixNvim.safe_require('dap'); if dap then dap.continue() end end";
          opts = {desc = "Continue";};
        }
        {
          lhs = "<leader>di";
          rhsLua = "function() local dap = NixNvim.safe_require('dap'); if dap then dap.step_into() end end";
          opts = {desc = "Step into";};
        }
        {
          lhs = "<leader>do";
          rhsLua = "function() local dap = NixNvim.safe_require('dap'); if dap then dap.step_over() end end";
          opts = {desc = "Step over";};
        }
        {
          lhs = "<leader>dO";
          rhsLua = "function() local dap = NixNvim.safe_require('dap'); if dap then dap.step_out() end end";
          opts = {desc = "Step out";};
        }
        {
          lhs = "<leader>dr";
          rhsLua = "function() local dap = NixNvim.safe_require('dap'); if dap then dap.repl.open() end end";
          opts = {desc = "Open REPL";};
        }
        {
          lhs = "<leader>du";
          rhsLua = "function() local dapui = NixNvim.safe_require('dapui'); if dapui then dapui.toggle() end end";
          opts = {desc = "Toggle DAP UI";};
        }
      ];
    };
  };
}
