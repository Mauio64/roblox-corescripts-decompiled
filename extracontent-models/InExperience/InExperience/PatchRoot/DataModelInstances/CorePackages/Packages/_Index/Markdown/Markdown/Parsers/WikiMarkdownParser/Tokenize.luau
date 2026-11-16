local Markdown = script:FindFirstAncestor("Markdown")
require(Markdown.Types)

local insert = table.insert

local function tokenize(value: string)
	local total = 0
	local v = {
		["\n"] = {
			{ "LINE_BREAK", "^\n", "^\n", 1 },
			{ "HEADING", "^[#]+", "^([#]+)" },
			{ "DIVIDER", "^[-]+[ \t]*\n", "^([-]+)[ \t]*\n", 1 },
			{ "DIVIDER", "^[=]+[ \t]*\n", "^([=]+)[ \t]*\n", 1 },
			{ "BULLET_LIST_ITEM", "^%s*%*", "^(%s*)(%*)" },
			{ "BULLET_LIST_ITEM_2", "^%s*-", "^(%s*)(-)" },
			{ "CODE_BLOCK", "^```[%w]*\n.-```", "^```([%w]*)\n(.-)```" },
			{ "CODE_BLOCK", "^```[%w]*\n.+$", "^```([%w]*)\n(.+)$" },
			{ "QUOTE", "^%s*>" },
			{ "ORDERED_LIST_ITEM", "^%s*[0-9]+%.[ \t]+", "^(%s*)([0-9]+)%.[ \t]+" },
			{ "ORDERED_LIST_ITEM", "^%s*[A-Za-z]%.[ \t]+", "^(%s*)([A-Za-z])%.[ \t]+" },
			{ "TABLE_ROW", "^|" }
		},
		["\\"] = {
			{ "ESCAPE", "^\\.", "^\\(.)" }
		},
		["-"] = {
			{ "TABLE_HEADER", "^[-]+" }
		},
		["="] = {
			{ "TABLE_HEADER_2", "^[=]+" }
		},
		["!"] = {
			{ "IMAGE", "^!%[[^%]]+%]%([^%)]+%)", "^!%[([^%]]+)%]%(([^%)]+)%)" }
		},
		["|"] = {
			{ "TABLE_DIVIDER", "^|" }
		},
		["<"] = {
			{ "OPEN_CLOSE", "^<[^>]*/>", "^<([%w-]+)%s?([^>]*)/>" },
			{ "CLOSE", "^</[^>]*>", "^</([%w-]+)%s?([^>]*)>" },
			{ "OPEN", "^<[^>]*>", "^<([%w-]+)%s?([^>]*)>" }
		},
		["*"] = {
			{ "BOLD_2", "^%*%*" },
			{ "BOLD", "^%*" }
		},
		_ = {
			{ "ITALIC_2", "^__" },
			{ "ITALIC", "^_" }
		},
		["~"] = {
			{ "STRIKE", "^~" }
		},
		["["] = {
			{ "LINK", "^%[[^%]]+%]%([^%)]+%)", "^%[([^%]]+)%]%(([^%)]+)%)" },
			{ "ACTION", "^%[%[[^%]]+%]%]", "^%[%[([^%]]+)%]%]" }
		},
		["`"] = {
			{ "INLINE_CODE", "^`[^\n`]*`", "^`([^\n`]*)`" },
			{ "INLINE_CODE", "^`[^\n`]+$", "^`([^\n`]+)$" }
		}
	}
	local offset = 0
	local result = {}

	while total <= #value do
		local v2 = total == 0 and "\n" or value:sub(total, total)

		local v3 = v[v2]
		local v4 = false

		if v3 then
			local v5 = v2 == "\n" and 1 or 0
			local v6 = value:sub(total + v5)

			for _, v7 in v3 do
				local match = v6:match(v7[2])

				if match then
					local name = v7[1]

					local v8 = v7[3]

					local v9 = v7[4] or 0
					local v10 = #match - v9

					if total ~= offset then
						insert(result, {
							name = "TEXT",
							text = value:sub(offset, total - 1),
							offset = offset
						})
					end

					insert(result, {
						name = name,
						text = match,
						capture = v8 and { v6:match(v8) } or nil,
						isBlock = v2 == "\n",
						offset = total
					})

					total += v5 + v10
					offset = total
					v4 = true
					break
				end
			end
		end

		if not v4 then
			total += 1
		end
	end

	if total ~= offset then
		insert(result, {
			name = "TEXT",
			text = value:sub(offset, total - 1),
			offset = offset
		})
	end

	return result
end

return tokenize
