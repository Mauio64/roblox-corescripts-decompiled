require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

local TokenName = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/TokenName")
local parseXmlAttributes = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Parser/parseXmlAttributes")
local escapeRichFormatting = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Utils/escapeRichFormatting")
local unescapeRichFormatting = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Utils/unescapeRichFormatting")

local fFlagInlineRichTextSkipPlaintextEscape = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/SharedFlags").FFlagInlineRichTextSkipPlaintextEscape

local v5 = { Open = "OPEN", Close = "CLOSE", OpenClose = "OPEN_CLOSE" }

local v6 = {
	{ name = "OPEN_CLOSE", pattern = "^<([%w-]+)%s?([^>]*)/>" },
	{ name = "OPEN", pattern = "^<([%w-]+)%s?([^>]*)>" },
	{ name = "CLOSE", pattern = "^</([%w-]+)%s?([^>]*)>" }
}

local v7 = {
	OPEN = function(list, p2, p3)
		local v8 = parseXmlAttributes(p3)
		table.insert(list, { name = TokenName.Open, text = p2, attributes = v8 })
	end,
	CLOSE = function(list, p2)
		table.insert(list, { name = TokenName.Close, text = p2, attributes = {} })
	end,
	OPEN_CLOSE = function(list, p2, p3)
		local v8 = parseXmlAttributes(p3)
		table.insert(list, { name = TokenName.Open, text = p2, attributes = v8 })

		table.insert(list, { name = TokenName.Close, text = p2, attributes = {} })
	end
}

local function tokenize(value)
	local v8 = string.gsub(value, "\n+", " ")
	local v9 = 0
	local v10 = 0
	local result = {}

	for k in string.gmatch(v8, "()<") do
		if k < v9 then
			continue
		end

		v9 = k
		local v11 = false

		for k2, v13 in v6 do
			local name = v13.name
			local pattern = v13.pattern
			local v14, v15 = string.find(v8, pattern, v9)

			if not (v14 and v15) then
				continue
			end

			local v16 = { string.match(v8, pattern, v9) }
			local v17 = v16[1]
			local v18 = v16[2] or ""

			if v17 then
				if v9 ~= v10 then
					local v19 = string.sub(v8, v10, v9 - 1)
					local v20 = { name = TokenName.Text, text = 0, attributes = 0 }

					local v21 = if fFlagInlineRichTextSkipPlaintextEscape then unescapeRichFormatting(v19) else escapeRichFormatting(v19)
					v20.text = v21

					v20.attributes = {}
					table.insert(result, v20)
				end

				if v17 == "br" then
					if name == "OPEN" or name == "OPEN_CLOSE" then
						table.insert(result, {
							name = TokenName.Break,
							text = "",
							attributes = {}
						})
					end
				else
					v7[name](result, v17, v18)
				end

				v9 += v15 - v14 + 1
				v10 = v9
				v11 = true
				break
			end
		end

		if not v11 then
			v9 += 1
		end
	end

	local v11 = #v8 + 1

	if v11 ~= v10 then
		local v12 = string.sub(v8, v10, v11 - 1)
		local v13 = { name = TokenName.Text, text = 0, attributes = 0 }

		local v14 = if fFlagInlineRichTextSkipPlaintextEscape then unescapeRichFormatting(v12) else escapeRichFormatting(v12)
		v13.text = v14

		v13.attributes = {}
		table.insert(result, v13)
	end

	if result[1] and result[1].name == TokenName.Text and result[1].text == "" then
		table.remove(result, 1)
	end

	return result
end

return tokenize
