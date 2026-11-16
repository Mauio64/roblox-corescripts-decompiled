local parent = script:FindFirstAncestor("InlineRichText").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagInlineRichTextSkipPlaintextEscape = SharedFlags.FFlagInlineRichTextSkipPlaintextEscape

local v = utf8.char(8220)
local v2 = utf8.char(8221)
local v3 = utf8.char(8217)

local function decodeQuoteEntities(value: string)
	return value:gsub("&amp;quot;", "\""):gsub("&amp;apos;", "'"):gsub("&quot;", "\""):gsub("&apos;", "'"):gsub(
		"&#34;",
		"\""
	):gsub(
		"&#39;",
		"'"
	)
end

local function toTypographicQuotesOutsideTags(value: string)
	local flag = false
	local v4 = {}
	local v5 = true

	for i = 1, #value do
		local v6 = value:sub(i, i)

		if v6 == "<" then
			table.insert(v4, "<")
			flag = true
		elseif v6 == ">" then
			table.insert(v4, ">")
			flag = false
		elseif flag then
			table.insert(v4, v6)
		elseif v6 == "\"" then
			local v7 = if v5 then v else v2
			table.insert(v4, v7)
			v5 = not v5
		elseif v6 == "'" then
			table.insert(v4, v3)
		else
			table.insert(v4, v6)
		end
	end

	return table.concat(v4)
end

local function prepareRichTextCopy(p: string)
	local v4 = decodeQuoteEntities(p)

	if FFlagInlineRichTextSkipPlaintextEscape then
		return v4
	end

	return toTypographicQuotesOutsideTags(v4)
end

return prepareRichTextCopy
