local M = {}

M.surround_pairs = {
    ["("] = { "(", ")" },
    [")"] = { "(", ")" },
    ["{"] = { "{", "}" },
    ["}"] = { "{", "}" },
    ["["] = { "[", "]" },
    ["]"] = { "[", "]" },
    ["'"] = { "'", "'" },
    ['"'] = { '"', '"' },
    [">"] = { "<", ">" },
    ["<"] = { "<", ">" },
    ["`"] = { "`", "`" },
}

local function parse_surround_style(style, add_space)
    local opening, closing
    if M.surround_pairs[style] then
        opening, closing = M.surround_pairs[style][1], M.surround_pairs[style][2]
    elseif #style == 1 then
        opening, closing = style, style
    elseif #style == 2 then
        opening, closing = style:sub(1, 1), style:sub(2, 2)
    else
        print("Invalid surround style! Use a listed key or one/two custom characters.")
        return nil, nil
    end

    if add_space then
        opening = opening .. " "
        closing = " " .. closing
    end

    return opening, closing
end

function M.surround_selection(style, add_space)
    local opening, closing = parse_surround_style(style, add_space)
    if not opening or not closing then
        return
    end

    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")
    local start_line = start_pos[2]
    local end_line = end_pos[2]
    if start_line == end_line then
        local line = vim.fn.getline(start_line)
        local front = line:sub(1, start_pos[3] - 1)
        local selected = line:sub(start_pos[3], end_pos[3] - 1)
        local after = line:sub(end_pos[3] + 1)

        line = front .. opening .. selected .. closing .. after
        vim.fn.setline(start_line, line)
        vim.fn.setpos(".", { start_pos[1], start_pos[2], start_pos[3] + #opening, 0 })
        vim.cmd("normal! gv")
    else
        local first_line = vim.fn.getline(start_line)
        local front = first_line:sub(1, start_pos[3] - 1)
        local selected = first_line:sub(start_pos[3])
        first_line = front .. opening .. selected
        vim.fn.setline(start_line, first_line)

        local last_line = vim.fn.getline(end_line)
        local selected_end = last_line:sub(1, end_pos[3])
        local after = last_line:sub(end_pos[3] + 1)
        last_line = selected_end .. closing .. after
        vim.fn.setline(end_line, last_line)
        vim.cmd("normal! gv")
    end
end

function M.surround_word(style, add_space)
    local opening, closing = parse_surround_style(style, add_space)
    if not opening or not closing then
        return
    end

    local word = vim.fn.expand("<cword>")
    local col_start = vim.fn.col(".")
    local new_word = opening .. word .. closing

    local current_line = vim.fn.getline(".")
    local updated_line = current_line:gsub(word, new_word, 1)

    if current_line ~= updated_line then
        vim.api.nvim_set_current_line(updated_line)
        vim.fn.cursor(0, col_start + #opening)
    end
end

function M.setup()
    vim.keymap.set("v", "<leader>s", function()
        local style = vim.fn.input("Enter surround style (e.g., [, {, (, }, ', \", `, custom): ")
        local add_space = vim.fn.input("Add spaces inside? (y/n): ") == "y"
        require("simple-surr.surround").surround_selection(style, add_space)
    end, { desc = "Surround selection with custom or predefined style" })

    vim.keymap.set("n", "<leader>sw", function()
        local style = vim.fn.input("Enter surround style (e.g., [, {, (, }, ', \", `, custom): ")
        local add_space = vim.fn.input("Add spaces inside? (y/n): ") == "y"
        require("simple-surr.surround").surround_word(style, add_space)
    end, { desc = "Surround word under cursor with custom or predefined style" })
end

return M
