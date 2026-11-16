local v = {
	["&"] = "&amp;",
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;",
	["'"] = "&apos;"
}

local function escapeRichText(value: string)
	return (string.gsub(value, "[&<>\"']", v))
end

return escapeRichText
