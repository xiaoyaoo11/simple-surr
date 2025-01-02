local M = {}

local default_keymaps = {
    surround_selection = "<leader>s",
    surround_word = "<leader>sw",
}

function M.setup(opts)
    opts = opts or {}
    local keymaps = vim.tbl_extend("force", default_keymaps, opts.keymaps or {})

    vim.keymap.set("v", keymaps.surround_selection, function()
        local style = vim.fn.input("Enter surround style (e.g., [, {, (, }, ', \", `, custom): ")
        local add_space = vim.fn.input("Add spaces inside? (y/n): ") == "y"
        require("simple-surr.surround").surround_selection(style, add_space)
    end, { desc = "Surround selection with custom or predefined style" })

    vim.keymap.set("n", keymaps.surround_word, function()
        local style = vim.fn.input("Enter surround style (e.g., [, {, (, }, ', \", `, custom): ")
        local add_space = vim.fn.input("Add spaces inside? (y/n): ") == "y"
        require("simple-surr.surround").surround_word(style, add_space)
    end, { desc = "Surround word under cursor with custom or predefined style" })
end

return M
