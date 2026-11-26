local v5 = {
	["&"] = "&amp;",
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;",
	["'"] = "&apos;"
}

local function escapeRichText(value)
	return (string.gsub(value, "[&<>\"']", v5))
end

return escapeRichText
