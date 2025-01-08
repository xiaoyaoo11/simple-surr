# Simple Surround Plugin

This Neovim plugin provides a simple way to surround selected text or the word under the cursor with custom or predefined styles. It also includes functionality to remove or change surrounding characters.
But it is just fit with my needs (simple), if you find alternative to it, please use.
(I will add more functions that I think I need to use while surrounding text. Such as: surround a line, selected text after spliting by specified character, for instance: ",")

## Features

- Surround selected text or the word under the cursor with various styles such as `()`, `{}`, `[]`, `""`, `''`, and more.
- Supports custom styles with one or two characters.
- Remove or change the existing surrounding style.
- Toggle surround for selections.
- Fully customizable keymaps.

## DEMO
(TODO)

## Installation

### Using Packer

To install this plugin using [packer.nvim](https://github.com/wbthomason/packer.nvim), add the following to your `plugins.lua` or equivalent:

```lua
use {
    'kunkka19xx/simple-surr',
    config = function()
        require('simple-surr').setup {
            keymaps = {
                surround_selection = "<leader>s",       -- Keymap for surrounding selection
                surround_word = "<leader>sw",          -- Keymap for surrounding word
                remove_or_change_surround_word = "<leader>sr", -- Keymap for removing/changing surrounding word
                toggle_or_change_surround_selection = "<leader>ts", -- Keymap for removing/changing surrounding selected text
            }
        }
    end
}
```

### Using Lazy

```lua
return {
    'kunkka19xx/simple-surr',
    config = function()
        require("simple-surr").setup {
            keymaps = {
                surround_selection = "<leader>s",       -- Keymap for surrounding selection
                surround_word = "<leader>sw",          -- Keymap for surrounding word
                remove_or_change_surround_word = "<leader>sr", -- Keymap for removing/changing surrounding word
                toggle_or_change_surround_selection = "<leader>ts", -- Keymap for removing/changing surrounding selected text
            },
        }
    end,
}
```

## Setup

The plugin can be configured using the `setup` function. You can override the default keymaps:

```lua
require('simple-surr').setup {
    keymaps = {
        surround_selection = "<leader>s",       -- Keymap for surrounding selection
        surround_word = "<leader>sw",          -- Keymap for surrounding word
        remove_or_change_surround_word = "<leader>sr" -- Keymap for removing/changing surrounding word
    }
}
```

If no configuration is provided, the plugin will use the default keymaps:

- `<leader>s`: Surround selected text.
- `<leader>sw`: Surround the word under the cursor.
- `<leader>sr`: Remove or change the surrounding style of a word.

## Usage

### Surround Selected Text

1. Visually select the text you want to surround.
2. Press `<leader>s` (or your configured keymap).
3. Enter the desired surround style (e.g., `(`, `{`, `[`, `'`, `"`, `\``, or custom styles like `<>`).
4. (Optional) Add spaces inside the surrounding characters by typing `y` when prompted.

### Surround Word Under Cursor

1. Place the cursor on the word you want to surround.
2. Press `<leader>sw` (or your configured keymap).
3. Enter the desired surround style.
4. (Optional) Add spaces inside the surrounding characters by typing `y` when prompted.

### Remove or Change Surround Style

1. Place the cursor on the word you want to modify.
2. Press `<leader>sr` (or your configured keymap).
3. Enter the new surround style or leave it blank to remove the existing surrounding characters.

### Toggle Surround for Selection

1. Visually select the text you want to toggle or change the surround for.
2. Press `<leader>ts` (or your configured keymap).
3. Enter the new surround style or leave it blank to remove the existing surrounding characters.

## Customization

You can customize the predefined surround pairs by editing the `surround_pairs` table in the plugin's code:

```lua
M.surround_pairs = {
    ["("] = { "(", ")" },
    ["{"] = { "{", "}" },
    ["["] = { "[", "]" },
    ["'"] = { "'", "'" },
    ["\""] = { '"', '"' },
    [">"] = { "<", ">" },
    ["`"] = { "`", "`" },
}
```

## License

This plugin is released under the MIT License.
