local M = {}

M.setup_keymaps = function()
    vim.keymap.set("v", "<leader>s", function()
        local style = vim.fn.input("Enter surround style (e.g., [, {, (, }, ', \", `, custom): ")
        require("simple-surr.surround").surround_selection(style)
    end, { desc = "Surround selection with custom or predefined style" })

    vim.keymap.set("n", "<leader>sw", function()
        local style = vim.fn.input("Enter surround style (e.g., [, {, (, }, ', \", `, custom): ")
        require("simple-surr.surround").surround_word(style)
    end, { desc = "Surround word under cursor with custom or predefined style" })

    vim.keymap.set("n", "<leader>sr", function()
        local change = vim.fn.input("Change surround style (leave empty to remove): ")
        if change == "" then
            require("simple-surr.surround").remove_or_change_surround_word()
        else
            require("simple-surr.surround").remove_or_change_surround_word(change)
        end
    end, { desc = "Remove or change surround style of word" })

    vim.keymap.set("v", "<leader>ts", function()
        local style =
            vim.fn.input("Enter surround style (e.g., [, {, (, }, ', \", `, custom, or leave blank to remove): ")
        require("simple-surr.surround").toggle_or_change_surround_selection(style)
    end, { desc = "Toggle or change surround selection with custom or predefined style" })
end

return M
