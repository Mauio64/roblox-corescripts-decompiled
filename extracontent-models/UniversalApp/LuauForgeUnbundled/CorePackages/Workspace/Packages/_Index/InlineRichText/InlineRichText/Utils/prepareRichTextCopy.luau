local fFlagInlineRichTextSkipPlaintextEscape = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/SharedFlags").FFlagInlineRichTextSkipPlaintextEscape

local v5 = utf8.char(8220)
local v6 = utf8.char(8221)
local v7 = utf8.char(8217)

local function decodeQuoteEntities(value)
	return value:gsub("&amp;quot;", "\""):gsub("&amp;apos;", "'"):gsub("&quot;", "\""):gsub("&apos;", "'"):gsub(
		"&#34;",
		"\""
	):gsub(
		"&#39;",
		"'"
	)
end

local function toTypographicQuotesOutsideTags(value)
	local flag = false
	local v8 = {}
	local v9 = true

	for i = 1, #value do
		local v10 = value:sub(i, i)

		if v10 == "<" then
			table.insert(v8, "<")
			flag = true
		elseif v10 == ">" then
			table.insert(v8, ">")
			flag = false
		elseif flag then
			table.insert(v8, v10)
		elseif v10 == "\"" then
			table.insert(v8, if v9 then v5 else v6)
			v9 = not v9
		elseif v10 == "'" then
			table.insert(v8, v7)
		else
			table.insert(v8, v10)
		end
	end

	return table.concat(v8)
end

local function prepareRichTextCopy(p2)
	local v8 = decodeQuoteEntities(p2)

	if fFlagInlineRichTextSkipPlaintextEscape then
		return v8
	end

	return toTypographicQuotesOutsideTags(v8)
end

return prepareRichTextCopy
