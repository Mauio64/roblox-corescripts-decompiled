local v5 = { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;" }

local function escapeRichText(value)
	return (string.gsub(value, "[&<>]", v5))
end

return escapeRichText
