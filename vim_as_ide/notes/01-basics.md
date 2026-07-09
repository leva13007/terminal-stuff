# 01 — з нуля до мінімального конфіга

## стартова точка

Vim у дефолтному стані, без жодних налаштувань. Ціль — писати JS/TS код.

## vim чи neovim?

Обрав **Neovim**: нативний LSP-клієнт з коробки (не треба окремого плагіна на кшталт `coc.nvim`), Lua замість Vimscript для конфіга, більшість сучасних JS/TS туторіалів і плагінів орієнтовані саме на nvim.

Встановлення (macOS):

```bash
brew install neovim
```

Конфіг живе в `~/.config/nvim/init.lua` (раніше директорії не було).

## мінімальний init.lua

Що поклав у базу:

- **indentation**: `expandtab`, `shiftwidth=2`, `tabstop=2` — стандарт для JS/TS
- **editing**: `number` + `relativenumber`, `scrolloff`, `signcolumn=yes`, `undofile` (постійний undo між сесіями)
- **search**: `ignorecase` + `smartcase`, `incsearch`, `hlsearch`
- **ui**: `termguicolors`, `mouse=a`, `clipboard=unnamedplus` (спільний буфер з системою), спліти вправо/вниз

Свідомо **не** ставив жодного плагіна з функціоналом — тільки bootstrap `lazy.nvim` (менеджер плагінів), щоб у наступному відео було з чого рости.

## lazy.nvim bootstrap

Стандартний патерн: якщо `lazy.nvim` не склонований у `stdpath("data")/lazy/lazy.nvim` — клонувати його при старті, додати в `runtimepath`, викликати `require("lazy").setup({})` з порожнім списком плагінів.

Перевірка, що все стартує без помилок:

```bash
nvim --headless -c 'lua print("plugins:", #require("lazy").plugins())' -c 'qa'
```

## наступного разу

Перший реальний плагін — файловий провідник (`nvim-tree`/`oil.nvim`) або `telescope.nvim` для fuzzy-пошуку по файлах.
