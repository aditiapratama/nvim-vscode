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

-- vscode-multi-cursor
return{
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

            vim.keymap.set('n', '<c-d>', 'mciw*:nohl<cr>', {
                remap = true
            })

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
}