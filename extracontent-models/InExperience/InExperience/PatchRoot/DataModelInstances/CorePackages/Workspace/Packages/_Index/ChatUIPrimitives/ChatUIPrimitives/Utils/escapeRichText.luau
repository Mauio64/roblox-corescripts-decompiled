local t1 = {
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;",
	["'"] = "&apos;"
}

local function escapeRichText(s1: string) -- line: 20
	-- upvalues: t1 (copy)
	local v4 = string.gsub(s1, "&", "&amp;")

	for v5, v6 in t1 do
		v4 = string.gsub(v4, v5, v6)
	end

	return v4
end

return escapeRichText
