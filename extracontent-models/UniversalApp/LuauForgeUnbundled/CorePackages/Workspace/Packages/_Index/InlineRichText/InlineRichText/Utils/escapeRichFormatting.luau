local function escapeRichFormatting(value)
	return (value:gsub("[&<>\"']", {
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
