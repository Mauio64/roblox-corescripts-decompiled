local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent
require(InlineRichText.Types)

local TokenName = require(InlineRichText.Enums.TokenName)
local parseXmlAttributes = require(InlineRichText.Parser.parseXmlAttributes)
local escapeRichFormatting = require(InlineRichText.Utils.escapeRichFormatting)
local unescapeRichFormatting = require(InlineRichText.Utils.unescapeRichFormatting)

local SharedFlags = require(parent.SharedFlags)
local FFlagInlineRichTextSkipPlaintextEscape = SharedFlags.FFlagInlineRichTextSkipPlaintextEscape

local _ = { Open = "OPEN", Close = "CLOSE", OpenClose = "OPEN_CLOSE" }

local v = {
	{ name = "OPEN_CLOSE", pattern = "^<([%w-]+)%s?([^>]*)/>" },
	{ name = "OPEN", pattern = "^<([%w-]+)%s?([^>]*)>" },
	{ name = "CLOSE", pattern = "^</([%w-]+)%s?([^>]*)>" }
}

local v2 = {
	OPEN = function(list, text: string, p: string)
		local attributes = parseXmlAttributes(p)
		table.insert(list, { name = TokenName.Open, text = text, attributes = attributes })
	end,
	CLOSE = function(list, text: string)
		table.insert(list, { name = TokenName.Close, text = text, attributes = {} })
	end,
	OPEN_CLOSE = function(list, text: string, p: string)
		local attributes = parseXmlAttributes(p)
		table.insert(list, { name = TokenName.Open, text = text, attributes = attributes })

		table.insert(list, { name = TokenName.Close, text = text, attributes = {} })
	end
}

local function tokenize(value: string)
	local v3 = string.gsub(value, "\n+", " ")
	local v4 = 0
	local v5 = 0
	local result = {}

	for k in string.gmatch(v3, "()<") do
		if k < v4 then
			continue
		end

		v4 = k
		local v6 = false

		for _, v7 in v do
			local name = v7.name
			local pattern = v7.pattern
			local v8, v9 = string.find(v3, pattern, v4)

			if not (v8 and v9) then
				continue
			end

			local v10 = { string.match(v3, pattern, v4) }
			local v11 = v10[1]
			local v12 = v10[2] or ""

			if v11 then
				if v4 ~= v5 then
					local v13 = string.sub(v3, v5, v4 - 1)
					local v14 = { name = TokenName.Text, text = 0, attributes = 0 }
					local text

					if FFlagInlineRichTextSkipPlaintextEscape then
						text = unescapeRichFormatting(v13)
					else
						text = escapeRichFormatting(v13)
					end

					v14.text = text

					v14.attributes = {}
					table.insert(result, v14)
				end

				if v11 == "br" then
					if name == "OPEN" or name == "OPEN_CLOSE" then
						table.insert(result, { name = TokenName.Break, text = "", attributes = {} })
					end
				else
					v2[name](result, v11, v12)
				end

				v4 += v9 - v8 + 1
				v5 = v4
				v6 = true
				break
			end
		end

		if not v6 then
			v4 += 1
		end
	end

	local v6 = #v3 + 1

	if v6 ~= v5 then
		local v7 = string.sub(v3, v5, v6 - 1)
		local v8 = { name = TokenName.Text, text = 0, attributes = 0 }
		local text

		if FFlagInlineRichTextSkipPlaintextEscape then
			text = unescapeRichFormatting(v7)
		else
			text = escapeRichFormatting(v7)
		end

		v8.text = text

		v8.attributes = {}
		table.insert(result, v8)
	end

	if result[1] and result[1].name == TokenName.Text and result[1].text == "" then
		table.remove(result, 1)
	end

	return result
end

return tokenize
