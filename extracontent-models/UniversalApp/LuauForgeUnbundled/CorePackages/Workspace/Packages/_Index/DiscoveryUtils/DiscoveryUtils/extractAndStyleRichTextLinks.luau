local function extractAndStyleRichTextLinks(value)
	if value == nil then
		return {}, ""
	end

	local v5 = {}

	return v5, (string.gsub(value, "<a%s+href=\"([^\"]+)\">([^<]*)</a>", function(p2, p3)
		table.insert(v5, p2)
		return `<u><b>{p3}</b></u>`
	end))
end

return extractAndStyleRichTextLinks
