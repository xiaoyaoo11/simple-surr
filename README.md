# MySurround.nvim

A simple Neovim plugin for surrounding text with custom or predefined styles.

## Features

- Surround selected text or word under the cursor with pairs like `()`, `{}`, `""`, etc.
- Add spaces inside surround characters if needed.
- Support for custom surround pairs (e.g., `<` or `` ` ``).

## Installation

Using [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "kunkka19xx/simple-surr.nvim",
    config = function()
        require("simple-surr").setup()
    end,
}
```

## Configuration

You can customize the keymaps by passing a `keymaps` table to the `setup` function:

```lua
require("mysurround").setup({
    keymaps = {
        surround_selection = "<leader>ss", -- Keymap for surrounding selection
        surround_word = "<leader>sw",     -- Keymap for surrounding word
    }
})
```
