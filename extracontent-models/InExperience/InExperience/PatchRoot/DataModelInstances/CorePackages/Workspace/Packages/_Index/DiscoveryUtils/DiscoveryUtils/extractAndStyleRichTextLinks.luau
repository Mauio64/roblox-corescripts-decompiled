local function extractAndStyleRichTextLinks(value: string?)
	if value == nil then
		return {}, ""
	end

	local v = {}

	return v, (string.gsub(value, "<a%s+href=\"([^\"]+)\">([^<]*)</a>", function(p: string, p2: string)
		table.insert(v, p)
		return `<u><b>{p2}</b></u>`
	end))
end

return extractAndStyleRichTextLinks
