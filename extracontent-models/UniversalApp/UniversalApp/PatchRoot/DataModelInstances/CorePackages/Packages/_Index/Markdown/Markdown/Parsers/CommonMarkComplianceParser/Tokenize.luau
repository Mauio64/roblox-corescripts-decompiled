local Markdown = script:FindFirstAncestor("Markdown")

require(Markdown.Types)

local Constants = require(script.Parent.Parent.Constants)
local PostProcessTokens = require(script.Parent.PostProcessTokens)
local Utils = require(script.Parent.Utils)
local insert = table.insert
local t1 = {
	{
		"BREAK",
		"^\\\n"
	},
	{
		"ESCAPE",
		"^\\(%p)"
	}
}
local t2 = {{
	"IMAGE",
	"^!%[([^%]]+)%]%(([^%)]+)%)"
}}
local t3 = {
	{
		"OPEN_CLOSE",
		"^<([%w-]+)%s?([^>]*)/>"
	},
	{
		"CLOSE",
		"^</([%w-]+)%s?([^>]*)>"
	},
	{
		"OPEN",
		"^<([%w-]+)%s?([^>]*)>"
	}
}
local t4 = {
	{
		"BOLD_2",
		"^%*%*"
	},
	{
		"BOLD",
		"^%*"
	}
}
local t5 = {
	{
		"ITALIC_2",
		"^__"
	},
	{
		"ITALIC",
		"^_"
	}
}
local t6 = {{
	"STRIKE",
	"^~"
}}
local t7 = {{
	"INLINE_CODE",
	"^`"
}}
local t8 = {
	["\\"] = t1,
	["!"] = t2,
	["<"] = t3,
	["*"] = t4,
	_ = t5,
	["~"] = t6,
	["`"] = t7
}
local t9 = {
	["\n"] = {
		{
			"LINE_BREAK",
			"^\n",
			1
		},
		{
			"HEADING",
			"^ ? ? ?(##?#?#?#?#?)[ \t]+",
			1
		},
		{
			"HEADING",
			"^ ? ? ?(##?#?#?#?#?)\n",
			1
		},
		{
			"DIVIDER",
			"^ ? ? ?%-[ \t]*%-[ \t]*%-[ \t]*[%- \t]*\n",
			1
		},
		{
			"DIVIDER",
			"^ ? ? ?%*[ \t]*%*[ \t]*%*[ \t]*[%* \t]*\n",
			1
		},
		{
			"DIVIDER",
			"^ ? ? ?_[ \t]*_[ \t]*_[ \t]*[_ \t]*\n",
			1
		},
		{
			"BULLET_LIST_ITEM",
			"^(%s*)(%* )"
		},
		{
			"BULLET_LIST_ITEM_2",
			"^(%s*)(- )"
		},
		{
			"CODE_BLOCK",
			"^```[ \t]*([^\n]*)[ \t]*\n(.-)```"
		},
		{
			"CODE_BLOCK",
			"^```[ \t]*([^\n]*)[ \t]*\n(.+)$"
		},
		{
			"CODE_BLOCK",
			"^~~~[ \t]*([^\n]*)[ \t]*\n(.-)~~~"
		},
		{
			"CODE_BLOCK",
			"^~~~[ \t]*([^\n]*)[ \t]*\n(.+)$"
		},
		{
			"QUOTE",
			"^%s*>"
		},
		{
			"ORDERED_LIST_ITEM",
			"^(%s*)([0-9A-Za-z]+)%."
		},
		{
			"TABLE_ROW",
			"^|"
		}
	},
	["\\"] = t1,
	["-"] = {{
		"TABLE_HEADER",
		"^[-]+"
	}},
	["="] = {{
		"TABLE_HEADER_2",
		"^[=]+"
	}},
	["!"] = t2,
	["|"] = {{
		"TABLE_DIVIDER",
		"^|"
	}},
	["<"] = t3,
	["*"] = t4,
	_ = t5,
	["~"] = t6,
	["["] = {
		{
			"LINK",
			"^%[([^%]]*)%]%([ \t]*([^\n\t ]+)[ \t]\"([^\n]+)\"[ \t]*%)"
		},
		{
			"LINK",
			"^%[([^%]]*)%]%([ \t]*([^\n\t ]+)[ \t]'([^\n]+)'[ \t]*%)"
		},
		{
			"LINK",
			"^%[([^%]]*)%]%([ \t]*([^\n\t ]+)[ \t]%(([^\n]+)%)[ \t]*%)"
		},
		{
			"LINK",
			"^%[([^%]]*)%]%([ \t]*%)"
		},
		{
			"LINK",
			"^%[([^%]]*)%]%([ \t]*<>[ \t]*%)"
		},
		{
			"LINK",
			"^%[([^%]]*)%]%([ \t]*<([^\n\t]+)>[ \t]*%)"
		},
		{
			"LINK",
			"^%[([^%]]*)%]%([ \t]*([^\n\t ]+)[ \t]*%)"
		},
		{
			"ACTION",
			"^%[%[([^%]]+)%]%]"
		}
	},
	["`"] = t7
}
local t10 = {
	LINK = {
		startToken = "LINK_START",
		endToken = "LINK_END",
		textStartOffset = 1,
		mapToText = function(p1) -- line: 102
			return p1.capture and p1.capture[1] or ""
		end
	}
}
local t11 = {{
	"HEADING",
	"^  ? ?(#+)%s*\n",
	1
}}

