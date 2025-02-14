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
	["|"] = { "|", "|" },
  ["</"] = { "</", ">" },
}

function M.add_surround_pair(opening, closing)
	if #opening ~= 1 or #closing ~= 1 then
		print("Surround characters must be single characters.")
		return
	end

	for key, pair in pairs(M.surround_pairs) do
		if (key == opening and pair[2] == closing) or (pair[1] == opening and pair[2] == closing) then
			print("This surround pair already exists: " .. opening .. closing)
			return
		end
	end

	M.surround_pairs[opening] = { opening, closing }
	print("Added surround pair: " .. opening .. closing)
end

local function parse_surround_style(style)
	local opening, closing
	if M.surround_pairs[style] then
		opening, closing = M.surround_pairs[style][1], M.surround_pairs[style][2]
	elseif #style == 1 then
		opening, closing = style, style
	elseif #style == 2 then
		opening, closing = style:sub(1, 1), style:sub(2, 2)
	elseif style == "" then
		return "remove!", "remove!"
	else
		print("Invalid surround style! Use a listed key or one/two custom characters.")
		return nil, nil
	end
	return opening, closing
end

function M.surround_selection(style)
	local opening, closing = parse_surround_style(style)
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
		local selected = line:sub(start_pos[3], end_pos[3])
		local after = line:sub(end_pos[3] + 1)

		line = front .. opening .. selected .. closing .. after
		vim.fn.setline(start_line, line)
		vim.fn.setpos(".", { start_pos[1], start_pos[2], start_pos[3] + #opening, 0 })
		-- vim.cmd("normal! gv")
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
		-- vim.cmd("normal! gv")
	end
	vim.fn.setpos(".", start_pos)
end

function M.surround_word(style)
	local opening, closing = parse_surround_style(style)
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

function M.remove_or_change_surround_word(change)
	local word = vim.fn.expand("<cword>")
	local col_start = vim.fn.col(".")
	local current_line = vim.fn.getline(".")

	local updated_line = current_line:gsub(
		"([%(%)%{%}%[%]%\"'`<>,])%s*" .. vim.pesc(word) .. "%s*([%(%)%{%}%[%]%\"'`<>,])",
		function(opening, closing)
			if change then
				local new_opening, new_closing = parse_surround_style(change)
				return new_opening .. word .. new_closing
			else
				return word
			end
		end,
		1
	)

	if current_line ~= updated_line then
		vim.api.nvim_set_current_line(updated_line)
		vim.fn.cursor(0, col_start)
	else
		print("No surround characters found!")
	end
end

function M.toggle_or_change_surround_selection(style)
	local opening, closing = parse_surround_style(style)
	if not opening or not closing then
		return
	end

	local start_pos = vim.fn.getpos("v")
	local end_pos = vim.fn.getpos(".")
	local start_line = start_pos[2]
	local end_line = end_pos[2]

	local start_line_text = vim.fn.getline(start_line)
	local end_line_text = vim.fn.getline(end_line)
	local first_char = start_line_text:sub(start_pos[3], start_pos[3])
	local last_char = end_line_text:sub(end_pos[3], end_pos[3])

	if not M.surround_pairs[first_char] or M.surround_pairs[first_char][2] ~= last_char then
		print("Error: Selected text is not surrounded by a valid pair!")
		return
	end

	if opening == "remove!" and closing == "remove!" then
		if start_line == end_line then
			local selected = start_line_text:sub(start_pos[3], end_pos[3])
			local front = start_line_text:sub(1, start_pos[3] - 1)
			local after = start_line_text:sub(end_pos[3] + 1)
			local edited = string.sub(selected, 2, -2)
			vim.fn.setline(start_line, front .. edited .. after)
		else
			local first_selected = start_line_text:sub(start_pos[3])
			local last_selected = end_line_text:sub(1, end_pos[3])
			local first_edited = string.sub(first_selected, 2, -1)
			local last_edited = string.sub(last_selected, 1, -2)
			vim.fn.setline(start_line, start_line_text:sub(1, start_pos[3] - 1) .. first_edited)
			vim.fn.setline(end_line, last_edited .. end_line_text:sub(end_pos[3] + 1))
		end
	elseif M.surround_pairs[first_char] and M.surround_pairs[first_char][2] == last_char then
		if start_line == end_line then
			local selected = start_line_text:sub(start_pos[3] + 1, end_pos[3] - 1)
			local front = start_line_text:sub(1, start_pos[3] - 1)
			local after = start_line_text:sub(end_pos[3] + 1)
			vim.fn.setline(start_line, front .. opening .. selected .. closing .. after)
		else
			local first_selected = start_line_text:sub(start_pos[3] + 1)
			local last_selected = end_line_text:sub(1, end_pos[3] - 1)
			vim.fn.setline(start_line, start_line_text:sub(1, start_pos[3] - 1) .. opening .. first_selected)
			vim.fn.setline(end_line, last_selected .. closing .. end_line_text:sub(end_pos[3] + 1))
		end
	else
		print("Error: input character does not have a valid pair!")
	end

	vim.fn.setpos(".", start_pos)
end

return M
