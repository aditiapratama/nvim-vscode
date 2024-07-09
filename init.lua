-- Copyright (C) 2024 Aditia A. Pratama | aditia.ap@gmail.com
--
-- This file is part of nvim-vscode.
--
-- nvim-vscode is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- nvim-vscode is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with nvim-vscode.  If not, see <https://www.gnu.org/licenses/>.

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)
-- sync system clipboard
vim.opt.clipboard = 'unnamedplus'
-- search ignoring case
vim.opt.ignorecase = true
-- disable "ignorecase" option if the search pattern contains upper case characters
vim.opt.smartcase = true
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    {
      "vscode-neovim/vscode-multi-cursor.nvim",
      event = "VeryLazy",
      opts = function ()
      vim.api.nvim_set_hl(0, 'VSCodeCursor', {
          bg = '#542fa4',
          fg = 'white',
          default = true
      })

      vim.api.nvim_set_hl(0, 'VSCodeCursorRange', {
      bg = '#542fa4',
      fg = 'white',
      default = true
      })

      local cursors = require('vscode-multi-cursor')
      vim.keymap.set({"n", "x", "i"}, "<c-d>", function()
        cursors.addSelectionToNextFindMatch()
      end)

      vim.keymap.set({"n", "x", "i"}, "<cs-d>", function()
        cursors.addSelectionToPreviousFindMatch()
      end)

      vim.keymap.set({"n", "x", "i"}, "<cs-l>", function()
        cursors.selectHighlights()
      end)

      vim.keymap.set('n', '<c-d>', 'mciw*:nohl<cr>', { remap = true })
      end
    },
    {
      "folke/flash.nvim",
      opts=function ()
        vim.api.nvim_set_hl(0, 'FlashLabel', {
            bg = '#e11684',
            fg = 'white'
        })

        vim.api.nvim_set_hl(0, 'FlashMatch', {
            bg = '#7c634c',
            fg = 'white'
        })

        vim.api.nvim_set_hl(0, 'FlashCurrent', {
            bg = '#7c634c',
            fg = 'white'
        })
      end
    }
    -- add your plugins here
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.cmd([[
    function! s:manageEditorSize(...)
        let count = a:1
        let to = a:2
        for i in range(1, count ? count : 1)
            call VSCodeNotify(to == 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
        endfor
    endfunction

    function! s:vscodeCommentary(...) abort
        if !a:0
            let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
            return 'g@'
        elseif a:0 > 1
            let [line1, line2] = [a:1, a:2]
        else
            let [line1, line2] = [line("'["), line("']")]
        endif

        call VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
    endfunction

    function! s:openVSCodeCommandsInVisualMode()
        normal! gv
        let visualmode = visualmode()
        if visualmode == "V"
            let startLine = line("v")
            let endLine = line(".")
            call VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
        else
            let startPos = getpos("v")
            let endPos = getpos(".")
            call VSCodeNotifyRangePos("workbench.action.showCommands", startPos[1], endPos[1], startPos[2], endPos[2], 1)
        endif
    endfunction

    function! s:openWhichKeyInVisualMode()
        normal! gv
        let visualmode = visualmode()
        if visualmode == "V"
            let startLine = line("v")
            let endLine = line(".")
            call VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
        else
            let startPos = getpos("v")
            let endPos = getpos(".")
            call VSCodeNotifyRangePos("whichkey.show", startPos[1], endPos[1], startPos[2], endPos[2], 1)
        endif
    endfunction

    nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
    xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
    nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
    xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
    nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
    xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

    nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>

    xnoremap <expr> <C-/> <SID>vscodeCommentary()
    nnoremap <expr> <C-/> <SID>vscodeCommentary() . '_'

    nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

    nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
    xnoremap <silent> <Space> :<C-u>call <SID>openWhichKeyInVisualMode()<CR>

    xnoremap <silent> <C-P> :<C-u>call <SID>openVSCodeCommandsInVisualMode()<CR>

    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine

    nmap <Tab> :Tabnext<CR>
    nmap <S-Tab> :Tabprev<CR>
]])
