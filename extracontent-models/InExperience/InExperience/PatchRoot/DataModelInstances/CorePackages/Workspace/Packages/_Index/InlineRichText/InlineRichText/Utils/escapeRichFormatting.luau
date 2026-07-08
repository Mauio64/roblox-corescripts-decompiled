local function escapeRichFormatting(s1: string) -- line: 2
	return (s1:gsub("[&<>\"']", {
		["&"] = "&amp;",
		["<"] = "&lt;",
		[">"] = "&gt;",
		["\""] = "&quot;",
		["'"] = "&apos;"
	}):gsub("&amp;%l+;", {
		["&amp;lt;"] = "&lt;",
		["&amp;gt;"] = "&gt;",
		["&amp;quot;"] = "&quot;",
		["&amp;apos;"] = "&apos;",
		["&amp;amp;"] = "&amp;"
	}))
end

return escapeRichFormatting
