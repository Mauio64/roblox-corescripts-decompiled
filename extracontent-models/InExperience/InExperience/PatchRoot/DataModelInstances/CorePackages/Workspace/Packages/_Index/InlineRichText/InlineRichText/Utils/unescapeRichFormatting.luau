local v = {
	["&lt;"] = "<",
	["&gt;"] = ">",
	["&quot;"] = "\"",
	["&apos;"] = "'",
	["&amp;"] = "&"
}

local function unescapeRichFormatting(value: string)
	return (value:gsub("&%l+;", v))
end

return unescapeRichFormatting
