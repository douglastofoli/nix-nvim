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

    extraLua = ''
      local dap = NixNvim.safe_require("dap")
      local dapui = NixNvim.safe_require("dapui")
      local dap_virtual_text = NixNvim.safe_require("nvim-dap-virtual-text")

      if dapui then
        dapui.setup({})
      end

      if dap_virtual_text then
        dap_virtual_text.setup({})
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
