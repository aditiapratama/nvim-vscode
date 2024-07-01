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

-- open config
vim.cmd('nmap <leader>c :e ~/.config/nvim/init.lua<cr>')

-- save
vim.cmd('nmap <leader>s :w<cr>')

-- motion keys (left, down, up, right)
vim.keymap.set({'n', 'v'}, 'j', 'h')
vim.keymap.set({'n', 'v'}, 'k', 'j')
vim.keymap.set({'n', 'v'}, 'l', 'k')
vim.keymap.set({'n', 'v'}, ';', 'l')

-- repeat previous f, t, F or T movement
vim.keymap.set('n', '\'', ';')

-- paste without overwriting
vim.keymap.set('v', 'p', 'P')

-- redo
vim.keymap.set('n', 'U', '<c-r>')

-- clear search highlighting
vim.keymap.set('n', '<esc>', ':nohlsearch<cr>')

-- skip folds (down, up)
vim.cmd('nmap k gj')
vim.cmd('nmap l gk')

-- sync system clipboard
vim.opt.clipboard = 'unnamedplus'

-- search ignoring case
vim.opt.ignorecase = true

-- disable "ignorecase" option if the search pattern contains upper case characters
vim.opt.smartcase = true

-- Function to manage editor size (optional, depending on usage)
vim.cmd([[
    function! s:manageEditorSize(...)
        let count = a:1
        let to = a:2
        for i in range(1, count ? count : 1)
            call VSCodeNotify(to == 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
        endfor
    endfunction
]])

vim.cmd([[
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
]])

vim.cmd([[
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
]])

vim.cmd([[
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
]])

-- Improved navigation mappings
vim.cmd("nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>")
vim.cmd("xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>")
vim.cmd("nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>")
vim.cmd("xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>")
vim.cmd("nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>")
vim.cmd("xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>")
vim.cmd("nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>")
vim.cmd("xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>")

vim.cmd("nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>")

vim.cmd("xnoremap <expr> <C-/> <SID>vscodeCommentary()")
vim.cmd("nnoremap <expr> <C-/> <SID>vscodeCommentary() . '_'")

vim.cmd("nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>")
vim.cmd("nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>")
vim.cmd("xnoremap <silent> <Space> :<C-u>call <SID>openWhichKeyInVisualMode()<CR>")
vim.cmd("xnoremap <silent> <C-P> :<C-u>call <SID>openVSCodeCommandsInVisualMode()<CR>")
vim.cmd("xmap gc  <Plug>VSCodeCommentary")
vim.cmd("nmap gc  <Plug>VSCodeCommentary")
vim.cmd("omap gc  <Plug>VSCodeCommentary")
vim.cmd("nmap gcc <Plug>VSCodeCommentaryLine")

vim.cmd("nmap <Tab> :Tabnext<CR>")
vim.cmd("nmap <S-Tab> :Tabprev<CR>")