local function extractAndStyleRichTextLinks(s1: string?) -- line: 9
	if s1 == nil then
		return {}, ""
	end

	local t1 = {}

	return t1, (string.gsub(s1, "<a%s+href=\"([^\"]+)\">([^<]*)</a>", function(s2: string, s3: string) -- line: 21
		-- upvalues: t1 (copy)
		table.insert(t1, s2)

		return `<u><b>{ s3 }</b></u>`
	end))
end

return extractAndStyleRichTextLinks
