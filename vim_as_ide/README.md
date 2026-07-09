---
status: active
category: youtube
stack: neovim, lua, JS/TS
---

# vim_as_ide

Навчання vim/neovim з нуля з метою перетворити його на робочий редактор для JS/TS — контент для відео про термінал.

## where I left off

Встановив Neovim (`brew install neovim`) — раніше не було взагалі. Написав мінімальний `init.lua`: базові sensible defaults під JS/TS (2-space indent, number/relativenumber, пошук, clipboard, undofile) + bootstrap `lazy.nvim` як плагін-менеджер, поки без жодних плагінів. Перевірив, що конфіг стартує без помилок (`nvim --headless`).

## next step

Додати перший реальний плагін через `lazy.nvim` — почати з file explorer (`nvim-tree` або `oil.nvim`) або fuzzy finder (`telescope.nvim`), щоб було зручно ходити по JS/TS проєкту.

## resources

- https://neovim.io/doc/
- https://github.com/folke/lazy.nvim
- `:help lua-guide` (вбудований довідник по конфігурації через Lua)
