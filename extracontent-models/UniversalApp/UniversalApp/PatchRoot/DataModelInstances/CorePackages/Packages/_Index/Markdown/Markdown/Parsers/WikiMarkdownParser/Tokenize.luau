local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local insert = table.insert

local function tokenize(s1: string) -- line: 11
	-- upvalues: insert (copy)
	local t1 = {
		["\n"] = {
			{
				"LINE_BREAK",
				"^\n",
				"^\n",
				1
			},
			{
				"HEADING",
				"^[#]+",
				"^([#]+)"
			},
			{
				"DIVIDER",
				"^[-]+[ \t]*\n",
				"^([-]+)[ \t]*\n",
				1
			},
			{
				"DIVIDER",
				"^[=]+[ \t]*\n",
				"^([=]+)[ \t]*\n",
				1
			},
			{
				"BULLET_LIST_ITEM",
				"^%s*%*",
				"^(%s*)(%*)"
			},
			{
				"BULLET_LIST_ITEM_2",
				"^%s*-",
				"^(%s*)(-)"
			},
			{
				"CODE_BLOCK",
				"^```[%w]*\n.-```",
				"^```([%w]*)\n(.-)```"
			},
			{
				"CODE_BLOCK",
				"^```[%w]*\n.+$",
				"^```([%w]*)\n(.+)$"
			},
			{
				"QUOTE",
				"^%s*>"
			},
			{
				"ORDERED_LIST_ITEM",
				"^%s*[0-9A-Za-z]+%.",
				"^(%s*)([0-9A-Za-z]+)%."
			},
			{
				"TABLE_ROW",
				"^|"
			}
		},
		["\\"] = {{
			"ESCAPE",
			"^\\.",
			"^\\(.)"
		}},
		["-"] = {{
			"TABLE_HEADER",
			"^[-]+"
		}},
		["="] = {{
			"TABLE_HEADER_2",
			"^[=]+"
		}},
		["!"] = {{
			"IMAGE",
			"^!%[[^%]]+%]%([^%)]+%)",
			"^!%[([^%]]+)%]%(([^%)]+)%)"
		}},
		["|"] = {{
			"TABLE_DIVIDER",
			"^|"
		}},
		["<"] = {
			{
				"OPEN_CLOSE",
				"^<[^>]*/>",
				"^<([%w-]+)%s?([^>]*)/>"
			},
			{
				"CLOSE",
				"^</[^>]*>",
				"^</([%w-]+)%s?([^>]*)>"
			},
			{
				"OPEN",
				"^<[^>]*>",
				"^<([%w-]+)%s?([^>]*)>"
			}
		},
		["*"] = {
			{
				"BOLD_2",
				"^%*%*"
			},
			{
				"BOLD",
				"^%*"
			}
		},
		_ = {
			{
				"ITALIC_2",
				"^__"
			},
			{
				"ITALIC",
				"^_"
			}
		},
		["~"] = {{
			"STRIKE",
			"^~"
		}},
		["["] = {
			{
				"LINK",
				"^%[[^%]]+%]%([^%)]+%)",
				"^%[([^%]]+)%]%(([^%)]+)%)"
			},
			{
				"ACTION",
				"^%[%[[^%]]+%]%]",
				"^%[%[([^%]]+)%]%]"
			}
		},
		["`"] = {
			{
				"INLINE_CODE",
				"^`[^\n`]*`",
				"^`([^\n`]*)`"
			},
			{
				"INLINE_CODE",
				"^`[^\n`]+$",
				"^`([^\n`]+)$"
			}
		}
	}
	local n1 = 0
	local n2 = 0
	local t2 = {}

	while n1 <= #s1 do
		local v9 = if n1 ~= 0 then s1:sub(n1, n1) else "\n"
		local v10 = t1[v9]
		local v11 = false

		if v10 then
			local v12 = v9 ~= "\n" and 0 or 1
			local v13 = s1:sub(n1 + v12)

			for _, v15 in v10 do
				local v16 = v13:match(v15[2])

				if v16 then
					local v17 = v15[1]
					local v18 = v15[3]
					local v19 = v15[4] or 0
					local v20 = #v16 - v19

					if n1 ~= n2 then
						insert(t2, {
							name = "TEXT",
							text = s1:sub(n2, n1 - 1),
							offset = n2
						})
					end

					insert(t2, {
						name = v17,
						text = v16,
						capture = if not v18 then nil else { v13:match(v18) },
						isBlock = v9 == "\n",
						offset = n1
					})
					n1 += v12 + v20
					n2 = n1
					v11 = true

					break
				end
			end
		end

		if not v11 then
			n1 += 1
		end
	end

	if n1 ~= n2 then
		insert(t2, {
			name = "TEXT",
			text = s1:sub(n2, n1 - 1),
			offset = n2
		})
	end

	return t2
end

return tokenize
