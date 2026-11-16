local Escape = {}

function Escape.escapeRichFormatting(value: string)
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

function Escape.unescapeRichFormatting(value: string)
	return value:gsub("&%l+;", {
		["&lt;"] = "<",
		["&gt;"] = ">",
		["&quot;"] = "\"",
		["&apos;"] = "'",
		["&amp;"] = "&"
	})
end

return Escape