local function tokenizeTextSpan(s1: string, n1: number, b1: boolean, p2) -- line: 116
	-- upvalues: t8 (copy), t9 (copy), t11 (copy), Utils (copy), Constants (copy), insert (copy), PostProcessTokens (copy)
	local n2 = 0
	local n3 = 0
	local n4 = 0
	local t12 = {}

	while n2 <= #s1 do
		local v28 = if n2 ~= 0 or b1 then string.sub(s1, n2, n2) else "\n"
		local v29 = if not b1 then t9[v28] or t11 else t8[v28] or {}
		local v30 = false
		local n5 = 0

		if v28 == "\n" and not b1 then
			n5 = 1
			n4 = n2
		end

		for _, v33 in v29 do
			local v34 = v33[2]
			local start, stop = string.find(s1, v34, n2 + n5)

			if not start or not stop then
				continue
			end

			local v37 = string.sub(s1, start, stop)
			local v38 = v33[1]
			local v39 = v33[3] or 0
			local v40 = #v37 - v39
			local v41 = nil

			if not b1 then
				local _, stop2 = string.find(v37, "\n[^\n]*$")

				if stop2 then
					n4 = stop2 + start
				end
			end

			if v38 == "ESCAPE" and Utils.isInsideInlineCode(t12, n4) then
				continue
			end

			if Constants.STYLED_TEXT[v38] then
				v41 = Utils.getCharacterContext(s1, n2, n5 + v40)
			end

			local t13 = { string.match(s1, v34, n2 + n5) }

			if not b1 or v28 ~= "<" or not (#t13 > 0) or p2.inlineTags[t13[1]] then
				if n2 ~= n3 then
					insert(t12, {
						name = "TEXT",
						text = string.sub(s1, n3, n2 - 1),
						offset = n3 + n1
					})
				end

				insert(t12, {
					name = v38,
					text = v37,
					capture = if not (#t13 > 0) then nil else t13,
					isBlock = not b1 and v28 == "\n",
					offset = n2 + n1,
					context = v41
				})
				n2 += n5 + v40
				n3 = n2
				v30 = true

				break
			end
		end

		if not v30 then
			n2 += 1
		end
	end

	if n2 ~= n3 then
		insert(t12, {
			name = "TEXT",
			text = string.sub(s1, n3, n2 - 1),
			offset = n3 + n1
		})
	end

	return PostProcessTokens(t12)
end
local function tokenize(s2: string, p3) -- line: 218
	-- upvalues: tokenizeTextSpan (copy), t10 (copy), insert (copy)
	local t14 = {}

	for _, v49 in (tokenizeTextSpan(s2, 0, false, p3)) do
		local v50 = t10[v49.name]

		if v50 then
			local t15 = {{
				name = v50.startToken,
				offset = v49.offset,
				text = string.sub(s2, v49.offset, v49.offset + v50.textStartOffset - 1),
				capture = v49.capture
			}}
			local v52 = v50.mapToText(v49)
			local v53 = tokenizeTextSpan(v52, v49.offset + v50.textStartOffset, true, p3)

			table.move(v53, 1, #v53, 2, t15)

			local v54 = v49.offset + v50.textStartOffset + #v52

			insert(t15, {
				name = v50.endToken,
				offset = v54,
				text = string.sub(s2, v54, v49.offset + #v49.text - 1)
			})
			table.move(t15, 1, #t15, #t14 + 1, t14)
		else
			insert(t14, v49)
		end
	end

	return t14
end

return tokenize
