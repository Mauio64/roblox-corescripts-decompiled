local function decodeLuauUnicodeEscapes(value)
	return (value:gsub("\\u{(%x+)}", function(p2)
		local v5 = tonumber(p2, 16)

		if v5 == nil or v5 < 0 or v5 > 1114111 or v5 >= 55296 and v5 <= 57343 then
			return ""
		end

		return utf8.char(v5)
	end))
end

local function decodeInlineRichTextEntities(value)
	return value:gsub("&amp;lt;", "<"):gsub("&amp;gt;", ">"):gsub("&amp;quot;", "\""):gsub(
		"&amp;apos;",
		"'"
	):gsub(
		"&amp;amp;",
		"&"
	):gsub(
		"&lt;",
		"<"
	):gsub(
		"&gt;",
		">"
	):gsub(
		"&quot;",
		"\""
	):gsub(
		"&apos;",
		"'"
	):gsub(
		"&amp;",
		"&"
	)
end

local function replaceQuotesOutsideTags(value)
	local v5 = {}
	local v6 = false
	local v7 = true

	for i = 1, #value do
		local v8 = value:sub(i, i)

		if v8 == "<" then
			table.insert(v5, "<")
			v6 = true
		elseif v8 == ">" then
			table.insert(v5, ">")
			v6 = false
		elseif v8 == "\"" and not v6 then
			local v9 = if v7 then utf8.char(8220) else utf8.char(8221)
			table.insert(v5, v9)
			v7 = not v7
		else
			table.insert(v5, v8)
		end
	end

	return table.concat(v5)
end

local function prepareRichText(value)
	return replaceQuotesOutsideTags(decodeInlineRichTextEntities(value:gsub("\\u{(%x+)}", function(p2)
		local v5 = tonumber(p2, 16)

		if v5 == nil or v5 < 0 or v5 > 1114111 or v5 >= 55296 and v5 <= 57343 then
			return ""
		end

		return utf8.char(v5)
	end)))
end

return prepareRichText
