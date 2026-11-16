local v = { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;" }

local function escapeRichText(value: string)
	return (string.gsub(value, "[&<>]", v))
end

return escapeRichText
