local v5 = {
	["&lt;"] = "<",
	["&gt;"] = ">",
	["&quot;"] = "\"",
	["&apos;"] = "'",
	["&amp;"] = "&"
}

local function unescapeRichFormatting(value)
	return (value:gsub("&%l+;", v5))
end

return unescapeRichFormatting
